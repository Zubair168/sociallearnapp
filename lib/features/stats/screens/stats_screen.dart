import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/courses/screens/favorited_questions_screen.dart';
import 'package:sociallearnapp/features/notifications/screens/notifications_screen.dart';
import 'package:sociallearnapp/features/profile/screens/profile_screen.dart';

class StatsScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onSolveQuestions;

  const StatsScreen({
    super.key,
    this.onOpenDrawer,
    this.onSolveQuestions,
  });

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  final bool _hasData = true;
  String _selectedCourse = 'All Courses';
  late AnimationController _donutController;
  late Animation<double> _donutAnim;

  final List<String> _courseOptions = [
    'All Courses',
    'Mathematics',
    'Turkish',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'Geography',
  ];

  final Map<String, Map<String, dynamic>> _courseStats = {
    'All Courses': {
      'solved': '1148',
      'pct': '63%',
      'time': '02:03',
      'correct': 38,
      'incorrect': 6,
      'unanswered': 6,
    },
    'Mathematics': {
      'solved': '342',
      'pct': '72%',
      'time': '01:45',
      'correct': 45,
      'incorrect': 3,
      'unanswered': 2,
    },
    'Turkish': {
      'solved': '280',
      'pct': '68%',
      'time': '01:30',
      'correct': 32,
      'incorrect': 8,
      'unanswered': 4,
    },
    'Physics': {
      'solved': '164',
      'pct': '54%',
      'time': '02:40',
      'correct': 24,
      'incorrect': 12,
      'unanswered': 8,
    },
    'Chemistry': {
      'solved': '145',
      'pct': '61%',
      'time': '02:10',
      'correct': 28,
      'incorrect': 7,
      'unanswered': 5,
    },
    'Biology': {
      'solved': '112',
      'pct': '75%',
      'time': '01:20',
      'correct': 36,
      'incorrect': 4,
      'unanswered': 4,
    },
    'History': {
      'solved': '65',
      'pct': '80%',
      'time': '01:15',
      'correct': 40,
      'incorrect': 5,
      'unanswered': 2,
    },
    'Geography': {
      'solved': '40',
      'pct': '70%',
      'time': '01:10',
      'correct': 28,
      'incorrect': 6,
      'unanswered': 6,
    },
  };

  @override
  void initState() {
    super.initState();
    _donutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _donutAnim = CurvedAnimation(
      parent: _donutController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _donutController.dispose();
    super.dispose();
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Harsh';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FC);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onOpenDrawer,
                          child: Icon(Icons.notes_rounded,
                              size: 26, color: textPrimary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_formatCurrentDate(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                                      fontFamily: 'Poppins'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text('Welcome back, $name',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2A3BD4),
                                      fontFamily: 'Poppins'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(Icons.notifications_none_rounded,
                                color: textPrimary, size: 24),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        ),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1.5),
                            image: user?.photoURL != null
                                ? DecorationImage(
                                    image: NetworkImage(user!.photoURL!),
                                    fit: BoxFit.cover)
                                : const DecorationImage(
                                    image: NetworkImage(
                                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150'),
                                    fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
                child: _hasData ? _buildActiveState() : _buildEmptyState()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.18,
                child: CustomPaint(
                    size: const Size(240, 240),
                    painter: _EmptyStatsBgPainter()),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16)
                  ],
                ),
                child: const Icon(Icons.analytics_outlined,
                    size: 36, color: Color(0xFF2A3BD4)),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Start solving questions to see\nyour stats here.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
                height: 1.4),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: widget.onSolveQuestions,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3BD4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF2A3BD4).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Solve Questions',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildActiveState() {
    final currentStats =
        _courseStats[_selectedCourse] ?? _courseStats['All Courses']!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          GestureDetector(
            onTap: _showCourseDropdown,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedCourse,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Poppins')),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF64748B), size: 22),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 14),

          // 3 Stat tiles
          Row(
            children: [
              Expanded(
                  child: _buildStatTile(
                      'Questions\nSolved', currentStats['solved'] as String)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildStatTile(
                      'Correct\nPercentage', currentStats['pct'] as String)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildStatTile(
                      'Avg Solving\nTime', currentStats['time'] as String)),
            ],
          ).animate(delay: 60.ms).fadeIn(duration: 300.ms),

          const SizedBox(height: 16),

          // Question Analysis Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Question Analysis',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins')),
                const SizedBox(height: 16),
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _donutAnim,
                      builder: (context, _) => CustomPaint(
                        size: const Size(120, 120),
                        painter: _DonutChartPainter(
                          correct: currentStats['correct'] as int,
                          incorrect: currentStats['incorrect'] as int,
                          unanswered: currentStats['unanswered'] as int,
                          progress: _donutAnim.value,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildAnalysisRow(
                              color: const Color(0xFF22C55E),
                              label: 'Correct',
                              value: '${currentStats['correct']}'),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          _buildAnalysisRow(
                              color: const Color(0xFFEF4444),
                              label: 'Incorrect',
                              value: '${currentStats['incorrect']}'),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          _buildAnalysisRow(
                              color: const Color(0xFFF59E0B),
                              label: 'Unanswered',
                              value: '${currentStats['unanswered']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate(delay: 120.ms).fadeIn(duration: 300.ms),

          const SizedBox(height: 12),

          // Favorites & Notes
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              children: [
                _buildListStatRow(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  label: 'Favorite Questions',
                  value: '112',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoritedQuestionsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFF1F5F9)),
                _buildListStatRow(
                  icon: Icons.description_outlined,
                  iconColor: const Color(0xFF2A3BD4),
                  label: 'Questions with Notes',
                  value: '36',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoritedQuestionsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ).animate(delay: 160.ms).fadeIn(duration: 300.ms),

          const SizedBox(height: 16),

          const Text('Success rate in every difficulty level',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins'))
              .animate(delay: 200.ms)
              .fadeIn(),

          const SizedBox(height: 12),

          ...[
            _buildDifficultyBar('Easy', const Color(0xFF22C55E), 0.78),
            _buildDifficultyBar('Medium', const Color(0xFFF59E0B), 0.60),
            _buildDifficultyBar('Hard', const Color(0xFFEF4444), 0.35),
            _buildDifficultyBar('Past Exam', const Color(0xFF2A3BD4), 0.52),
          ].animate(delay: 220.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10.5,
                  color: Colors.grey.shade500,
                  fontFamily: 'Poppins',
                  height: 1.3)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(
      {required Color color, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins'))),
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins')),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded,
              size: 18, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  Widget _buildListStatRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBar(String label, Color color, double value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins')),
              Text('${(value * 100).toInt()}%',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                      fontFamily: 'Poppins')),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseDropdown() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Select Course',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins')),
          ),
          const SizedBox(height: 8),
          ..._courseOptions.map((c) => ListTile(
                onTap: () {
                  setState(() {
                    _selectedCourse = c;
                    _donutController.reset();
                    _donutController.forward();
                  });
                  Navigator.pop(ctx);
                },
                title: Text(c,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: _selectedCourse == c
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: _selectedCourse == c
                            ? const Color(0xFF2A3BD4)
                            : const Color(0xFF1E293B))),
                trailing: _selectedCourse == c
                    ? const Icon(Icons.check_rounded,
                        color: Color(0xFF2A3BD4), size: 20)
                    : null,
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── Painters ──────────────────────────────────────────────────────────────────

class _DonutChartPainter extends CustomPainter {
  final int correct;
  final int incorrect;
  final int unanswered;
  final double progress;

  _DonutChartPainter({
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = correct + incorrect + unanswered;
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 14.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final segments = [
      {'v': correct / total, 'c': const Color(0xFF22C55E)},
      {'v': incorrect / total, 'c': const Color(0xFFEF4444)},
      {'v': unanswered / total, 'c': const Color(0xFFF59E0B)},
    ];

    double startAngle = -math.pi / 2;
    const gap = 0.05;

    for (final seg in segments) {
      final sweep = (seg['v'] as double) * 2 * math.pi * progress;
      final paint = Paint()
        ..color = seg['c'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
          rect, startAngle + gap / 2, sweep - gap, false, paint);
      startAngle += sweep;
    }

    // Center text
    final pct = ((correct / total) * 100).toInt();
    _drawCenterText(canvas, center, '$pct%', 'Success\nPercentage');
  }

  void _drawCenterText(
      Canvas canvas, Offset center, String big, String small) {
    final bigSpan = TextSpan(
      text: big,
      style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E293B),
          fontFamily: 'Poppins'),
    );
    final bigPainter = TextPainter(
        text: bigSpan, textDirection: TextDirection.ltr)
      ..layout();

    final smallSpan = TextSpan(
      text: small,
      style: TextStyle(
          fontSize: 9,
          color: Colors.grey.shade500,
          fontFamily: 'Poppins',
          height: 1.3),
    );
    final smallPainter = TextPainter(
        text: smallSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 72);

    final totalHeight = bigPainter.height + 2 + smallPainter.height;
    final top = center.dy - totalHeight / 2;

    bigPainter.paint(
        canvas, Offset(center.dx - bigPainter.width / 2, top));
    smallPainter.paint(
        canvas,
        Offset(center.dx - smallPainter.width / 2,
            top + bigPainter.height + 2));
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter old) =>
      old.progress != progress;
}

class _EmptyStatsBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final colors = [
      const Color(0xFF22C55E),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF2A3BD4),
    ];
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        center,
        40.0 + i * 20,
        Paint()
          ..color = colors[i].withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
