import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sociallearnapp/features/courses/screens/smart_study_plan_screen.dart';

class TopicAnalysisItem {
  final String title;
  final int solvedQuestions;
  final int correct;
  final int incorrect;
  final int unanswered;
  final int askedIn2025;
  final Map<String, int> yearlyStats;
  bool isExpanded;

  TopicAnalysisItem({
    required this.title,
    required this.solvedQuestions,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.askedIn2025,
    required this.yearlyStats,
    this.isExpanded = false,
  });
}

class TopicAnalysisScreen extends StatefulWidget {
  const TopicAnalysisScreen({super.key});

  @override
  State<TopicAnalysisScreen> createState() => _TopicAnalysisScreenState();
}

class _TopicAnalysisScreenState extends State<TopicAnalysisScreen> {
  late List<TopicAnalysisItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      TopicAnalysisItem(
        title: 'Linear Equations',
        solvedQuestions: 8,
        correct: 8,
        incorrect: 1,
        unanswered: 1,
        askedIn2025: 10,
        yearlyStats: {
          'YKS 2020': 12,
          'YKS 2021': 9,
          'YKS 2022': 4,
          'YKS 2023': 13,
          'YKS 2024': 18,
          'YKS 2025': 4,
        },
        isExpanded: false,
      ),
      TopicAnalysisItem(
        title: 'Quadratic Equations',
        solvedQuestions: 3,
        correct: 8,
        incorrect: 1,
        unanswered: 1,
        askedIn2025: 8,
        yearlyStats: {
          'YKS 2020': 12,
          'YKS 2021': 9,
          'YKS 2022': 4,
          'YKS 2023': 13,
          'YKS 2024': 18,
          'YKS 2025': 4,
        },
        isExpanded: true,
      ),
      TopicAnalysisItem(
        title: 'Polynomials',
        solvedQuestions: 4,
        correct: 8,
        incorrect: 1,
        unanswered: 1,
        askedIn2025: 10,
        yearlyStats: {
          'YKS 2020': 12,
          'YKS 2021': 9,
          'YKS 2022': 4,
          'YKS 2023': 13,
          'YKS 2024': 18,
          'YKS 2025': 4,
        },
        isExpanded: false,
      ),
    ];
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
          'Topic Analysis',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
            children: [
              // Subtitle & Sort By
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Topic wise performance analysis of your trial exams',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Icon(Icons.swap_vert_rounded,
                          size: 16, color: Colors.indigo.shade800),
                      const SizedBox(width: 3),
                      Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Cards List
              ..._items.map((item) => _buildTopicAnalysisCard(item)),
            ],
          ),

          // Bottom Floating CTA: View Smart Study Plan
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SmartStudyPlanScreen(),
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
                  icon: const Icon(Icons.psychology_outlined,
                      color: Colors.white, size: 20),
                  label: const Text(
                    'View Smart Study Plan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicAnalysisCard(TopicAnalysisItem item) {
    final total = item.correct + item.incorrect + item.unanswered;
    final successPct = total == 0 ? 0 : ((item.correct / total) * 100).toInt();

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),

            // Subtitle
            Row(
              children: [
                Icon(Icons.assignment_outlined,
                    size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        const TextSpan(text: 'You solved '),
                        TextSpan(
                          text: '${item.solvedQuestions} questions',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const TextSpan(text: ' from this topic in trial exams.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Success Percentage + Donut Chart & Legend
            const Text(
              'Success Percentage',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Mini Donut Chart
                CustomPaint(
                  size: const Size(82, 82),
                  painter: _TopicDonutPainter(
                    correct: item.correct,
                    incorrect: item.incorrect,
                    unanswered: item.unanswered,
                    pctText: '$successPct%',
                  ),
                ),

                const SizedBox(width: 20),

                // Legend
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendRow(const Color(0xFF22C55E),
                          '${item.correct} Correct'),
                      const SizedBox(height: 6),
                      _legendRow(const Color(0xFFEF4444),
                          '${item.incorrect} Incorrect'),
                      const SizedBox(height: 6),
                      _legendRow(const Color(0xFFF59E0B),
                          '${item.unanswered} Unanswered'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Expandable ÖSYM section
            GestureDetector(
              onTap: () {
                setState(() {
                  item.isExpanded = !item.isExpanded;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // ÖSYM Badge
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
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                              children: [
                                TextSpan(
                                  text: '${item.askedIn2025} Questions ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                                const TextSpan(text: 'asked in 2025 exam'),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          item.isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xFF64748B),
                          size: 20,
                        ),
                      ],
                    ),

                    if (item.isExpanded) ...[
                      const SizedBox(height: 10),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 8),
                      ...item.yearlyStats.entries.map((stat) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                stat.key,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                '${stat.value}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendRow(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class _TopicDonutPainter extends CustomPainter {
  final int correct;
  final int incorrect;
  final int unanswered;
  final String pctText;

  _TopicDonutPainter({
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.pctText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = correct + incorrect + unanswered;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 8.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (total == 0) return;

    final segments = [
      {'v': correct / total, 'c': const Color(0xFF22C55E)},
      {'v': incorrect / total, 'c': const Color(0xFFEF4444)},
      {'v': unanswered / total, 'c': const Color(0xFFF59E0B)},
    ];

    double angle = -math.pi / 2;
    const gap = 0.05;

    for (final seg in segments) {
      final sweep = (seg['v'] as double) * 2 * math.pi;
      if (sweep <= 0) continue;
      canvas.drawArc(
        rect,
        angle + gap / 2,
        sweep - gap,
        false,
        Paint()
          ..color = seg['c'] as Color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
      angle += sweep;
    }

    // Center text
    final textSpan = TextSpan(
      text: pctText,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E293B),
        fontFamily: 'Poppins',
      ),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _TopicDonutPainter old) => false;
}
