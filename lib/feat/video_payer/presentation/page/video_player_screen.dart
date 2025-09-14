import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';
import '../widgets/video_list_widget.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/video_info_widget.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  final String videoUrl = 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoPlayerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Video Player', style: TextStyle(color: Colors.grey[800])),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        actions: [
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () => _showCurrentTime(videoState),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            VideoPlayerWidget(videoUrl: videoUrl),
            SizedBox(height: 20),
            VideoInfoWidget(),
            SizedBox(height: 20),
            VideoPlaylistWidget(),
          ],
        ),
      ),
    );
  }

  void _showCurrentTime(VideoPlayerState state) {
    final time = _formatTime(state.position);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Current time: $time'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}