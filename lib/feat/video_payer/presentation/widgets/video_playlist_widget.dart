import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';
import '../../domain/videolist_model.dart';

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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
                Spacer(),
                Text(
                  '${videos.length} videos',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: videos.length,
            separatorBuilder:
                (context, index) => Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final video = videos[index];
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
                    video['title'] ?? '',
                    style: TextStyle(
                      fontWeight:
                          isCurrent ? FontWeight.w600 : FontWeight.normal,
                      color: isCurrent ? Colors.blue[700] : Colors.grey[800],
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        video['duration'] ?? '',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      SizedBox(width: 12),
                      if (isCurrent)
                        Container(
                          padding: EdgeInsets.symmetric(
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
                  onTap:
                      () => ref
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
}
