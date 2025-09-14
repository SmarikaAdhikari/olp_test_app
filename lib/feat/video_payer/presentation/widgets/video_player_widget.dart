import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chewie/chewie.dart';
import '../provider/video_provider.dart';

class VideoPlayerWidget extends ConsumerWidget {
  const VideoPlayerWidget({super.key});

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
          SizedBox(
            height: 220,
            child: _buildPlayer(state, ref),
          ),
          if (state.isInitialized) _buildControls(state, ref),
        ],
      ),
    );
  }

  Widget _buildPlayer(VideoPlayerState state, WidgetRef ref) {
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue[600]),
            const SizedBox(height: 10),
            Text('Loading...', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text('Error loading video', style: TextStyle(color: Colors.grey[600])),
            TextButton(
              onPressed: () => ref.read(videoPlayerProvider.notifier).initializePlaylist(state.playlist, state.currentVideoIndex),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.chewieController != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Chewie(controller: state.chewieController!),
      );
    }

    return const Center(child: Text('Initializing...'));
  }

  Widget _buildControls(VideoPlayerState state, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: state.hasPreviousVideo
                ? () => ref.read(videoPlayerProvider.notifier).playPreviousVideo()
                : null,
            icon: Icon(
              Icons.skip_previous,
              color: state.hasPreviousVideo ? Colors.grey[700] : Colors.grey[400],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.playlist_play, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Auto-play', style: TextStyle(color: Colors.grey[700])),
                Switch(
                  value: state.autoPlayNext,
                  onChanged: (_) => ref.read(videoPlayerProvider.notifier).toggleAutoPlayNext(),
                  activeColor: Colors.blue[600],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: state.hasNextVideo
                ? () => ref.read(videoPlayerProvider.notifier).playNextVideo()
                : null,
            icon: Icon(
              Icons.skip_next,
              color: state.hasNextVideo ? Colors.grey[700] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
