// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:test_flutter_app/feat/better_player/presentation/provider/video_player_provider.dart';
// import 'package:test_flutter_app/feat/better_player/presentation/widgets/video_progress_bar.dart' show VideoProgressBar;
//
//
// class VideoControlsOverlay extends ConsumerWidget {
//   const VideoControlsOverlay({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final playerState = ref.watch(betterPlayerProvider);
//
//     return Positioned.fill(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.black.withOpacity(0.7),
//               Colors.transparent,
//               Colors.transparent,
//               Colors.black.withOpacity(0.7),
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Top controls
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     playerState.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
//                     color: Colors.white,
//                   ),
//                   onPressed: () => ref.read(betterPlayerProvider.notifier).toggleFullscreen(),
//                 ),
//               ],
//             ),
//
//             // Center play/pause button
//             Center(
//               child: GestureDetector(
//                 onTap: () => ref.read(betterPlayerProvider.notifier).playPause(),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: Icon(
//                     playerState.isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.white,
//                     size: 32,
//                   ),
//                 ),
//               ),
//             ),
//
//             // Bottom progress bar
//             VideoProgressBar(),
//           ],
//         ),
//       ),
//     );
//   }
// }