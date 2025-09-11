
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chewie/chewie.dart';

import '../provider/video_provider.dart';

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
      height: 250,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildVideoContent(videoState),
      ),
    );
  }

  Widget _buildVideoContent(VideoPlayerState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
}