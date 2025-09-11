import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/videolist_model.dart';
import '../controller/video_player_controller.dart';
import '../provider/video_provider.dart';
import '../widgets/current_video_info_widget.dart';
import '../widgets/video_list_widget.dart';
import '../widgets/video_player_widget.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>
    with TickerProviderStateMixin {
  final String videoUrl =
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setOrientation();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _setOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  late VideoController _videoController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _videoController = VideoController(ref: ref, context: context);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _showCurrentTimeSnackbar() {
    final videoState = ref.read(videoPlayerProvider);
    final currentTime = _formatDuration(videoState.position);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Current playback time: $currentTime'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );

    // Here you would make your API call with the current time
    // _makeApiCall(videoState.position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoPlayerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
                ),
              ),
              child: FlexibleSpaceBar(
                title: ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [Colors.white, Colors.grey],
                      ).createShader(bounds),
                  child: const Text(
                    'Video Player',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                centerTitle: true,
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.access_time, color: Colors.white),
                  onPressed: _showCurrentTimeSnackbar,
                  tooltip: 'Show Current Time',
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVideoPlayerSection(),
                      const SizedBox(height: 32),
                      _buildCurrentVideoInfo(videoState),
                      const SizedBox(height: 20),
                      _buildVideoList(videoState),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: VideoPlayerWidget(videoUrl: videoUrl, aspectRatio: 16 / 9),
      ),
    );
  }

  Widget _buildCurrentVideoInfo(VideoPlayerState videoState) {
    final currentVideo = videoState.currentVideoIndex < videos.length
        ? videos[videoState.currentVideoIndex]
        : {'title': 'Big Buck Bunny', 'duration': '10:34', 'views': '2.1M'};

    return CurrentVideoInfoWidget(
      videoData: currentVideo,
      autoPlayNext: videoState.autoPlayNext,
      onToggleAutoPlay: _videoController.toggleAutoPlayNext,
    );
  }

  Widget _buildVideoList(VideoPlayerState videoState) {
    return VideoListWidget(
      videos: videos,
      currentIndex: videoState.currentVideoIndex,
      autoPlayNext: videoState.autoPlayNext,
      onVideoTap: (index) => _videoController.playVideoAtIndex(index),
      onToggleAutoPlay: _videoController.toggleAutoPlayNext,
    );
  }

}