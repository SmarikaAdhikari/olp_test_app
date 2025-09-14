import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';
import '../../domain/videolist_model.dart';
// video_info_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';
// video_info_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';

class VideoInfoWidget extends ConsumerWidget {
  const VideoInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoPlayerProvider);
    final currentVideo = videoState.currentVideo;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentVideo['title'] ?? 'No Video Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Learn advanced concepts through this comprehensive video tutorial.',
            style: TextStyle(color: Colors.grey[600], height: 1.4),
          ),
          const SizedBox(height: 12),

          // Video stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                  Icons.visibility,
                  currentVideo['views'] ?? '0 views'
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                  Icons.access_time,
                  currentVideo['time'] ?? 'Unknown'
              ),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.thumb_up, '95%'),
            ],
          ),

          // Video progress indicator
          if (videoState.isInitialized && videoState.videoController != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _getVideoProgress(videoState),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(videoState.position),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        _formatDuration(videoState.videoController?.value.duration ?? Duration.zero),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  double _getVideoProgress(VideoPlayerState state) {
    if (state.videoController == null ||
        state.videoController!.value.duration == Duration.zero) {
      return 0.0;
    }

    return state.position.inMilliseconds /
        state.videoController!.value.duration.inMilliseconds;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
