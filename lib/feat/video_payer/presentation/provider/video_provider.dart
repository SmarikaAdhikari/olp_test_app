import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import '../../domain/courses_list_model.dart';
import '../../domain/videolist_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import '../../domain/courses_list_model.dart';
import '../../domain/videolist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async';
import '../../domain/courses_list_model.dart'; // Assuming Video model is here
// video_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerState {
  final List<Map<String, String>> playlist;
  final int currentVideoIndex;
  final String? currentVideoUrl;
  final VideoPlayerController? videoController;
  final ChewieController? chewieController;
  final bool isLoading;
  final bool isInitialized;
  final String? error;
  final Duration position;
  final bool autoPlayNext;

  const VideoPlayerState({
    this.playlist = const [],
    this.currentVideoIndex = 0,
    this.currentVideoUrl,
    this.videoController,
    this.chewieController,
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
    this.position = Duration.zero,
    this.autoPlayNext = true,
  });

  bool get hasNextVideo => currentVideoIndex < playlist.length - 1;
  bool get hasPreviousVideo => currentVideoIndex > 0;

  Map<String, String> get currentVideo =>
      playlist.isNotEmpty && currentVideoIndex < playlist.length
          ? playlist[currentVideoIndex]
          : {};

  VideoPlayerState copyWith({
    List<Map<String, String>>? playlist,
    int? currentVideoIndex,
    String? currentVideoUrl,
    VideoPlayerController? videoController,
    ChewieController? chewieController,
    bool? isLoading,
    bool? isInitialized,
    String? error,
    Duration? position,
    bool? autoPlayNext,
  }) {
    return VideoPlayerState(
      playlist: playlist ?? this.playlist,
      currentVideoIndex: currentVideoIndex ?? this.currentVideoIndex,
      currentVideoUrl: currentVideoUrl ?? this.currentVideoUrl,
      videoController: videoController ?? this.videoController,
      chewieController: chewieController ?? this.chewieController,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error ?? this.error,
      position: position ?? this.position,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
    );
  }
}

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerNotifier() : super(const VideoPlayerState());

  Future<void> initializePlaylist(List<Map<String, String>> videos, int startIndex) async {
    if (videos.isEmpty) return;

    state = state.copyWith(
      playlist: videos,
      currentVideoIndex: startIndex,
      isLoading: true,
      error: null,
    );

    await _loadVideoAtIndex(startIndex);
  }

  Future<void> _loadVideoAtIndex(int index) async {
    if (index < 0 || index >= state.playlist.length) return;

    try {
      // Dispose previous controllers
      await _disposeControllers();

      state = state.copyWith(
        isLoading: true,
        currentVideoIndex: index,
        error: null,
      );

      final video = state.playlist[index];
      final videoUrl = video['url'];

      if (videoUrl == null || videoUrl.isEmpty) {
        throw Exception('Video URL is null or empty');
      }

      // Create new video controller
      final videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      await videoController.initialize();

      // Create Chewie controller
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        looping: false,
        showControls: true,
        aspectRatio: videoController.value.aspectRatio,
        autoInitialize: true,
      );

      // Add listener for video completion
      videoController.addListener(_videoListener);

      state = state.copyWith(
        currentVideoUrl: videoUrl,
        videoController: videoController,
        chewieController: chewieController,
        isLoading: false,
        isInitialized: true,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load video: ${e.toString()}',
      );
    }
  }

  void _videoListener() {
    if (state.videoController != null) {
      final position = state.videoController!.value.position;
      state = state.copyWith(position: position);

      // Check if video ended and auto-play is enabled
      if (state.videoController!.value.position >= state.videoController!.value.duration &&
          state.autoPlayNext &&
          state.hasNextVideo) {
        playNextVideo();
      }
    }
  }

  Future<void> playVideoAtIndex(int index) async {
    await _loadVideoAtIndex(index);
  }

  Future<void> playNextVideo() async {
    if (state.hasNextVideo) {
      await _loadVideoAtIndex(state.currentVideoIndex + 1);
    }
  }

  Future<void> playPreviousVideo() async {
    if (state.hasPreviousVideo) {
      await _loadVideoAtIndex(state.currentVideoIndex - 1);
    }
  }

  void toggleAutoPlayNext() {
    state = state.copyWith(autoPlayNext: !state.autoPlayNext);
  }

  Future<void> _disposeControllers() async {
    state.videoController?.removeListener(_videoListener);
    // await state.chewieController?.dispose();
    await state.videoController?.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }
}

final videoPlayerProvider = StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>(
      (ref) => VideoPlayerNotifier(),
);


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

// class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
//   VideoPlayerNotifier() : super(const VideoPlayerState());
//
//   Timer? _timeTrackingTimer;
//   DateTime? _playStartTime;
//   Duration _cumulativeWatchTime = Duration.zero;
//
//   Future<void> initializeVideo(String videoUrl, {int? videoIndex}) async {
//     state = state.copyWith(isLoading: true, error: null);
//
//     try {
//       await _disposeControllers();
//       _stopTimeTracking();
//
//       int index = videoIndex ?? _findVideoIndex(videoUrl);
//
//       final videoController = VideoPlayerController.networkUrl(
//         Uri.parse(videoUrl),
//       );
//       await videoController.initialize();
//
//       final chewieController = ChewieController(
//         videoPlayerController: videoController,
//         autoPlay: true,
//         looping: false,
//         showControls: true,
//         allowFullScreen: true,
//         allowMuting: true,
//         showControlsOnInitialize: true,
//         materialProgressColors: ChewieProgressColors(
//           playedColor: Colors.blue,
//           handleColor: Colors.blueAccent,
//           backgroundColor: Colors.grey,
//           bufferedColor: Colors.lightBlue,
//         ),
//         placeholder: Container(
//           color: Colors.black,
//           child: const Center(child: CircularProgressIndicator()),
//         ),
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error, color: Colors.white, size: 42),
//                 const SizedBox(height: 16),
//                 Text(errorMessage, style: const TextStyle(color: Colors.white)),
//               ],
//             ),
//           );
//         },
//       );
//
//       videoController.addListener(_updatePlayerState);
//
//       state = state.copyWith(
//         videoController: videoController,
//         chewieController: chewieController,
//         isInitialized: true,
//         isLoading: false,
//         duration: videoController.value.duration,
//         currentVideoIndex: index,
//         currentVideoUrl: videoUrl,
//         isPlaying: true,
//         sessionStartTime: DateTime.now(),
//         totalWatchTime: Duration.zero,
//         trackingEvents: [],
//         watchPercentage: 0.0,
//         lastTrackedPosition: Duration.zero,
//       );
//
//       if (state.isTrackingEnabled) {
//         _startTimeTracking();
//         _addTrackingEvent('video_start', Duration.zero);
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to load video: ${e.toString()}',
//       );
//     }
//   }
//
//   void _startTimeTracking() {
//     _timeTrackingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       _updateTimeTracking();
//     });
//   }
//
//   void _stopTimeTracking() {
//     _timeTrackingTimer?.cancel();
//     _timeTrackingTimer = null;
//
//     if (_playStartTime != null && state.isPlaying) {
//       final sessionTime = DateTime.now().difference(_playStartTime!);
//       _cumulativeWatchTime += sessionTime;
//       _playStartTime = null;
//     }
//   }
//
//   void _updateTimeTracking() {
//     if (!state.isInitialized || !state.isTrackingEnabled) return;
//
//     final currentPosition = state.position;
//     final duration = state.duration;
//
//     if (duration.inSeconds > 0) {
//       final newWatchPercentage =
//           (currentPosition.inSeconds / duration.inSeconds) * 100;
//
//       Duration totalWatchTime = _cumulativeWatchTime;
//       if (_playStartTime != null && state.isPlaying) {
//         totalWatchTime += DateTime.now().difference(_playStartTime!);
//       }
//
//       state = state.copyWith(
//         watchPercentage: newWatchPercentage,
//         totalWatchTime: totalWatchTime,
//         lastTrackedPosition: currentPosition,
//       );
//
//       _checkAndTrackMilestones(newWatchPercentage, currentPosition);
//
//       if (currentPosition.inSeconds % 30 == 0 &&
//           currentPosition != state.lastTrackedPosition) {
//         _addTrackingEvent(
//           'time_update',
//           currentPosition,
//           additionalData:
//               'watch_percentage:${newWatchPercentage.toStringAsFixed(1)}',
//         );
//       }
//     }
//   }
//
//   void _checkAndTrackMilestones(double percentage, Duration position) {
//     final milestones = [25.0, 50.0, 75.0, 90.0, 100.0];
//
//     for (double milestone in milestones) {
//       if (percentage >= milestone) {
//         bool alreadyTracked = state.trackingEvents.any(
//           (event) =>
//               event.eventType == 'milestone' &&
//               event.additionalData?.contains('milestone:$milestone') == true,
//         );
//
//         if (!alreadyTracked) {
//           _addTrackingEvent(
//             'milestone',
//             position,
//             additionalData: 'milestone:$milestone',
//           );
//
//           _sendMilestoneToAnalytics(milestone, position);
//         }
//       }
//     }
//   }
//
//   void _addTrackingEvent(
//     String eventType,
//     Duration position, {
//     String? additionalData,
//   }) {
//     final event = TimeTrackingEvent(
//       timestamp: DateTime.now(),
//       eventType: eventType,
//       position: position,
//       additionalData: additionalData,
//     );
//
//     final updatedEvents = [...state.trackingEvents, event];
//     state = state.copyWith(trackingEvents: updatedEvents);
//
//     print(
//       'Video Tracking Event: ${event.eventType} at ${_formatDuration(position)} - ${event.additionalData ?? ''}',
//     );
//
//     _sendTrackingEventToAnalytics(event);
//   }
//
//   void _sendTrackingEventToAnalytics(TimeTrackingEvent event) {
//     print('Analytics: ${event.toJson()}');
//   }
//
//   void _sendMilestoneToAnalytics(double milestone, Duration position) {
//     final videoData =
//         videos.isNotEmpty && state.currentVideoIndex < videos.length
//             ? videos[state.currentVideoIndex]
//             : {};
//
//     print(
//       'Video Milestone: $milestone% reached at ${_formatDuration(position)} for "${videoData['title'] ?? 'Unknown'}"',
//     );
//
//     final analyticsData = {
//       'milestone_percentage': milestone,
//       'position_seconds': position.inSeconds,
//       'video_title': videoData['title'] ?? 'Unknown',
//       'video_duration': state.duration.inSeconds,
//       'total_watch_time': state.totalWatchTime.inSeconds,
//       'session_id': state.sessionStartTime?.millisecondsSinceEpoch.toString(),
//     };
//
//     print('Milestone Analytics: $analyticsData');
//   }
//
//   int _findVideoIndex(String videoUrl) {
//     for (int i = 0; i < videos.length; i++) {
//       if (videos[i]['url'] == videoUrl) {
//         return i;
//       }
//     }
//     return 0;
//   }
//
//   void _updatePlayerState() {
//     final controller = state.videoController;
//     if (controller != null) {
//       final wasPlaying = state.isPlaying;
//       final isNowPlaying = controller.value.isPlaying;
//
//       if (wasPlaying != isNowPlaying) {
//         if (isNowPlaying) {
//           _playStartTime = DateTime.now();
//           _addTrackingEvent('play', controller.value.position);
//         } else {
//           if (_playStartTime != null) {
//             _cumulativeWatchTime += DateTime.now().difference(_playStartTime!);
//             _playStartTime = null;
//           }
//           _addTrackingEvent('pause', controller.value.position);
//         }
//       }
//
//       final newState = state.copyWith(
//         isPlaying: isNowPlaying,
//         position: controller.value.position,
//         duration: controller.value.duration,
//       );
//
//       if (!controller.value.isPlaying &&
//           controller.value.position >= controller.value.duration &&
//           controller.value.duration > Duration.zero) {
//         _addTrackingEvent('complete', controller.value.duration);
//
//         if (state.autoPlayNext && state.hasNextVideo) {
//           _playNextVideo();
//         }
//       }
//
//       state = newState;
//     }
//   }
//
//   Future<void> _playNextVideo() async {
//     if (state.hasNextVideo) {
//       final nextIndex = state.currentVideoIndex + 1;
//       final nextVideo = videos[nextIndex];
//       await initializeVideo(nextVideo['url']!, videoIndex: nextIndex);
//     }
//   }
//
//   Future<void> playNextVideo() async {
//     await _playNextVideo();
//   }
//
//   Future<void> playPreviousVideo() async {
//     if (state.hasPreviousVideo) {
//       final previousIndex = state.currentVideoIndex - 1;
//       final previousVideo = videos[previousIndex];
//       await initializeVideo(previousVideo['url']!, videoIndex: previousIndex);
//     }
//   }
//
//   Future<void> playVideoAtIndex(int index) async {
//     if (index >= 0 && index < videos.length) {
//       final video = videos[index];
//       await initializeVideo(video['url']!, videoIndex: index);
//     }
//   }
//
//   void toggleAutoPlayNext() {
//     state = state.copyWith(autoPlayNext: !state.autoPlayNext);
//   }
//
//   Future<void> play() async {
//     await state.videoController?.play();
//   }
//
//   Future<void> pause() async {
//     await state.videoController?.pause();
//   }
//
//   Future<void> seekTo(Duration position) async {
//     await state.videoController?.seekTo(position);
//     _addTrackingEvent(
//       'seek',
//       position,
//       additionalData: 'from:${state.position.inSeconds}',
//     );
//   }
//
//   void togglePlayPause() {
//     if (state.isPlaying) {
//       pause();
//     } else {
//       play();
//     }
//   }
//
//   void toggleTimeTracking() {
//     final newTrackingState = !state.isTrackingEnabled;
//     state = state.copyWith(isTrackingEnabled: newTrackingState);
//
//     if (newTrackingState) {
//       _startTimeTracking();
//     } else {
//       _stopTimeTracking();
//     }
//   }
//
//   Map<String, dynamic> getTrackingSummary() {
//     return {
//       'total_watch_time_seconds': state.totalWatchTime.inSeconds,
//       'watch_percentage': state.watchPercentage,
//       'video_duration_seconds': state.duration.inSeconds,
//       'session_start_time': state.sessionStartTime?.toIso8601String(),
//       'events_count': state.trackingEvents.length,
//       'milestones_reached':
//           state.trackingEvents
//               .where((e) => e.eventType == 'milestone')
//               .map((e) => e.additionalData)
//               .toList(),
//       'current_video':
//           state.currentVideoIndex < videos.length
//               ? videos[state.currentVideoIndex]['title']
//               : 'Unknown',
//     };
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     if (duration.inHours > 0) {
//       return '${duration.inHours}:$minutes:$seconds';
//     }
//     return '$minutes:$seconds';
//   }
//
//   Future<void> _disposeControllers() async {
//     _stopTimeTracking();
//     state.videoController?.removeListener(_updatePlayerState);
//     await state.videoController?.dispose();
//     state.chewieController?.dispose();
//   }
//
//   @override
//   void dispose() {
//     _disposeControllers();
//     super.dispose();
//   }
//
//   void initializePlaylist(List<Video> videos, int startIndex) {
//     // Initialize the playlist & play video at startIndex
//     state = state.copyWith(
//       playlist: videos,
//       currentIndex: startIndex,
//       currentVideoUrl: videos[startIndex].url,
//       // reset other states and initialize controllers
//     );
//     // Initialize video controller here (reuse your existing logic)
//   }
//
//
//
//   bool get hasNextVideo => state.currentVideoIndex < state..length - 1;
//
//   bool get hasPreviousVideo => state.currentVideoIndex > 0;
//
//
// }
//
// final videoPlayerProvider = StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>(
//       (ref) => VideoPlayerNotifier(),
//     );
