import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sociallearnapp/features/courses/screens/smart_study_plan_screen.dart';
import 'package:sociallearnapp/features/courses/screens/subject_topics_screen.dart';
import 'package:sociallearnapp/features/courses/screens/topic_analysis_screen.dart';

class SubjectTrialExam {
  final String title;
  final int completed;
  final int total;
  final double scorePct;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const SubjectTrialExam({
    required this.title,
    required this.completed,
    required this.total,
    required this.scorePct,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

class TrialExamsScreen extends StatefulWidget {
  const TrialExamsScreen({super.key});

  @override
  State<TrialExamsScreen> createState() => _TrialExamsScreenState();
}

class _TrialExamsScreenState extends State<TrialExamsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<SubjectTrialExam> _tytExams = const [
    SubjectTrialExam(
      title: 'Biology Trial Exams',
      completed: 5,
      total: 10,
      scorePct: 0.60,
      icon: Icons.biotech_rounded,
      iconBg: Color(0xFFEBF4FF),
      iconColor: Color(0xFF3B82F6),
    ),
    SubjectTrialExam(
      title: 'Physics Trial Exams',
      completed: 8,
      total: 10,
      scorePct: 0.80,
      icon: Icons.science_outlined,
      iconBg: Color(0xFFF5EEFD),
      iconColor: Color(0xFF8B5CF6),
    ),
    SubjectTrialExam(
      title: 'Math Trial Exams',
      completed: 3,
      total: 10,
      scorePct: 0.30,
      icon: Icons.calculate_outlined,
      iconBg: Color(0xFFE0F7FE),
      iconColor: Color(0xFF0288D1),
    ),
    SubjectTrialExam(
      title: 'History Trial Exams',
      completed: 4,
      total: 10,
      scorePct: 0.40,
      icon: Icons.account_balance_outlined,
      iconBg: Color(0xFFFEF3C7),
      iconColor: Color(0xFFD97706),
    ),
  ];

  final List<SubjectTrialExam> _aytExams = const [
    SubjectTrialExam(
      title: 'Math AYT Trial Exams',
      completed: 6,
      total: 10,
      scorePct: 0.75,
      icon: Icons.calculate_outlined,
      iconBg: Color(0xFFE0F7FE),
      iconColor: Color(0xFF0288D1),
    ),
    SubjectTrialExam(
      title: 'Literature Trial Exams',
      completed: 5,
      total: 10,
      scorePct: 0.65,
      icon: Icons.menu_book_rounded,
      iconBg: Color(0xFFEDE9FE),
      iconColor: Color(0xFF7C3AED),
    ),
    SubjectTrialExam(
      title: 'Physics AYT Trial Exams',
      completed: 4,
      total: 10,
      scorePct: 0.50,
      icon: Icons.science_outlined,
      iconBg: Color(0xFFF5EEFD),
      iconColor: Color(0xFF8B5CF6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text(
          'Trial Exams',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ── Header Notice ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              'You need to complete at least 5 trial exams to access the Smart Study Plan',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
                height: 1.35,
              ),
            ),
          ),

          // ── Tab Bar (TYT / AYT) ──────────────────────────────────────────
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF2A3BD4),
              indicatorWeight: 2.5,
              labelColor: const Color(0xFF2A3BD4),
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              tabs: const [
                Tab(text: 'TYT'),
                Tab(text: 'AYT'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Tab Views ────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExamsList(_tytExams),
                _buildExamsList(_aytExams),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamsList(List<SubjectTrialExam> exams) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return _buildExamCard(exam);
      },
    );
  }

  Widget _buildExamCard(SubjectTrialExam exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Top Row: Icon, Title, Completed count, Circular Gauge
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubjectTopicsScreen(
                    subjectName: exam.title.replaceAll(' Trial Exams', ''),
                    trialExamsCompleted: exam.completed,
                    trialExamsTotal: exam.total,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                // Subject Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: exam.iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(exam.icon, color: exam.iconColor, size: 24),
                ),
                const SizedBox(width: 12),

                // Title and Completed text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              exam.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF94A3B8),
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Completed : ${exam.completed}/${exam.total}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Circular Progress Indicator Ring
                CustomPaint(
                  size: const Size(48, 48),
                  painter: _ExamCirclePainter(pct: exam.scorePct),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Bottom Buttons: Smart Study Plan & Detailed Analysis
          Row(
            children: [
              // Smart Study Plan
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SmartStudyPlanScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.psychology_outlined,
                          size: 18, color: Colors.indigo.shade800),
                      const SizedBox(width: 6),
                      Text(
                        'Smart Study Plan',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 24,
                color: const Color(0xFFF1F5F9),
              ),

              // Detailed Analysis
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TopicAnalysisScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insights_rounded,
                          size: 18, color: Colors.indigo.shade800),
                      const SizedBox(width: 6),
                      Text(
                        'Detailed Analysis',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExamCirclePainter extends CustomPainter {
  final double pct;

  _ExamCirclePainter({required this.pct});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 4.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc
    final sweep = pct * 2 * math.pi;
    final activePaint = Paint()
      ..color = const Color(0xFF2A3BD4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, activePaint);

    // Center Percentage Text
    final textSpan = TextSpan(
      text: '${(pct * 100).toInt()}%',
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E293B),
        fontFamily: 'Poppins',
      ),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ExamCirclePainter old) => old.pct != pct;
}
