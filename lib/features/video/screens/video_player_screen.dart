import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class RelatedVideoItem {
  final String title;
  final String duration;
  final String category;
  final String videoUrl;
  final bool isWatched;

  const RelatedVideoItem({
    required this.title,
    required this.duration,
    required this.category,
    required this.videoUrl,
    this.isWatched = false,
  });
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String category;
  final List<RelatedVideoItem>? relatedVideos;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    this.category = 'Starter',
    this.relatedVideos,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;

  late String _currentTitle;
  late String _currentUrl;
  late String _currentCategory;

  // Interactive fallback chalkboard player state
  bool _isPlayingMock = false;
  double _mockProgress = 0.15; // 0.0 to 1.0
  Timer? _mockTimer;

  late List<RelatedVideoItem> _playlist;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title;
    _currentUrl = widget.videoUrl;
    _currentCategory = widget.category;

    _playlist = widget.relatedVideos ??
        const [
          RelatedVideoItem(
            title: 'Algebra – Introduction to Equations-2',
            duration: '01:22',
            category: 'Starter',
            videoUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            isWatched: true,
          ),
          RelatedVideoItem(
            title: 'Solving Linear Equations – Level 1',
            duration: '02:31',
            category: 'Starter',
            videoUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            isWatched: true,
          ),
          RelatedVideoItem(
            title: 'Word Problems with Linear Equations-1',
            duration: '08:02',
            category: 'Starter',
            videoUrl:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            isWatched: false,
          ),
          RelatedVideoItem(
            title: 'Two-variable Linear Systems',
            duration: '04:15',
            category: 'Normal',
            videoUrl:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            isWatched: false,
          ),
        ];

    _initPlayer(_currentUrl);
  }

  Future<void> _initPlayer(String url) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    _chewieController?.dispose();
    _videoController?.dispose();

    try {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        throw Exception('Invalid URL');
      }

      _videoController = VideoPlayerController.networkUrl(uri);

      // Initialize with timeout
      await _videoController!.initialize().timeout(
        const Duration(seconds: 6),
        onTimeout: () {
          throw TimeoutException('Video stream took too long to load');
        },
      );

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio > 0
            ? _videoController!.value.aspectRatio
            : 16 / 9,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF2A3BD4),
          handleColor: const Color(0xFF2A3BD4),
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
        placeholder: Container(color: const Color(0xFF0F172A)),
        errorBuilder: (context, errorMessage) => _buildInteractiveChalkboardPlayer(),
      );

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      // Graceful fallback to interactive chalkboard player (no harsh error text)
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        _startMockTimer();
      }
    }
  }

  void _startMockTimer() {
    _mockTimer?.cancel();
    if (_isPlayingMock) {
      _mockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          _mockProgress += 0.01;
          if (_mockProgress >= 1.0) {
            _mockProgress = 0.0;
            _isPlayingMock = false;
            timer.cancel();
          }
        });
      });
    }
  }

  void _toggleMockPlay() {
    setState(() {
      _isPlayingMock = !_isPlayingMock;
    });
    _startMockTimer();
  }

  void _skipMock(double delta) {
    setState(() {
      _mockProgress = (_mockProgress + delta).clamp(0.0, 1.0);
    });
  }

  void _changeVideo(RelatedVideoItem item) {
    setState(() {
      _currentTitle = item.title;
      _currentUrl = item.videoUrl;
      _currentCategory = item.category;
    });
    _initPlayer(_currentUrl);
  }

  @override
  void dispose() {
    _mockTimer?.cancel();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast_rounded, color: Colors.white70, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── 1. Video Player Area ──────────────────────────────────────────
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _isLoading
                ? Container(
                    color: const Color(0xFF1E293B),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2A3BD4),
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : (_hasError || _chewieController == null)
                    ? _buildInteractiveChalkboardPlayer()
                    : Chewie(controller: _chewieController!),
          ),

          // ── 2. Lesson Meta & Up Next Playlist ─────────────────────────────
          Expanded(
            child: Container(
              color: const Color(0xFF0A0F1D),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                children: [
                  // Title
                  Text(
                    _currentTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Badges Row
                  Row(
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _currentCategory,
                              style: const TextStyle(
                                color: Color(0xFF4ADE80),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // HD Quality Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3BD4).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'HD 1080p',
                          style: TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Subtitles Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Subtitles Available',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  const SizedBox(height: 18),

                  // Up Next Header
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Up Next in This Topic',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '4 Lessons',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Playlist items
                  ..._playlist.map((item) {
                    final isCurrent = item.title == _currentTitle;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF131B2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent
                              ? const Color(0xFF2A3BD4)
                              : const Color(0xFF1E293B),
                          width: isCurrent ? 1.5 : 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _changeVideo(item),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                // Thumbnail with Gradient & Play Icon
                                Container(
                                  width: 90,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF881337),
                                        Color(0xFF4C0519)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        isCurrent && _isPlayingMock
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_fill_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      Positioned(
                                        bottom: 3,
                                        right: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.75),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            item.duration,
                                            style: const TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Lesson Title and Status
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: item.isWatched
                                                  ? const Color(0xFF16A34A)
                                                      .withValues(alpha: 0.15)
                                                  : const Color(0xFF64748B)
                                                      .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.isWatched
                                                  ? 'Watched'
                                                  : 'Pending',
                                              style: TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w600,
                                                color: item.isWatched
                                                    ? const Color(0xFF4ADE80)
                                                    : const Color(0xFF94A3B8),
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          color: isCurrent
                                              ? const Color(0xFF93C5FD)
                                              : Colors.white,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white38,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Interactive Chalkboard Blackboard Player ───────────────────────────
  Widget _buildInteractiveChalkboardPlayer() {
    final currentSeconds = (_mockProgress * 611).toInt();
    final totalSeconds = 611; // 10:11

    final currentMin = (currentSeconds ~/ 60).toString().padLeft(2, '0');
    final currentSec = (currentSeconds % 60).toString().padLeft(2, '0');
    final totalMin = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final totalSec = (totalSeconds % 60).toString().padLeft(2, '0');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF500724), Color(0xFF881337), Color(0xFF350417)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background Math Chalkboard Graphics / Watermark
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Poppins',
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Y = mx + C  •  Linear Equations Level 1',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Center Controls (Skip -10s, Play/Pause, Skip +10s)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10_rounded,
                      color: Colors.white, size: 30),
                  onPressed: () => _skipMock(-0.05),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: _toggleMockPlay,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlayingMock
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: const Color(0xFF881337),
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.forward_10_rounded,
                      color: Colors.white, size: 30),
                  onPressed: () => _skipMock(0.05),
                ),
              ],
            ),
          ),

          // Bottom Scrubber Bar & Timers
          Positioned(
            bottom: 8,
            left: 12,
            right: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Scrubber line
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.5,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: const Color(0xFF2A3BD4),
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: _mockProgress,
                    onChanged: (val) => setState(() => _mockProgress = val),
                  ),
                ),
                // Timecode
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$currentMin:$currentSec',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '$totalMin:$totalSec',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
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
