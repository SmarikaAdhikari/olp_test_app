import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chewie/chewie.dart';
import '../provider/video_provider.dart';
import '../../domain/videolist_model.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;
  final double? aspectRatio;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.aspectRatio,
  }) : super(key: key);

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoPlayerProvider.notifier).initializeVideo(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoPlayerProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Video Player
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 250,
              child: _buildVideoContent(videoState),
            ),
          ),
          // Auto-play controls and current video info
          _buildVideoControls(videoState),
        ],
      ),
    );
  }

  Widget _buildVideoContent(VideoPlayerState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(videoPlayerProvider.notifier).initializeVideo(widget.videoUrl);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.isInitialized && state.chewieController != null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio ?? 16 / 9,
        child: Chewie(controller: state.chewieController!),
      );
    }

    return const Center(
      child: Text(
        'Initializing video...',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildVideoControls(VideoPlayerState state) {
    if (!state.isInitialized) return const SizedBox.shrink();

    final currentVideo = state.currentVideoIndex < videos.length
        ? videos[state.currentVideoIndex]
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        children: [
          // Current video info
          if (currentVideo != null) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'NOW PLAYING',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentVideo['title'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              IconButton(
                onPressed: state.hasPreviousVideo
                    ? () => ref.read(videoPlayerProvider.notifier).playPreviousVideo()
                    : null,
                icon: Icon(
                  Icons.skip_previous,
                  color: state.hasPreviousVideo ? Colors.white : Colors.grey[600],
                ),
                tooltip: 'Previous Video',
              ),

              // Auto-play toggle
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.playlist_play,
                    color: state.autoPlayNext ? Colors.blue : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Auto-play',
                    style: TextStyle(
                      color: state.autoPlayNext ? Colors.blue : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: state.autoPlayNext,
                    onChanged: (_) => ref.read(videoPlayerProvider.notifier).toggleAutoPlayNext(),
                    activeColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),

              // Next button
              IconButton(
                onPressed: state.hasNextVideo
                    ? () => ref.read(videoPlayerProvider.notifier).playNextVideo()
                    : null,
                icon: Icon(
                  Icons.skip_next,
                  color: state.hasNextVideo ? Colors.white : Colors.grey[600],
                ),
                tooltip: 'Next Video',
              ),
            ],
          ),

          // Video queue info
          if (videos.length > 1) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.queue_music,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${state.currentVideoIndex + 1} of ${videos.length}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  if (state.hasNextVideo && state.autoPlayNext) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.play_arrow,
                      size: 14,
                      color: Colors.blue,
                    ),
                    Text(
                      'Next: ${videos[state.currentVideoIndex + 1]['title']?.split(' ').take(3).join(' ')}...',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}