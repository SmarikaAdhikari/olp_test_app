import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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
    );
  }

  bool get hasNextVideo => currentVideoIndex < videos.length - 1;
  bool get hasPreviousVideo => currentVideoIndex > 0;
}

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerNotifier() : super(const VideoPlayerState());

  Future<void> initializeVideo(String videoUrl, {int? videoIndex}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _disposeControllers();

      int index = videoIndex ?? _findVideoIndex(videoUrl);

      final videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true, // Auto play when initialized
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
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 42,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white),
                ),
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
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load video: ${e.toString()}',
      );
    }
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
      final newState = state.copyWith(
        isPlaying: controller.value.isPlaying,
        position: controller.value.position,
        duration: controller.value.duration,
      );

      if (!controller.value.isPlaying &&
          controller.value.position >= controller.value.duration &&
          controller.value.duration > Duration.zero &&
          state.autoPlayNext &&
          state.hasNextVideo) {
        _playNextVideo();
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
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  Future<void> _disposeControllers() async {
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

final videoPlayerProvider = StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>(
      (ref) => VideoPlayerNotifier(),
);