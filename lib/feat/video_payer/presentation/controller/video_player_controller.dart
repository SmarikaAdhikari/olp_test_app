import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/videolist_model.dart';
import '../provider/video_provider.dart';

class VideoController {
  final WidgetRef ref;
  final BuildContext context;

  VideoController({required this.ref, required this.context});

  // Video playback controls
  void playVideoAtIndex(int index) {
    if (index >= 0 && index < videos.length) {
      HapticFeedback.lightImpact();
      ref.read(videoPlayerProvider.notifier).playVideoAtIndex(index);
      _showVideoSelectedSnackbar(videos[index]['title']!);
    }
  }

  void playNextVideo() {
    ref.read(videoPlayerProvider.notifier).playNextVideo();
  }

  void playPreviousVideo() {
    ref.read(videoPlayerProvider.notifier).playPreviousVideo();
  }

  void toggleAutoPlayNext() {
    ref.read(videoPlayerProvider.notifier).toggleAutoPlayNext();
  }

  void togglePlayPause() {
    ref.read(videoPlayerProvider.notifier).togglePlayPause();
  }

  void seekTo(Duration position) {
    ref.read(videoPlayerProvider.notifier).seekTo(position);
  }

  // UI feedback methods
  void _showVideoSelectedSnackbar(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.play_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Loading: $title',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Options menu handling
  void showOptionsMenu(Map<String, String> video, int index) {
    final videoState = ref.read(videoPlayerProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              video['title']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            _buildBottomSheetItem(
              Icons.play_arrow,
              'Play now',
                  () {
                Navigator.pop(context);
                playVideoAtIndex(index);
              },
            ),
            if (index == videoState.currentVideoIndex + 1)
              _buildBottomSheetItem(
                Icons.skip_next,
                'Play next',
                    () {
                  Navigator.pop(context);
                  playNextVideo();
                },
              ),
            _buildBottomSheetItem(Icons.download, 'Download', () {
              Navigator.pop(context);
              _handleDownload(video);
            }),
            _buildBottomSheetItem(Icons.share, 'Share', () {
              Navigator.pop(context);
              _handleShare(video);
            }),
            _buildBottomSheetItem(Icons.playlist_add, 'Add to playlist', () {
              Navigator.pop(context);
              _handleAddToPlaylist(video);
            }),
            _buildBottomSheetItem(Icons.report, 'Report', () {
              Navigator.pop(context);
              _handleReport(video);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // Action handlers (you can implement these as needed)
  void _handleDownload(Map<String, String> video) {
    _showActionSnackbar('Download started for ${video['title']}');
  }

  void _handleShare(Map<String, String> video) {
    _showActionSnackbar('Sharing ${video['title']}');
    // Implement share functionality
  }

  void _handleAddToPlaylist(Map<String, String> video) {
    _showActionSnackbar('Added ${video['title']} to playlist');
    // Implement add to playlist functionality
  }

  void _handleReport(Map<String, String> video) {
    _showActionSnackbar('Reported ${video['title']}');
    // Implement report functionality
  }

  void _showActionSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Video state helpers
  bool isCurrentVideo(int index) {
    final videoState = ref.read(videoPlayerProvider);
    return index == videoState.currentVideoIndex;
  }

  bool isUpNext(int index) {
    final videoState = ref.read(videoPlayerProvider);
    return videoState.autoPlayNext &&
        index == videoState.currentVideoIndex + 1 &&
        videoState.hasNextVideo;
  }

  VideoPlayerState get currentVideoState => ref.read(videoPlayerProvider);

  // Orientation controls
  void setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setPortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void setMixedOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Cleanup
  void dispose() {
    setPortraitOrientation();
  }
}