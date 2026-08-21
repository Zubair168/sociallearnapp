import 'package:flutter/material.dart';
import 'package:sociallearnapp/features/courses/screens/test_solving_screen.dart';
import 'package:sociallearnapp/features/courses/screens/topic_analysis_screen.dart';
import 'package:sociallearnapp/features/video/screens/video_player_screen.dart';

class TopicItem {
  final String title;
  final int solved;
  final int total;
  final double completedPct;
  final int greenDots;
  final int yellowDots;
  final int redDots;
  final bool videoLessonsAvailable;
  final int totalWatched;
  final int totalVideos;

  const TopicItem({
    required this.title,
    required this.solved,
    required this.total,
    required this.completedPct,
    required this.greenDots,
    required this.yellowDots,
    required this.redDots,
    this.videoLessonsAvailable = true,
    this.totalWatched = 5,
    this.totalVideos = 10,
  });
}

class VideoTypeItem {
  final String name;
  final Color dotColor;
  final int watched;
  final int total;
  final String duration;
  final List<VideoLessonItem> videos;

  const VideoTypeItem({
    required this.name,
    required this.dotColor,
    required this.watched,
    required this.total,
    required this.duration,
    required this.videos,
  });
}

class VideoLessonItem {
  final String id;
  final String title;
  final String duration;
  final String category;
  bool isWatched;
  final String videoUrl;

  VideoLessonItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.category,
    this.isWatched = false,
    this.videoUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  });
}

class SubjectTopicsScreen extends StatefulWidget {
  final String subjectName;
  final int trialExamsCompleted;
  final int trialExamsTotal;

  const SubjectTopicsScreen({
    super.key,
    this.subjectName = 'Mathematics',
    this.trialExamsCompleted = 5,
    this.trialExamsTotal = 10,
  });

  @override
  State<SubjectTopicsScreen> createState() => _SubjectTopicsScreenState();
}

class _SubjectTopicsScreenState extends State<SubjectTopicsScreen> {
  final List<TopicItem> _originalTopics = const [
    TopicItem(
      title: 'Linear Equations',
      solved: 24,
      total: 88,
      completedPct: 0.51,
      greenDots: 2,
      yellowDots: 2,
      redDots: 1,
      videoLessonsAvailable: true,
      totalWatched: 5,
      totalVideos: 10,
    ),
    TopicItem(
      title: 'Quadratic Equations',
      solved: 56,
      total: 88,
      completedPct: 0.0,
      greenDots: 1,
      yellowDots: 1,
      redDots: 1,
      videoLessonsAvailable: true,
      totalWatched: 2,
      totalVideos: 8,
    ),
    TopicItem(
      title: 'Polynomials',
      solved: 56,
      total: 88,
      completedPct: 0.51,
      greenDots: 2,
      yellowDots: 2,
      redDots: 2,
      videoLessonsAvailable: true,
      totalWatched: 4,
      totalVideos: 6,
    ),
    TopicItem(
      title: 'Inequalities',
      solved: 56,
      total: 88,
      completedPct: 0.51,
      greenDots: 2,
      yellowDots: 2,
      redDots: 2,
      videoLessonsAvailable: true,
      totalWatched: 1,
      totalVideos: 5,
    ),
    TopicItem(
      title: 'Trigonometry & Unit Circle',
      solved: 38,
      total: 75,
      completedPct: 0.40,
      greenDots: 2,
      yellowDots: 1,
      redDots: 1,
      videoLessonsAvailable: true,
      totalWatched: 3,
      totalVideos: 9,
    ),
    TopicItem(
      title: 'Logarithms & Exponentials',
      solved: 42,
      total: 60,
      completedPct: 0.70,
      greenDots: 3,
      yellowDots: 1,
      redDots: 0,
      videoLessonsAvailable: true,
      totalWatched: 6,
      totalVideos: 7,
    ),
  ];

  late List<TopicItem> _topics;
  String _currentSort = 'Default';

  @override
  void initState() {
    super.initState();
    _topics = List.from(_originalTopics);
  }

  void _applySort(String sortType) {
    setState(() {
      _currentSort = sortType;
      switch (sortType) {
        case 'Name (A - Z)':
          _topics.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Name (Z - A)':
          _topics.sort((a, b) => b.title.compareTo(a.title));
          break;
        case 'Completion %':
          _topics.sort((a, b) => b.completedPct.compareTo(a.completedPct));
          break;
        case 'Most Solved':
          _topics.sort((a, b) => b.solved.compareTo(a.solved));
          break;
        case 'Least Solved':
          _topics.sort((a, b) => a.solved.compareTo(b.solved));
          break;
        case 'Most Videos':
          _topics.sort((a, b) => b.totalVideos.compareTo(a.totalVideos));
          break;
        case 'Default':
        default:
          _topics = List.from(_originalTopics);
          break;
      }
    });
  }

  void _showSortModal() {
    final sortOptions = [
      {'label': 'Default', 'icon': Icons.tune_rounded},
      {'label': 'Name (A - Z)', 'icon': Icons.sort_by_alpha_rounded},
      {'label': 'Name (Z - A)', 'icon': Icons.sort_by_alpha_rounded},
      {'label': 'Completion %', 'icon': Icons.percent_rounded},
      {'label': 'Most Solved', 'icon': Icons.trending_up_rounded},
      {'label': 'Least Solved', 'icon': Icons.trending_down_rounded},
      {'label': 'Most Videos', 'icon': Icons.video_collection_outlined},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(ctx).padding.bottom + 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort Topics',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  '${_topics.length} topics',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),

            ...sortOptions.map((opt) {
              final label = opt['label'] as String;
              final icon = opt['icon'] as IconData;
              final isSelected = _currentSort == label;

              return ListTile(
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                leading: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEEF2FF)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? const Color(0xFF2A3BD4)
                        : const Color(0xFF64748B),
                    size: 18,
                  ),
                ),
                title: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF2A3BD4)
                        : const Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF2A3BD4), size: 20)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  _applySort(label);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF1E293B),
            size: 28,
          ),
        ),
        title: Text(
          widget.subjectName,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          // ── All Subjects Section Header ──────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Subjects',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins',
                ),
              ),
              GestureDetector(
                onTap: _showSortModal,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _currentSort != 'Default'
                        ? const Color(0xFFEEF2FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _currentSort != 'Default'
                          ? const Color(0xFF2A3BD4).withValues(alpha: 0.3)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swap_vert_rounded,
                          size: 15,
                          color: _currentSort != 'Default'
                              ? const Color(0xFF2A3BD4)
                              : Colors.indigo.shade800),
                      const SizedBox(width: 4),
                      Text(
                        _currentSort == 'Default' ? 'Sort By' : _currentSort,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: _currentSort != 'Default'
                              ? const Color(0xFF2A3BD4)
                              : Colors.indigo.shade800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Topics List ───────────────────────────────────────────────────
          ..._topics.map((t) => _buildTopicCard(t)),
        ],
      ),
    );
  }

  Widget _buildTopicCard(TopicItem topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showTopicActionModal(topic),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Chevron
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ],
                ),

                // Video Lessons Available Pill
                if (topic.videoLessonsAvailable) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Video Lessons Available',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A3BD4),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Solved stats and colored dots
                Row(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 13,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${topic.solved}/${topic.total} Solved',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),

                    // Colored dot indicators
                    _buildDotGroup(topic.greenDots, const Color(0xFF22C55E)),
                    const SizedBox(width: 6),
                    _buildDotGroup(topic.yellowDots, const Color(0xFFF59E0B)),
                    const SizedBox(width: 6),
                    _buildDotGroup(topic.redDots, const Color(0xFFEF4444)),
                  ],
                ),

                const SizedBox(height: 10),

                // Completed progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      '${(topic.completedPct * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: topic.completedPct,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF2A3BD4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotGroup(int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        return Container(
          margin: const EdgeInsets.only(right: 2),
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  // ─── Modal Bottom Sheet: Solve Tests & Video Lessons ─────────────────────
  void _showTopicActionModal(TopicItem topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TopicActionModalContent(
        topic: topic,
        subjectName: widget.subjectName,
      ),
    );
  }
}

// ─── Interactive Modal Content (Stateful) ──────────────────────────────────

class _TopicActionModalContent extends StatefulWidget {
  final TopicItem topic;
  final String subjectName;

  const _TopicActionModalContent({
    required this.topic,
    required this.subjectName,
  });

  @override
  State<_TopicActionModalContent> createState() =>
      _TopicActionModalContentState();
}

class _TopicActionModalContentState extends State<_TopicActionModalContent> {
  int _currentTab = 0; // 0 = Solve Tests, 1 = Video Lessons
  int _selectedDifficulty = 0; // 0=Easy, 1=Medium, 2=Hard, 3=Past Exam, 4=0 Mistake, 5=Past Exam Alt
  VideoTypeItem? _selectedVideoType; // When non-null, shows video list drilldown

  late List<VideoTypeItem> _videoTypes;

  @override
  void initState() {
    super.initState();
    _videoTypes = [
      VideoTypeItem(
        name: 'Starter',
        dotColor: const Color(0xFF22C55E),
        watched: 2,
        total: 3,
        duration: '01:22',
        videos: [
          VideoLessonItem(
            id: 'v1',
            title: 'Word Problems with Linear Equations-1',
            duration: '08:02',
            category: 'Starter',
            isWatched: false,
          ),
          VideoLessonItem(
            id: 'v2',
            title: 'Algebra – Introduction to Equations-2',
            duration: '01:22',
            category: 'Starter',
            isWatched: true,
          ),
          VideoLessonItem(
            id: 'v3',
            title: 'Solving Linear Equations – 3',
            duration: '02:31',
            category: 'Starter',
            isWatched: true,
          ),
        ],
      ),
      VideoTypeItem(
        name: 'Normal',
        dotColor: const Color(0xFF0288D1),
        watched: 1,
        total: 2,
        duration: '02:31',
        videos: [
          VideoLessonItem(
            id: 'v4',
            title: 'Two-variable Linear Systems',
            duration: '04:15',
            category: 'Normal',
            isWatched: true,
          ),
          VideoLessonItem(
            id: 'v5',
            title: 'Coordinate Geometry & Equations',
            duration: '05:40',
            category: 'Normal',
            isWatched: false,
          ),
        ],
      ),
      VideoTypeItem(
        name: 'In Detail',
        dotColor: const Color(0xFFF59E0B),
        watched: 2,
        total: 2,
        duration: '08:02',
        videos: [
          VideoLessonItem(
            id: 'v6',
            title: 'Advanced Linear Transformations',
            duration: '08:02',
            category: 'In Detail',
            isWatched: true,
          ),
          VideoLessonItem(
            id: 'v7',
            title: 'Deep Dive into Matrix Solutions',
            duration: '07:45',
            category: 'In Detail',
            isWatched: true,
          ),
        ],
      ),
      VideoTypeItem(
        name: 'Summary',
        dotColor: const Color(0xFF8B5CF6),
        watched: 0,
        total: 2,
        duration: '04:33',
        videos: [
          VideoLessonItem(
            id: 'v8',
            title: 'Linear Equations Quick Recap',
            duration: '04:33',
            category: 'Summary',
            isWatched: false,
          ),
        ],
      ),
      VideoTypeItem(
        name: 'PS Session',
        dotColor: const Color(0xFFEC4899),
        watched: 0,
        total: 1,
        duration: '01:10',
        videos: [
          VideoLessonItem(
            id: 'v9',
            title: 'Problem Solving Mastery Live Replay',
            duration: '01:10',
            category: 'PS Session',
            isWatched: false,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Circular Dark Close Button ────────────────────────────────────
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.close_rounded, color: Colors.white, size: 20),
            ),
          ),

          const SizedBox(height: 10),

          // ── White Modal Container ─────────────────────────────────────────
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title: Linear Equations
                  Text(
                    widget.topic.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A3BD4),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle Meta (Mathematics + Solved / Watched)
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded,
                          size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        widget.subjectName,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_currentTab == 0) ...[
                        Icon(Icons.assignment_outlined,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.topic.solved}/${widget.topic.total} Solved',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ] else ...[
                        Icon(Icons.visibility_outlined,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.topic.totalWatched}/${widget.topic.totalVideos} Watched',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ÖSYM Banner
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TopicAnalysisScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECE5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'ÖSYM',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFFF6B35),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              '12 Question in past YKS.',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          const Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2A3BD4),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              size: 16, color: Color(0xFF2A3BD4)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Tab Bar: Solve Tests vs Video Lessons ─────────────────
                  Row(
                    children: [
                      _buildTabButton('Solve Tests', 0),
                      _buildTabButton('Video Lessons', 1),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Tab Content ───────────────────────────────────────────
                  if (_currentTab == 0)
                    _buildSolveTestsContent()
                  else if (_selectedVideoType == null)
                    _buildVideoTypesContent()
                  else
                    _buildVideoLessonsDrilldown(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTab = index;
            _selectedVideoType = null;
          });
        },
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF2A3BD4)
                    : const Color(0xFF64748B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2.5,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2A3BD4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Solve Tests Tab Content ──────────────────────────────────────────────
  Widget _buildSolveTestsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Difficulty Level',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Choose the level of challenge that best suits your current skills.',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 14),

        // 2x3 Grid of Difficulty Cards
        Row(
          children: [
            Expanded(
              child: _buildDifficultyCard(
                index: 0,
                color: const Color(0xFF22C55E),
                title: 'Easy',
                solvedText: '24/88 Solved',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDifficultyCard(
                index: 1,
                color: const Color(0xFFF59E0B),
                title: 'Medium',
                solvedText: '24/88 Solved',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildDifficultyCard(
                index: 2,
                color: const Color(0xFFEF4444),
                title: 'Hard',
                solvedText: '24/88 Solved',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDifficultyCard(
                index: 3,
                color: const Color(0xFFFF6B35),
                title: 'Past Exam',
                solvedText: '24/88 Solved',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildDifficultyCard(
                index: 4,
                color: const Color(0xFF3B82F6),
                title: '0 Mistake',
                solvedText: '24/88 Solved',
                hasInfo: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDifficultyCard(
                index: 5,
                color: const Color(0xFFEC4899),
                title: 'Alternative',
                subPrefix: 'Past Exam',
                solvedText: '24/88 Solved',
                hasInfo: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Start Test Action Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TestSolvingScreen(
                    topicTitle: widget.topic.title,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A3BD4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start ${widget.topic.title}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyCard({
    required int index,
    required Color color,
    required String title,
    String? subPrefix,
    required String solvedText,
    bool hasInfo = false,
  }) {
    final isSelected = _selectedDifficulty == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F5FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2A3BD4)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subPrefix != null) ...[
              Text(
                subPrefix,
                style: TextStyle(
                  fontSize: 9.5,
                  color: Colors.grey.shade500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 1),
            ],
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasInfo)
                  Icon(Icons.info_outline_rounded,
                      size: 14, color: Colors.grey.shade500),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.assignment_outlined,
                    size: 11, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  solvedText,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Video Types Selection Content ────────────────────────────────────────
  Widget _buildVideoTypesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Video Type',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Choose the type of video that best suits your current skills.',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 14),

        ..._videoTypes.map((vt) {
          final isStarter = vt.name == 'Starter';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isStarter
                    ? const Color(0xFF2A3BD4)
                    : const Color(0xFFE2E8F0),
                width: isStarter ? 1.5 : 1,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              onTap: () {
                setState(() => _selectedVideoType = vt);
              },
              leading: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: vt.dotColor, shape: BoxShape.circle),
              ),
              title: Text(
                vt.name,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins',
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.visibility_outlined,
                      size: 12, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${vt.watched}/${vt.total} Watched',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  vt.duration,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── Video Lessons Drilldown List ─────────────────────────────────────────
  Widget _buildVideoLessonsDrilldown() {
    final type = _selectedVideoType!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back to Video Types Button
        GestureDetector(
          onTap: () => setState(() => _selectedVideoType = null),
          child: const Row(
            children: [
              Icon(Icons.chevron_left_rounded,
                  size: 18, color: Color(0xFF2A3BD4)),
              SizedBox(width: 4),
              Text(
                'Back to Video Types',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A3BD4),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // List of Video Lessons
        ...type.videos.map((vid) => _buildVideoLessonRow(vid)),
      ],
    );
  }

  Widget _buildVideoLessonRow(VideoLessonItem vid) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail
          GestureDetector(
            onTap: () => _playVideo(vid),
            child: Container(
              width: 100,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF881337), Color(0xFF4C0519)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.play_circle_fill_rounded,
                      color: Colors.white, size: 28),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        vid.duration,
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
          ),

          const SizedBox(width: 12),

          // Video Meta & Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Category indicator
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vid.category,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF22C55E),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Watched / Pending pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: vid.isWatched
                            ? const Color(0xFFE8F8EE)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        vid.isWatched ? 'Watched' : 'Pending',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: vid.isWatched
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF64748B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Title
                GestureDetector(
                  onTap: () => _playVideo(vid),
                  child: Text(
                    vid.title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 3-dot Menu (Mark Watched)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                size: 18, color: Color(0xFF94A3B8)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (val) {
              if (val == 'toggle') {
                setState(() {
                  vid.isWatched = !vid.isWatched;
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      vid.isWatched
                          ? Icons.remove_done_rounded
                          : Icons.done_all_rounded,
                      size: 16,
                      color: const Color(0xFF2A3BD4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      vid.isWatched ? 'Mark Unwatched' : 'Mark Watched',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _playVideo(VideoLessonItem vid) {
    Navigator.pop(context);
    final playlist = (_selectedVideoType?.videos ?? [])
        .map(
          (v) => RelatedVideoItem(
            title: v.title,
            duration: v.duration,
            category: v.category,
            videoUrl: v.videoUrl,
            isWatched: v.isWatched,
          ),
        )
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          title: vid.title,
          videoUrl: vid.videoUrl,
          category: vid.category,
          relatedVideos: playlist.isNotEmpty ? playlist : null,
        ),
      ),
    );
  }
}
