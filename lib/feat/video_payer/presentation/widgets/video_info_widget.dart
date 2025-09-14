import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';
import '../../domain/videolist_model.dart';

class VideoInfoWidget extends ConsumerWidget {
  const VideoInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoPlayerProvider);
    final currentVideo = videoState.currentVideoIndex < videos.length
        ? videos[videoState.currentVideoIndex]
        : {'title': 'Big Buck Bunny', 'duration': '10:34'};

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentVideo['title'] ?? 'Video Title',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Learn advanced concepts through this comprehensive video tutorial.',
            style: TextStyle(color: Colors.grey[600], height: 1.4),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.timer, currentVideo['duration'] ?? '10:34'),
              SizedBox(width: 12),
              _buildInfoChip(Icons.visibility, '2.1K views'),
              SizedBox(width: 12),
              _buildInfoChip(Icons.thumb_up, '95%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}