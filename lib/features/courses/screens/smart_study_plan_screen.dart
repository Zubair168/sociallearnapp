import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sociallearnapp/features/courses/screens/test_result_screen.dart';

class SmartTopicPlan {
  final String title;
  final double projectedNetIncrease;
  final int successRateTarget;
  final int greenDots;
  final int yellowDots;
  final int redDots;
  final double completedPct;

  const SmartTopicPlan({
    required this.title,
    required this.projectedNetIncrease,
    required this.successRateTarget,
    required this.greenDots,
    required this.yellowDots,
    required this.redDots,
    required this.completedPct,
  });
}

class SmartStudyPlanScreen extends StatefulWidget {
  const SmartStudyPlanScreen({super.key});

  @override
  State<SmartStudyPlanScreen> createState() => _SmartStudyPlanScreenState();
}

class _SmartStudyPlanScreenState extends State<SmartStudyPlanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _progressAnim;

  final List<SmartTopicPlan> _plans = const [
    SmartTopicPlan(
      title: 'Linear Equations',
      projectedNetIncrease: 0.1,
      successRateTarget: 75,
      greenDots: 5,
      yellowDots: 3,
      redDots: 2,
      completedPct: 0.0,
    ),
    SmartTopicPlan(
      title: 'Quadratic Equations',
      projectedNetIncrease: 0.1,
      successRateTarget: 75,
      greenDots: 5,
      yellowDots: 3,
      redDots: 2,
      completedPct: 0.0,
    ),
    SmartTopicPlan(
      title: 'Polynomials',
      projectedNetIncrease: 0.1,
      successRateTarget: 75,
      greenDots: 5,
      yellowDots: 3,
      redDots: 2,
      completedPct: 0.0,
    ),
    SmartTopicPlan(
      title: 'Inequalities',
      projectedNetIncrease: 0.1,
      successRateTarget: 75,
      greenDots: 5,
      yellowDots: 3,
      redDots: 2,
      completedPct: 0.0,
    ),
    SmartTopicPlan(
      title: 'Exponents and Radicals',
      projectedNetIncrease: 0.1,
      successRateTarget: 75,
      greenDots: 5,
      yellowDots: 3,
      redDots: 2,
      completedPct: 0.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _progressAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
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
          'Smart Study Plan',
          style: TextStyle(
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
          // ── Description Header ───────────────────────────────────────────
          Text(
            'Based on your answers we feel the following test will help you improve your weak topics.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // ── Target Gauge Comparison Card ─────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left Gauge: Current
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "You're currently at",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _progressAnim,
                        builder: (context, _) => CustomPaint(
                          size: const Size(100, 100),
                          painter: _CurrentGaugePainter(
                            current: 3.8,
                            max: 6.0,
                            progress: _progressAnim.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 1,
                  height: 110,
                  color: const Color(0xFFF1F5F9),
                ),

                // Right Gauge: Target with Net badge
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Follow this plan to reach',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _progressAnim,
                        builder: (context, _) => CustomPaint(
                          size: const Size(100, 100),
                          painter: _TargetGaugePainter(
                            target: 4.9,
                            max: 6.0,
                            delta: 1.1,
                            progress: _progressAnim.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05),

          const SizedBox(height: 18),

          // ── Topic Cards ──────────────────────────────────────────────────
          ..._plans.map((p) => _buildSmartTopicCard(p)),
        ],
      ),
    );
  }

  Widget _buildSmartTopicCard(SmartTopicPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openTrialExam(plan.title),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Chevron
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan.title,
                      style: const TextStyle(
                        fontSize: 14,
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

                const SizedBox(height: 8),

                // Projected Net & Target Success
                Row(
                  children: [
                    // Projected Net Increase badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_outward_rounded,
                          size: 13,
                          color: Color(0xFF16A34A),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${plan.projectedNetIncrease} Projected net increase',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Dot counts: 5 green, 3 yellow, 2 red
                    _dotLabel(const Color(0xFF22C55E), plan.greenDots),
                    const SizedBox(width: 6),
                    _dotLabel(const Color(0xFFF59E0B), plan.yellowDots),
                    const SizedBox(width: 6),
                    _dotLabel(const Color(0xFFEF4444), plan.redDots),
                  ],
                ),

                const SizedBox(height: 4),

                // Target Success rate
                Row(
                  children: [
                    const Icon(
                      Icons.track_changes_rounded,
                      size: 13,
                      color: Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${plan.successRateTarget}% Success Rate Target',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Progress Bar
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
                      '${(plan.completedPct * 100).toInt()}%',
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
                    value: plan.completedPct,
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

  Widget _dotLabel(Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  void _openTrialExam(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestResultScreen(
          testTitle: title,
          totalQuestions: 10,
          correct: 8,
          incorrect: 2,
          unanswered: 0,
          netScore: 32.25,
          avgScore: 32.00,
          timeTakenSeconds: 625,
          avgTimeSeconds: 505,
          currentNet: 1513.25,
          rankChange: 10,
          currentRank: 23,
          promoted: false,
        ),
      ),
    );
  }
}

// ─── Custom Gauge Painters ───────────────────────────────────────────────────

class _CurrentGaugePainter extends CustomPainter {
  final double current;
  final double max;
  final double progress;

  _CurrentGaugePainter({
    required this.current,
    required this.max,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 8.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Blue arc
    final sweepAngle = (current / max) * 2 * math.pi * progress;
    final activePaint = Paint()
      ..color = const Color(0xFF2A3BD4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, activePaint);

    // Center text
    final textSpan = TextSpan(
      text: '${current.toStringAsFixed(1)} / ${max.toInt()}',
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
  bool shouldRepaint(covariant _CurrentGaugePainter old) =>
      old.progress != progress;
}

class _TargetGaugePainter extends CustomPainter {
  final double target;
  final double max;
  final double delta;
  final double progress;

  _TargetGaugePainter({
    required this.target,
    required this.max,
    required this.delta,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 8.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Two-tone arc: Green base + Blue target
    final greenSweep = (3.8 / max) * 2 * math.pi * progress;
    final greenPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -math.pi / 2, greenSweep, false, greenPaint);

    final blueSweep = ((target - 3.8) / max) * 2 * math.pi * progress;
    final bluePaint = Paint()
      ..color = const Color(0xFF2A3BD4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        rect, -math.pi / 2 + greenSweep, blueSweep, false, bluePaint);

    // Center Text: 4.9 / 6 + green Net badge
    final mainSpan = TextSpan(
      text: '${target.toStringAsFixed(1)} / ${max.toInt()}',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E293B),
        fontFamily: 'Poppins',
      ),
    );
    final mainTp = TextPainter(text: mainSpan, textDirection: TextDirection.ltr)
      ..layout();

    final badgeSpan = TextSpan(
      text: '+${delta.toStringAsFixed(1)} Net',
      style: const TextStyle(
        fontSize: 8.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF16A34A),
        fontFamily: 'Poppins',
      ),
    );
    final badgeTp =
        TextPainter(text: badgeSpan, textDirection: TextDirection.ltr)..layout();

    final totalH = mainTp.height + badgeTp.height + 2;
    final top = center.dy - totalH / 2;

    mainTp.paint(canvas, Offset(center.dx - mainTp.width / 2, top));
    badgeTp.paint(
        canvas, Offset(center.dx - badgeTp.width / 2, top + mainTp.height + 2));
  }

  @override
  bool shouldRepaint(covariant _TargetGaugePainter old) =>
      old.progress != progress;
}
