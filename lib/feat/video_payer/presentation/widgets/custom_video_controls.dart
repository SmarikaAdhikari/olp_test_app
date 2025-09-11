import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/video_provider.dart';

class CustomVideoControls extends ConsumerWidget {
  const CustomVideoControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoPlayerProvider);

    if (!videoState.isInitialized) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress bar
          VideoProgressBar(
            position: videoState.position,
            duration: videoState.duration,
            onSeek: (position) {
              ref.read(videoPlayerProvider.notifier).seekTo(position);
            },
          ),
          const SizedBox(height: 16),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  final newPosition =
                      videoState.position - const Duration(seconds: 10);
                  ref
                      .read(videoPlayerProvider.notifier)
                      .seekTo(
                        newPosition < Duration.zero
                            ? Duration.zero
                            : newPosition,
                      );
                },
                icon: const Icon(Icons.replay_10),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  ref.read(videoPlayerProvider.notifier).togglePlayPause();
                },
                icon: Icon(
                  videoState.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                color: Colors.white,
                iconSize: 48,
              ),
              IconButton(
                onPressed: () {
                  final newPosition =
                      videoState.position + const Duration(seconds: 10);
                  ref
                      .read(videoPlayerProvider.notifier)
                      .seekTo(
                        newPosition > videoState.duration
                            ? videoState.duration
                            : newPosition,
                      );
                },
                icon: const Icon(Icons.forward_10),
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Time display
          Text(
            '${_formatDuration(videoState.position)} / ${_formatDuration(videoState.duration)}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class VideoProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const VideoProgressBar({
    Key? key,
    required this.position,
    required this.duration,
    required this.onSeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        trackHeight: 4.0,
      ),
      child: Slider(
        value:
            duration.inMilliseconds > 0
                ? position.inMilliseconds / duration.inMilliseconds
                : 0.0,
        min: 0.0,
        max: 1.0,
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
        onChanged: (value) {
          final newPosition = Duration(
            milliseconds: (value * duration.inMilliseconds).round(),
          );
          onSeek(newPosition);
        },
      ),
    );
  }
}
