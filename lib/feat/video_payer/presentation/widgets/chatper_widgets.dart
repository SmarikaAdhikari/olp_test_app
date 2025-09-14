import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/courses_list_model.dart';
import '../../domain/videolist_model.dart';
import '../page/video_player_screen.dart';

// Provider for tracking expanded chapters
final expandedChaptersProvider = StateProvider<Set<int>>((ref) => <int>{});

class ChapterWidget extends ConsumerWidget {
  final Subject subject;

  const ChapterWidget({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedChapters = ref.watch(expandedChaptersProvider);

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: subject.chapters.length,
      itemBuilder: (context, index) {
        final chapter = subject.chapters[index];
        final isExpanded = expandedChapters.contains(index);

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Chapter Header
              InkWell(
                onTap: () {
                  final updatedSet = Set<int>.from(expandedChapters);
                  if (isExpanded) {
                    updatedSet.remove(index);
                  } else {
                    updatedSet.add(index);
                  }
                  ref.read(expandedChaptersProvider.notifier).state =
                      updatedSet;
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.play_lesson,
                            color: Colors.green[600],
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                chapter.description,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${chapter.videos.length} videos',
                                style: TextStyle(
                                  color: Colors.blue[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: 16),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (isExpanded)
                Column(
                  children: [
                    Divider(height: 1, color: Colors.grey[200]),
                    Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemCount: chapter.videos.length,
                        itemBuilder: (context, videoIndex) {
                          final video = chapter.videos[videoIndex];

                          return Container(
                            padding: EdgeInsets.all(8),
                            width: 200,
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],

                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => VideoPlayerScreen(
                                          videoList : videos,
                                          initialVideoIndex: videoIndex,

                                        ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Video thumbnail placeholder
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.blue[600],
                                        size: 30,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  // Video title
                                  Expanded(
                                    child: Text(
                                      video.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Video duration and play button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            video.duration,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[600],
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
