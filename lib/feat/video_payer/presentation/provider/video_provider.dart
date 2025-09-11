
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerState {
  final VideoPlayerController? videoController;
  final ChewieController? chewieController;
  final bool isInitialized;
  final bool isLoading;
  final String? error;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  const VideoPlayerState({
    this.videoController,
    this.chewieController,
    this.isInitialized = false,
    this.isLoading = false,
    this.error,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
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
    );
  }
}

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerNotifier() : super(const VideoPlayerState());

  Future<void> initializeVideo(String videoUrl) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Create video controller
      final videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoController.initialize();

      // Create chewie controller with custom settings
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
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

      // Listen to player state changes
      videoController.addListener(_updatePlayerState);

      state = state.copyWith(
        videoController: videoController,
        chewieController: chewieController,
        isInitialized: true,
        isLoading: false,
        duration: videoController.value.duration,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load video: ${e.toString()}',
      );
    }
  }

  void _updatePlayerState() {
    final controller = state.videoController;
    if (controller != null) {
      state = state.copyWith(
        isPlaying: controller.value.isPlaying,
        position: controller.value.position,
        duration: controller.value.duration,
      );
    }
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

  @override
  void dispose() {
    state.videoController?.removeListener(_updatePlayerState);
    state.videoController?.dispose();
    state.chewieController?.dispose();
    super.dispose();
  }
}

final videoPlayerProvider = StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>(
      (ref) => VideoPlayerNotifier(),
);