import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/courses_list_model.dart';
import '../../domain/videolist_model.dart';
import '../provider/video_provider.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/video_info_widget.dart';
import '../widgets/video_playlist_widget.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final List<Map<String, String>>? videoList;
  final int initialVideoIndex;

  const VideoPlayerScreen({
    super.key,
    this.videoList,
    this.initialVideoIndex = 0,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();

    // Use provided videos or fall back to default videos
    final videoPlaylist = widget.videoList ?? videos;

    // Initialize the video player with the playlist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoPlayerProvider.notifier).initializePlaylist(
        videoPlaylist,
        widget.initialVideoIndex,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoPlayerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
            'Video Player',
            style: TextStyle(color: Colors.grey[800])
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () => _showCurrentTime(videoState),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showVideoInfo(videoState),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Video Player Widget
            const VideoPlayerWidget(),

            const SizedBox(height: 20),

            // Video Information Widget
            const VideoInfoWidget(),

            const SizedBox(height: 20),

            // Video Playlist Widget
            const VideoPlaylistWidget(),
          ],
        ),
      ),
    );
  }

  void _showCurrentTime(VideoPlayerState state) {
    if (state.videoController != null) {
      final time = _formatTime(state.position);
      final duration = _formatTime(state.videoController!.value.duration);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Current time: $time / $duration'),
          backgroundColor: Colors.blue[600],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showVideoInfo(VideoPlayerState state) {
    final currentVideo = state.currentVideo;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(currentVideo['title'] ?? 'Video Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Views: ${currentVideo['views'] ?? 'Unknown'}'),
            Text('Published: ${currentVideo['time'] ?? 'Unknown'}'),
            Text('Position: ${state.currentVideoIndex + 1} of ${state.playlist.length}'),
            if (state.videoController != null)
              Text('Duration: ${_formatTime(state.videoController!.value.duration)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}