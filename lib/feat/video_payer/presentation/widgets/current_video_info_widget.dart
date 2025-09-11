import 'package:flutter/material.dart';

class CurrentVideoInfoWidget extends StatelessWidget {
  final Map<String, String> videoData;
  final bool autoPlayNext;
  final VoidCallback onToggleAutoPlay;

  const CurrentVideoInfoWidget({
    Key? key,
    required this.videoData,
    required this.autoPlayNext,
    required this.onToggleAutoPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.grey[800]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 12),
          _buildTitle(),
          SizedBox(height: 8),
          _buildDescription(),
          SizedBox(height: 16),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'HD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
        if (autoPlayNext)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.playlist_play, size: 14, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  'AUTO',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(width: 8),
        IconButton(
          onPressed: onToggleAutoPlay,
          icon: Icon(
            autoPlayNext ? Icons.playlist_remove : Icons.playlist_play,
            color: autoPlayNext ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      videoData['title'] ?? 'Video Title',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'A beautiful 3D animated short film featuring exciting adventures and stunning visuals.',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[300],
        height: 1.4,
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatChip(Icons.timer, videoData['duration'] ?? '10:34'),
        SizedBox(width: 12),
        _buildStatChip(Icons.visibility, videoData['views'] ?? '2.1M views'),
        SizedBox(width: 12),
        _buildStatChip(Icons.thumb_up, '98%'),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[600]!.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[300]),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[300],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}