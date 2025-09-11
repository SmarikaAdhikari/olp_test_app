//
// import 'package:auto_orientation/auto_orientation.dart';
// import 'package:better_player/better_player.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
//
// // Video Player State
// class BetterPlayerState {
//   final BetterPlayerController? controller;
//   final bool isInitialized;
//   final bool isPlaying;
//   final bool isLoading;
//   final bool isFullscreen;
//   final Duration currentPosition;
//   final Duration totalDuration;
//
//   BetterPlayerState({
//     this.controller,
//     this.isInitialized = false,
//     this.isPlaying = false,
//     this.isLoading = false,
//     this.isFullscreen = false,
//     this.currentPosition = Duration.zero,
//     this.totalDuration = Duration.zero,
//   });
//
//   BetterPlayerState copyWith({
//     BetterPlayerController? controller,
//     bool? isInitialized,
//     bool? isPlaying,
//     bool? isLoading,
//     bool? isFullscreen,
//     Duration? currentPosition,
//     Duration? totalDuration,
//   }) {
//     return BetterPlayerState(
//       controller: controller ?? this.controller,
//       isInitialized: isInitialized ?? this.isInitialized,
//       isPlaying: isPlaying ?? this.isPlaying,
//       isLoading: isLoading ?? this.isLoading,
//       isFullscreen: isFullscreen ?? this.isFullscreen,
//       currentPosition: currentPosition ?? this.currentPosition,
//       totalDuration: totalDuration ?? this.totalDuration,
//     );
//   }
// }
//
// // Video Player Notifier
// class BetterPlayerNotifier extends StateNotifier<BetterPlayerState> {
//   BetterPlayerNotifier() : super(BetterPlayerState());
//
//   Future<void> initializePlayer(String videoUrl, {List<BetterPlayerSubtitlesSource>? subtitles}) async {
//     state = state.copyWith(isLoading: true);
//
//     final betterPlayerConfiguration = BetterPlayerConfiguration(
//       aspectRatio: 16/9,
//       autoPlay: false,
//       looping: false,
//       fullScreenByDefault: false,
//       allowedScreenSleep: false,
//       deviceOrientationsAfterFullScreen: [
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ],
//       deviceOrientationsOnFullScreen: [
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ],
//       controlsConfiguration: const BetterPlayerControlsConfiguration(
//         enableProgressText: true,
//         enableProgressBar: true,
//         enablePlayPause: true,
//         enableMute: true,
//         enableFullscreen: true,
//         enableSubtitles: true,
//         enableAudioTracks: true,
//         showControlsOnInitialize: false,
//       ),
//     );
//
//     final dataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       videoUrl,
//       subtitles: subtitles,
//       bufferingConfiguration: const BetterPlayerBufferingConfiguration(
//         minBufferMs: 50000,
//         maxBufferMs: 13107200,
//         bufferForPlaybackMs: 2500,
//         bufferForPlaybackAfterRebufferMs: 5000,
//       ),
//     );
//
//     final controller = BetterPlayerController(betterPlayerConfiguration);
//     await controller.setupDataSource(dataSource);
//
//     // Add listeners
//     controller.addEventsListener(_onPlayerEvent);
//
//     state = state.copyWith(
//       controller: controller,
//       isInitialized: true,
//       isLoading: false,
//     );
//   }
//
//   void _onPlayerEvent(BetterPlayerEvent event) {
//     final controller = state.controller;
//     if (controller == null) return;
//
//     switch (event.betterPlayerEventType) {
//       case BetterPlayerEventType.play:
//         state = state.copyWith(isPlaying: true);
//         break;
//       case BetterPlayerEventType.pause:
//         state = state.copyWith(isPlaying: false);
//         break;
//       case BetterPlayerEventType.progress:
//         final position = controller.videoPlayerController?.value.position ?? Duration.zero;
//         final duration = controller.videoPlayerController?.value.duration ?? Duration.zero;
//         state = state.copyWith(
//           currentPosition: position,
//           totalDuration: duration,
//         );
//         break;
//       case BetterPlayerEventType.bufferingStart:
//         state = state.copyWith(isLoading: true);
//         break;
//       case BetterPlayerEventType.bufferingEnd:
//         state = state.copyWith(isLoading: false);
//         break;
//       case BetterPlayerEventType.changedPlayerVisibility:
//         final isFullscreen = controller.isFullScreen;
//         state = state.copyWith(isFullscreen: isFullscreen);
//         if (isFullscreen) {
//           AutoOrientation.landscapeAutoMode();
//         } else {
//           AutoOrientation.portraitAutoMode();
//         }
//         break;
//       default:
//         break;
//     }
//   }
//
//   void playPause() {
//     final controller = state.controller;
//     if (controller == null) return;
//
//     if (state.isPlaying) {
//       controller.pause();
//     } else {
//       controller.play();
//     }
//   }
//
//   void seekTo(Duration position) {
//     state.controller?.seekTo(position);
//   }
//
//   void toggleFullscreen() {
//     final controller = state.controller;
//     if (controller == null) return;
//
//     if (state.isFullscreen) {
//       controller.exitFullScreen();
//     } else {
//       controller.enterFullScreen();
//     }
//   }
//
//   @override
//   void dispose() {
//     state.controller?.dispose();
//     super.dispose();
//   }
// }
//
// // Provider
// final betterPlayerProvider = StateNotifierProvider<BetterPlayerNotifier, BetterPlayerState>((ref) {
//   return BetterPlayerNotifier();
// });