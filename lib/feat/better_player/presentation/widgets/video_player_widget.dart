// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:better_player/better_player.dart';
// import 'package:test_flutter_app/feat/better_player/presentation/widgets/vider_controls_overlay.dart';
//
// import '../provider/video_player_provider.dart';
//
// class VideoPlayerWidget extends ConsumerStatefulWidget {
//   final String videoUrl;
//   final List<BetterPlayerSubtitlesSource>? subtitles;
//   final double? aspectRatio;
//
//   const VideoPlayerWidget({
//     Key? key,
//     required this.videoUrl,
//     this.subtitles,
//     this.aspectRatio = 16/9,
//   }) : super(key: key);
//
//   @override
//   ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(betterPlayerProvider.notifier)
//           .initializePlayer(widget.videoUrl, subtitles: widget.subtitles);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final playerState = ref.watch(betterPlayerProvider);
//
//     return Container(
//       color: Colors.black,
//       child: AspectRatio(
//         aspectRatio: widget.aspectRatio ?? 16/9,
//         child: Stack(
//           children: [
//             if (playerState.isInitialized && playerState.controller != null)
//               BetterPlayer(controller: playerState.controller!)
//             else
//               const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//
//             // Custom loading overlay
//             if (playerState.isLoading)
//               Container(
//                 color: Colors.black45,
//                 child: const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 ),
//               ),
//
//             // Custom controls overlay (optional - better_player has built-in controls)
//             if (playerState.isInitialized)
//               VideoControlsOverlay(),
//           ],
//         ),
//       ),
//     );
//   }
// }