import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';
import '../../domain/videolist_model.dart';
// video_playlist_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';

class VideoPlaylistWidget extends ConsumerWidget {
  const VideoPlaylistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoPlayerProvider);

    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border(bottom: BorderSide(color: Colors.grey[400]!)),
            ),
            child: Row(
              children: [
                Text(
                  'Course Videos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.playlist.length} videos',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (state.playlist.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.video_library_outlined,
                      size: 48,
                      color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No videos available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.playlist.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, index) {
                final video = state.playlist[index];
                final isCurrent = index == state.currentVideoIndex;

                return Container(
                  color: isCurrent ? Colors.grey[100] : Colors.grey[200],
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.blue[50] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        isCurrent ? Icons.play_arrow : Icons.play_circle_outline,
                        color: isCurrent ? Colors.blue[600] : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      video['title'] ?? 'Untitled Video',
                      style: TextStyle(
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                        color: isCurrent ? Colors.blue[700] : Colors.grey[800],
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          _formatViews(video['views'] ?? '0'),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          video['time'] ?? '',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Playing',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () => ref
                        .read(videoPlayerProvider.notifier)
                        .playVideoAtIndex(index),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatViews(String views) {
    // Simple view formatting helper
    return views.endsWith('M') || views.endsWith('K')
        ? '$views views'
        : views;
  }
}