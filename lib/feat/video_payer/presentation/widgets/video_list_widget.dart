import 'package:flutter/material.dart';

class VideoListWidget extends StatelessWidget {
  final List<Map<String, String>> videos;
  final int currentIndex;
  final bool autoPlayNext;
  final Function(int) onVideoTap;
  final VoidCallback onToggleAutoPlay;

  const VideoListWidget({
    Key? key,
    required this.videos,
    required this.currentIndex,
    required this.autoPlayNext,
    required this.onVideoTap,
    required this.onToggleAutoPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 16),
        _buildVideoList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Playlist',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          TextButton.icon(
            onPressed: onToggleAutoPlay,
            icon: Icon(
              autoPlayNext ? Icons.playlist_remove : Icons.playlist_play,
              size: 18,
              color: Colors.blue,
            ),
            label: Text(
              autoPlayNext ? 'Disable Auto-play' : 'Enable Auto-play',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return Column(
      children: videos.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> video = entry.value;
        bool isCurrentVideo = index == currentIndex;
        bool isUpNext = autoPlayNext && index == currentIndex + 1;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildVideoCard(video, index, isCurrentVideo, isUpNext),
        );
      }).toList(),
    );
  }

  Widget _buildVideoCard(Map<String, String> video, int index, bool isCurrentVideo, bool isUpNext) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCurrentVideo
              ? [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.2)]
              : [Colors.grey[900]!, Colors.grey[800]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentVideo ? Colors.blue.withOpacity(0.5) : Colors.grey[700]!,
          width: isCurrentVideo ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onVideoTap(index),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildThumbnail(video, isCurrentVideo),
                SizedBox(width: 16),
                _buildVideoInfo(video, isCurrentVideo, isUpNext),
                Icon(Icons.more_vert, color: Colors.white54),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(Map<String, String> video, bool isCurrentVideo) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isCurrentVideo
              ? [Colors.blue.withOpacity(0.4), Colors.blue.withOpacity(0.4)]
              : [Colors.grey[800]!, Colors.grey[700]!],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.video_library,
              color: isCurrentVideo ? Colors.white : Colors.white54,
              size: 32,
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCurrentVideo ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                video['duration'] ?? '00:00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isCurrentVideo)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(Map<String, String> video, bool isCurrentVideo, bool isUpNext) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  video['title']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: isCurrentVideo ? FontWeight.bold : FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCurrentVideo)
                Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PLAYING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.visibility, size: 14, color: Colors.grey[400]),
              SizedBox(width: 4),
              Text(
                '${video['views']} ',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
              SizedBox(width: 4),
              Text(
                '${video['time']} ago',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
          if (isUpNext)
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline, size: 12, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'Up next',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}