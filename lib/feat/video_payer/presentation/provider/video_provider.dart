import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import '../../domain/videolist_model.dart';

class VideoPlayerState {
  final VideoPlayerController? videoController;
  final ChewieController? chewieController;
  final bool isInitialized;
  final bool isLoading;
  final String? error;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final int currentVideoIndex;
  final bool autoPlayNext;
  final String currentVideoUrl;

  // Time tracking fields
  final Duration totalWatchTime;
  final DateTime? sessionStartTime;
  final List<TimeTrackingEvent> trackingEvents;
  final double watchPercentage;
  final Duration lastTrackedPosition;
  final bool isTrackingEnabled;

  const VideoPlayerState({
    this.videoController,
    this.chewieController,
    this.isInitialized = false,
    this.isLoading = false,
    this.error,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.currentVideoIndex = 0,
    this.autoPlayNext = true,
    this.currentVideoUrl = '',
    this.totalWatchTime = Duration.zero,
    this.sessionStartTime,
    this.trackingEvents = const [],
    this.watchPercentage = 0.0,
    this.lastTrackedPosition = Duration.zero,
    this.isTrackingEnabled = true,
  });

  VideoPlayerState copyWith({
    VideoPlayerController? videoController,
    ChewieController? chewieController,
    bool? isInitialized,
    bool? isLoading,
    String? error,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    int? currentVideoIndex,
    bool? autoPlayNext,
    String? currentVideoUrl,
    Duration? totalWatchTime,
    DateTime? sessionStartTime,
    List<TimeTrackingEvent>? trackingEvents,
    double? watchPercentage,
    Duration? lastTrackedPosition,
    bool? isTrackingEnabled,
  }) {
    return VideoPlayerState(
      videoController: videoController ?? this.videoController,
      chewieController: chewieController ?? this.chewieController,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      currentVideoIndex: currentVideoIndex ?? this.currentVideoIndex,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
      currentVideoUrl: currentVideoUrl ?? this.currentVideoUrl,
      totalWatchTime: totalWatchTime ?? this.totalWatchTime,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      trackingEvents: trackingEvents ?? this.trackingEvents,
      watchPercentage: watchPercentage ?? this.watchPercentage,
      lastTrackedPosition: lastTrackedPosition ?? this.lastTrackedPosition,
      isTrackingEnabled: isTrackingEnabled ?? this.isTrackingEnabled,
    );
  }

  bool get hasNextVideo => currentVideoIndex < videos.length - 1;

  bool get hasPreviousVideo => currentVideoIndex > 0;
}

class TimeTrackingEvent {
  final DateTime timestamp;
  final String eventType;
  final Duration position;
  final String? additionalData;

  const TimeTrackingEvent({
    required this.timestamp,
    required this.eventType,
    required this.position,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'eventType': eventType,
      'position': position.inSeconds,
      'additionalData': additionalData,
    };
  }
}

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerNotifier() : super(const VideoPlayerState());

  Timer? _timeTrackingTimer;
  DateTime? _playStartTime;
  Duration _cumulativeWatchTime = Duration.zero;

  Future<void> initializeVideo(String videoUrl, {int? videoIndex}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _disposeControllers();
      _stopTimeTracking();

      int index = videoIndex ?? _findVideoIndex(videoUrl);

      final videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      await videoController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        looping: false,
        showControls: true,
        allowFullScreen: true,
        allowMuting: true,
        showControlsOnInitialize: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blueAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightBlue,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 42),
                const SizedBox(height: 16),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
              ],
            ),
          );
        },
      );

      videoController.addListener(_updatePlayerState);

      state = state.copyWith(
        videoController: videoController,
        chewieController: chewieController,
        isInitialized: true,
        isLoading: false,
        duration: videoController.value.duration,
        currentVideoIndex: index,
        currentVideoUrl: videoUrl,
        isPlaying: true,
        sessionStartTime: DateTime.now(),
        totalWatchTime: Duration.zero,
        trackingEvents: [],
        watchPercentage: 0.0,
        lastTrackedPosition: Duration.zero,
      );

      if (state.isTrackingEnabled) {
        _startTimeTracking();
        _addTrackingEvent('video_start', Duration.zero);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load video: ${e.toString()}',
      );
    }
  }

  void _startTimeTracking() {
    _timeTrackingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimeTracking();
    });
  }

  void _stopTimeTracking() {
    _timeTrackingTimer?.cancel();
    _timeTrackingTimer = null;

    if (_playStartTime != null && state.isPlaying) {
      final sessionTime = DateTime.now().difference(_playStartTime!);
      _cumulativeWatchTime += sessionTime;
      _playStartTime = null;
    }
  }

  void _updateTimeTracking() {
    if (!state.isInitialized || !state.isTrackingEnabled) return;

    final currentPosition = state.position;
    final duration = state.duration;

    if (duration.inSeconds > 0) {
      final newWatchPercentage =
          (currentPosition.inSeconds / duration.inSeconds) * 100;

      Duration totalWatchTime = _cumulativeWatchTime;
      if (_playStartTime != null && state.isPlaying) {
        totalWatchTime += DateTime.now().difference(_playStartTime!);
      }

      state = state.copyWith(
        watchPercentage: newWatchPercentage,
        totalWatchTime: totalWatchTime,
        lastTrackedPosition: currentPosition,
      );

      _checkAndTrackMilestones(newWatchPercentage, currentPosition);

      if (currentPosition.inSeconds % 30 == 0 &&
          currentPosition != state.lastTrackedPosition) {
        _addTrackingEvent(
          'time_update',
          currentPosition,
          additionalData:
              'watch_percentage:${newWatchPercentage.toStringAsFixed(1)}',
        );
      }
    }
  }

  void _checkAndTrackMilestones(double percentage, Duration position) {
    final milestones = [25.0, 50.0, 75.0, 90.0, 100.0];

    for (double milestone in milestones) {
      if (percentage >= milestone) {
        bool alreadyTracked = state.trackingEvents.any(
          (event) =>
              event.eventType == 'milestone' &&
              event.additionalData?.contains('milestone:$milestone') == true,
        );

        if (!alreadyTracked) {
          _addTrackingEvent(
            'milestone',
            position,
            additionalData: 'milestone:$milestone',
          );

          _sendMilestoneToAnalytics(milestone, position);
        }
      }
    }
  }

  void _addTrackingEvent(
    String eventType,
    Duration position, {
    String? additionalData,
  }) {
    final event = TimeTrackingEvent(
      timestamp: DateTime.now(),
      eventType: eventType,
      position: position,
      additionalData: additionalData,
    );

    final updatedEvents = [...state.trackingEvents, event];
    state = state.copyWith(trackingEvents: updatedEvents);

    print(
      'Video Tracking Event: ${event.eventType} at ${_formatDuration(position)} - ${event.additionalData ?? ''}',
    );

    _sendTrackingEventToAnalytics(event);
  }

  void _sendTrackingEventToAnalytics(TimeTrackingEvent event) {
    print('Analytics: ${event.toJson()}');
  }

  void _sendMilestoneToAnalytics(double milestone, Duration position) {
    final videoData =
        videos.isNotEmpty && state.currentVideoIndex < videos.length
            ? videos[state.currentVideoIndex]
            : {};

    print(
      'Video Milestone: $milestone% reached at ${_formatDuration(position)} for "${videoData['title'] ?? 'Unknown'}"',
    );

    final analyticsData = {
      'milestone_percentage': milestone,
      'position_seconds': position.inSeconds,
      'video_title': videoData['title'] ?? 'Unknown',
      'video_duration': state.duration.inSeconds,
      'total_watch_time': state.totalWatchTime.inSeconds,
      'session_id': state.sessionStartTime?.millisecondsSinceEpoch.toString(),
    };

    print('Milestone Analytics: $analyticsData');
  }

  int _findVideoIndex(String videoUrl) {
    for (int i = 0; i < videos.length; i++) {
      if (videos[i]['url'] == videoUrl) {
        return i;
      }
    }
    return 0;
  }

  void _updatePlayerState() {
    final controller = state.videoController;
    if (controller != null) {
      final wasPlaying = state.isPlaying;
      final isNowPlaying = controller.value.isPlaying;

      if (wasPlaying != isNowPlaying) {
        if (isNowPlaying) {
          _playStartTime = DateTime.now();
          _addTrackingEvent('play', controller.value.position);
        } else {
          if (_playStartTime != null) {
            _cumulativeWatchTime += DateTime.now().difference(_playStartTime!);
            _playStartTime = null;
          }
          _addTrackingEvent('pause', controller.value.position);
        }
      }

      final newState = state.copyWith(
        isPlaying: isNowPlaying,
        position: controller.value.position,
        duration: controller.value.duration,
      );

      if (!controller.value.isPlaying &&
          controller.value.position >= controller.value.duration &&
          controller.value.duration > Duration.zero) {
        _addTrackingEvent('complete', controller.value.duration);

        if (state.autoPlayNext && state.hasNextVideo) {
          _playNextVideo();
        }
      }

      state = newState;
    }
  }

  Future<void> _playNextVideo() async {
    if (state.hasNextVideo) {
      final nextIndex = state.currentVideoIndex + 1;
      final nextVideo = videos[nextIndex];
      await initializeVideo(nextVideo['url']!, videoIndex: nextIndex);
    }
  }

  Future<void> playNextVideo() async {
    await _playNextVideo();
  }

  Future<void> playPreviousVideo() async {
    if (state.hasPreviousVideo) {
      final previousIndex = state.currentVideoIndex - 1;
      final previousVideo = videos[previousIndex];
      await initializeVideo(previousVideo['url']!, videoIndex: previousIndex);
    }
  }

  Future<void> playVideoAtIndex(int index) async {
    if (index >= 0 && index < videos.length) {
      final video = videos[index];
      await initializeVideo(video['url']!, videoIndex: index);
    }
  }

  void toggleAutoPlayNext() {
    state = state.copyWith(autoPlayNext: !state.autoPlayNext);
  }

  Future<void> play() async {
    await state.videoController?.play();
  }

  Future<void> pause() async {
    await state.videoController?.pause();
  }

  Future<void> seekTo(Duration position) async {
    await state.videoController?.seekTo(position);
    _addTrackingEvent(
      'seek',
      position,
      additionalData: 'from:${state.position.inSeconds}',
    );
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void toggleTimeTracking() {
    final newTrackingState = !state.isTrackingEnabled;
    state = state.copyWith(isTrackingEnabled: newTrackingState);

    if (newTrackingState) {
      _startTimeTracking();
    } else {
      _stopTimeTracking();
    }
  }

  Map<String, dynamic> getTrackingSummary() {
    return {
      'total_watch_time_seconds': state.totalWatchTime.inSeconds,
      'watch_percentage': state.watchPercentage,
      'video_duration_seconds': state.duration.inSeconds,
      'session_start_time': state.sessionStartTime?.toIso8601String(),
      'events_count': state.trackingEvents.length,
      'milestones_reached':
          state.trackingEvents
              .where((e) => e.eventType == 'milestone')
              .map((e) => e.additionalData)
              .toList(),
      'current_video':
          state.currentVideoIndex < videos.length
              ? videos[state.currentVideoIndex]['title']
              : 'Unknown',
    };
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _disposeControllers() async {
    _stopTimeTracking();
    state.videoController?.removeListener(_updatePlayerState);
    await state.videoController?.dispose();
    state.chewieController?.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }
}

final videoPlayerProvider =
    StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>(
      (ref) => VideoPlayerNotifier(),
    );
