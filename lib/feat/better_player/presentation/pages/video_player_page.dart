// import 'package:better_player/better_player.dart' show BetterPlayerSubtitlesSource, BetterPlayerSubtitlesSourceType;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:test_flutter_app/feat/better_player/presentation/widgets/video_player_widget.dart';
//
// class VideoPlayerPage extends ConsumerWidget {
//   final String videoUrl;
//
//   const VideoPlayerPage({
//     Key? key,
//     required this.videoUrl,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             VideoPlayerWidget(
//               videoUrl: videoUrl,
//               subtitles: [
//                 BetterPlayerSubtitlesSource(
//                   type: BetterPlayerSubtitlesSourceType.network,
//                   name: "English",
//                   urls: ["https://example.com/subtitles.vtt"],
//                 ),
//               ],
//             ),
//             // Additional content below video
//             Expanded(
//               child: Container(
//                 color: Colors.white,
//                 child: const Center(
//                   child: Text('Video content area'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }