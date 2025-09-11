// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:test_flutter_app/feat/better_player/presentation/provider/video_player_provider.dart';
//
// class VideoProgressBar extends ConsumerWidget {
//   const VideoProgressBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final playerState = ref.watch(betterPlayerProvider);
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SliderTheme(
//             data: SliderTheme.of(context).copyWith(
//               activeTrackColor: Colors.red,
//               inactiveTrackColor: Colors.grey,
//               thumbColor: Colors.red,
//               trackHeight: 3,
//             ),
//             child: Slider(
//               value: playerState.totalDuration.inMilliseconds > 0
//                   ? playerState.currentPosition.inMilliseconds.toDouble()
//                   : 0.0,
//               min: 0.0,
//               max: playerState.totalDuration.inMilliseconds.toDouble(),
//               onChanged: (value) {
//                 final position = Duration(milliseconds: value.round());
//                 ref.read(betterPlayerProvider.notifier).seekTo(position);
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 _formatDuration(playerState.currentPosition),
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//               Text(
//                 _formatDuration(playerState.totalDuration),
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDuration(Duration duration) {
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes % 60;
//     final seconds = duration.inSeconds % 60;
//
//     if (hours > 0) {
//       return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//     } else {
//       return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//     }
//   }
// }