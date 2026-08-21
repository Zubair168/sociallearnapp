import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sociallearnapp/features/courses/screens/subject_topics_screen.dart';

class TestResultScreen extends StatefulWidget {
  final String testTitle;
  final int totalQuestions;
  final int correct;
  final int incorrect;
  final int unanswered;
  final double netScore;
  final double avgScore;
  final int timeTakenSeconds;
  final int avgTimeSeconds;
  final double currentNet;
  final int rankChange;
  final int currentRank;
  final bool promoted;
  final String? promotedTier;

  const TestResultScreen({
    super.key,
    this.testTitle = 'Linear Equations',
    this.totalQuestions = 10,
    this.correct = 8,
    this.incorrect = 2,
    this.unanswered = 0,
    this.netScore = 32.25,
    this.avgScore = 32.00,
    this.timeTakenSeconds = 625,
    this.avgTimeSeconds = 505,
    this.currentNet = 1513.25,
    this.rankChange = 10,
    this.currentRank = 23,
    this.promoted = false,
    this.promotedTier,
  });

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _donutCtrl;
  late Animation<double> _donutAnim;
  bool _showPromo = false;

  @override
  void initState() {
    super.initState();
    _donutCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    _donutAnim =
        CurvedAnimation(parent: _donutCtrl, curve: Curves.easeOut);

    if (widget.promoted) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _showPromo = true);
      });
    }
  }

  @override
  void dispose() {
    _donutCtrl.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: Stack(
        children: [
          // Main scrollable content
          CustomScrollView(
            slivers: [
              // App Bar with confetti header
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Net Score Card
                    _buildNetScoreCard(),
                    const SizedBox(height: 16),

                    // Attempt Summary
                    _buildAttemptSummary(),
                    const SizedBox(height: 16),

                    // View Answers Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => _showViewAnswersSheet(context),
                        icon: const Icon(Icons.visibility_outlined,
                            size: 18, color: Color(0xFF2A3BD4)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF2A3BD4), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        label: const Text('View Answers',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2A3BD4),
                                fontFamily: 'Poppins')),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Score Section
                    _buildScoreSection(),
                    const SizedBox(height: 16),

                    // Time Taken Section
                    _buildTimeTakenSection(),
                  ]),
                ),
              ),
            ],
          ),

          // Bottom Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomButtons(context),
          ),

          // Promoted Dialog Overlay
          if (_showPromo)
            _buildPromotedOverlay(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        // Gradient header background
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFFFF8F0), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(),
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              // App bar row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: isDark ? Colors.white : const Color(0xFF1E293B)),
                    ),
                    const SizedBox(width: 12),
                    Text('Test Result',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                            fontFamily: 'Poppins')),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Celebration icon
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF2A3BD4).withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: const Icon(Icons.celebration_rounded,
                    size: 38, color: Color(0xFF2A3BD4)),
              ).animate().scale(
                  duration: 500.ms, curve: Curves.elasticOut),

              const SizedBox(height: 14),

              const Text('You have completed the test for',
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontFamily: 'Poppins')),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  widget.testTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text("Here is your result:",
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontFamily: 'Poppins')),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNetScoreCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final positive = widget.rankChange > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Net score row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Current Net',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        widget.currentNet.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Poppins'),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+${widget.netScore.toStringAsFixed(2)} Net',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Gold badge icon
              _buildGoldBadge(size: 56),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar Silver → Platinum
          _buildTierProgress(),

          const SizedBox(height: 14),

          // Rank notification
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: positive
                  ? const Color(0xFFF0FDF4)
                  : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: positive
                    ? const Color(0xFFBBF7D0)
                    : const Color(0xFFFED7AA),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: positive
                        ? const Color(0xFF2A3BD4)
                        : const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('${widget.rankChange.abs()}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Poppins')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        positive
                            ? "You've moved up by ${widget.rankChange} Ranks on the\nDaily Leaderboard! Keep it Up!"
                            : "You've moved down by ${widget.rankChange.abs()} Ranks on the\nDaily Leaderboard! Try to bounce back!",
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: positive
                                ? const Color(0xFF15803D)
                                : const Color(0xFF92400E),
                            fontFamily: 'Poppins',
                            height: 1.3),
                      ),
                      const SizedBox(height: 2),
                      Text('Current Rank #${widget.currentRank}',
                          style: TextStyle(
                              fontSize: 10.5,
                              color: Colors.grey.shade500,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05);
  }

  Widget _buildTierProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('25 more net needed for Platinum',
            style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade500,
                fontFamily: 'Poppins')),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('Silver',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    fontFamily: 'Poppins')),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 0.82,
                  minHeight: 6,
                  backgroundColor: Color(0xFFE2E8F0),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFF2A3BD4)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Platinum',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    fontFamily: 'Poppins')),
          ],
        ),
      ],
    );
  }

  Widget _buildAttemptSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Attempt Summary',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins')),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                    'Total Questions: ${widget.totalQuestions}',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                        fontFamily: 'Poppins')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Donut
              AnimatedBuilder(
                animation: _donutAnim,
                builder: (context, child) => CustomPaint(
                  size: const Size(110, 110),
                  painter: _DonutResultPainter(
                    correct: widget.correct,
                    incorrect: widget.incorrect,
                    unanswered: widget.unanswered,
                    total: widget.totalQuestions,
                    progress: _donutAnim.value,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Legend
              Expanded(
                child: Column(
                  children: [
                    _resultLegendRow(
                        color: const Color(0xFF22C55E),
                        label: 'Correct',
                        value: widget.correct,
                        avg: 6),
                    const SizedBox(height: 10),
                    _resultLegendRow(
                        color: const Color(0xFFEF4444),
                        label: 'Incorrect',
                        value: widget.incorrect,
                        avg: 3),
                    const SizedBox(height: 10),
                    _resultLegendRow(
                        color: const Color(0xFFF59E0B),
                        label: 'Unanswered',
                        value: widget.unanswered,
                        avg: 1),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 350.ms);
  }

  Widget _resultLegendRow(
      {required Color color,
      required String label,
      required int value,
      required int avg}) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins'))),
        Text('$value',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins')),
        const SizedBox(width: 6),
        Text('Avg $avg',
            style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade400,
                fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _buildScoreSection() {
    final diff = widget.netScore - widget.avgScore;
    final positive = diff >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Score',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins')),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _scoreItem(
                    label: 'Net Score',
                    value: widget.netScore.toStringAsFixed(2)),
              ),
              Container(
                  width: 1, height: 50, color: const Color(0xFFF1F5F9)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _scoreItem(
                      label: 'Average Score',
                      value: widget.avgScore.toStringAsFixed(2)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: positive
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(
                positive
                    ? '${diff.abs().toStringAsFixed(2)} Net better than average'
                    : '${diff.abs().toStringAsFixed(2)} Net worse than average',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: positive
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 350.ms);
  }

  Widget _scoreItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Color(0xFF2A3BD4), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontFamily: 'Poppins')),
          ],
        ),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _buildTimeTakenSection() {
    final diffSec = widget.timeTakenSeconds - widget.avgTimeSeconds;
    final faster = diffSec < 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Time Taken',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins')),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _scoreItem(
                    label: 'You',
                    value: _formatTime(widget.timeTakenSeconds)),
              ),
              Container(
                  width: 1, height: 50, color: const Color(0xFFF1F5F9)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _scoreItem(
                      label: 'Average time others',
                      value: _formatTime(widget.avgTimeSeconds)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: faster
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(
                faster
                    ? '${_formatTime(diffSec.abs())} faster than average'
                    : '${_formatTime(diffSec.abs())} slower than average',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: faster
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 350.ms);
  }

  Widget _buildBottomButtons(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          // Home Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0)),
              ),
              child: Icon(Icons.home_rounded,
                  color: isDark ? Colors.white70 : const Color(0xFF64748B), size: 22),
            ),
          ),
          const SizedBox(width: 8),

          // Switch Difficulty
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showSwitchDifficultySheet(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: Color(0xFF2A3BD4), width: 1.5),
              ),
              child: const Text('Switch Difficulty',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A3BD4),
                      fontFamily: 'Poppins')),
            ),
          ),
          const SizedBox(width: 8),

          // Next Test
          Expanded(
            child: ElevatedButton(
              onPressed: () => _startNextTest(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A3BD4),
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Next Test',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Switch Difficulty Bottom Sheet ────────────────────────────────────────
  void _showSwitchDifficultySheet(BuildContext context) {
    final difficulties = [
      {'label': 'Easy', 'color': const Color(0xFF22C55E), 'icon': Icons.sentiment_satisfied_alt_rounded},
      {'label': 'Medium', 'color': const Color(0xFFF59E0B), 'icon': Icons.sentiment_neutral_rounded},
      {'label': 'Hard', 'color': const Color(0xFFEF4444), 'icon': Icons.sentiment_very_dissatisfied_rounded},
      {'label': 'Past Exam', 'color': const Color(0xFFFF6B35), 'icon': Icons.history_edu_rounded},
      {'label': '0 Mistake', 'color': const Color(0xFF3B82F6), 'icon': Icons.verified_rounded},
      {'label': 'Alternative', 'color': const Color(0xFFEC4899), 'icon': Icons.auto_fix_high_rounded},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(ctx).padding.bottom + 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
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
            const Text('Switch Difficulty',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins')),
            const SizedBox(height: 4),
            Text('Choose a new difficulty to restart this test',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 18),

            // 2-column grid of difficulty options
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.8,
              ),
              itemCount: difficulties.length,
              itemBuilder: (_, i) {
                final d = difficulties[i];
                final color = d['color'] as Color;
                final icon = d['icon'] as IconData;
                final label = d['label'] as String;
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestResultScreen(
                          testTitle: widget.testTitle,
                          totalQuestions: widget.totalQuestions,
                          correct: widget.correct,
                          incorrect: widget.incorrect,
                          unanswered: widget.unanswered,
                          netScore: widget.netScore,
                          avgScore: widget.avgScore,
                          timeTakenSeconds: widget.timeTakenSeconds,
                          avgTimeSeconds: widget.avgTimeSeconds,
                          currentNet: widget.currentNet,
                          rankChange: widget.rankChange,
                          currentRank: widget.currentRank,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 20),
                        const SizedBox(width: 8),
                        Text(label,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: color,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Next Test Navigation ───────────────────────────────────────────────────
  void _startNextTest(BuildContext context) {
    // Pop the current result screen and go to the subject topics screen
    // to pick the next test topic
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SubjectTopicsScreen(
          subjectName: 'Mathematics',
        ),
      ),
    );
  }

  // ─── View Answers Bottom Sheet ──────────────────────────────────────────────
  void _showViewAnswersSheet(BuildContext context) {
    final questions = List.generate(widget.totalQuestions, (i) {
      final status = i < widget.correct
          ? 'correct'
          : i < widget.correct + widget.incorrect
              ? 'incorrect'
              : 'unanswered';
      return {
        'number': i + 1,
        'status': status,
        'yourAnswer': status == 'unanswered' ? '-' : ['A', 'B', 'C', 'D'][i % 4],
        'correctAnswer': ['A', 'B', 'C', 'D'][i % 4],
      };
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle + header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Column(
                  children: [
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
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Answer Review',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins')),
                        // Summary pills
                        Row(
                          children: [
                            _answerPill(
                                '${widget.correct}✓', const Color(0xFF22C55E)),
                            const SizedBox(width: 6),
                            _answerPill(
                                '${widget.incorrect}✗', const Color(0xFFEF4444)),
                            const SizedBox(width: 6),
                            _answerPill(
                                '${widget.unanswered}-', const Color(0xFFF59E0B)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ],
                ),
              ),

              // Questions list
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  itemCount: questions.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (_, i) {
                    final q = questions[i];
                    final status = q['status'] as String;
                    final Color statusColor = status == 'correct'
                        ? const Color(0xFF22C55E)
                        : status == 'incorrect'
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFF59E0B);
                    final IconData statusIcon = status == 'correct'
                        ? Icons.check_circle_rounded
                        : status == 'incorrect'
                            ? Icons.cancel_rounded
                            : Icons.radio_button_unchecked_rounded;

                    return InkWell(
                      onTap: () => _showSolutionHelpfulModal(context, q['number'] as int),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        child: Row(
                          children: [
                            // Question number
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text('${q['number']}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: statusColor,
                                      fontFamily: 'Poppins')),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Question ${q['number']}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E293B),
                                          fontFamily: 'Poppins')),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text('Your answer: ${q['yourAnswer']}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: statusColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins')),
                                      if (status == 'incorrect') ...[
                                        const SizedBox(width: 8),
                                        Text(
                                            'Correct: ${q['correctAnswer']}',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF22C55E),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins')),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(statusIcon, color: statusColor, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Modal: Was this solution Helpful? (Screenshot 8) ──────────────────────
  void _showSolutionHelpfulModal(BuildContext context, int questionNumber) {
    bool? isHelpful;
    final commentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Was this solution Helpful?',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),

                // Thumbs Up / Down Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Yes (Thumbs Up)
                    GestureDetector(
                      onTap: () => setModalState(() => isHelpful = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isHelpful == true ? const Color(0xFFE0F2FE) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isHelpful == true ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFF6FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.thumb_up_alt_rounded, color: Color(0xFF0284C7), size: 30),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),

                    // No (Thumbs Down)
                    GestureDetector(
                      onTap: () => setModalState(() => isHelpful = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isHelpful == false ? const Color(0xFFFEE2E2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isHelpful == false ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.thumb_down_alt_rounded, color: Color(0xFF94A3B8), size: 30),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                if (isHelpful != null) ...[
                  const SizedBox(height: 18),
                  TextField(
                    controller: commentCtrl,
                    decoration: InputDecoration(
                      hintText: 'Add a comment (Optional)',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontFamily: 'Poppins'),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Close', style: TextStyle(color: Color(0xFF64748B), fontFamily: 'Poppins')),
                      ),
                    ),
                    if (isHelpful != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Feedback submitted! Thank you.'), backgroundColor: Color(0xFF16A34A), behavior: SnackBarBehavior.floating),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A3BD4),
                            minimumSize: const Size(0, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _answerPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Poppins')),
    );
  }

  Widget _buildPromotedOverlay(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showPromo = false),
      child: Container(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CustomPaint(
                      size: const Size(double.infinity, 340),
                      painter: _ConfettiPainter(dense: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("You've been promoted to",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontFamily: 'Poppins')),
                        const SizedBox(height: 14),

                        // Animated badge
                        _buildGoldBadge(
                                size: 100,
                                color: const Color(0xFF8B5CF6),
                                starColor: Colors.white)
                            .animate()
                            .scale(
                                duration: 600.ms,
                                curve: Curves.elasticOut),

                        const SizedBox(height: 14),
                        const Text('Platinum Tier',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins')),
                        const SizedBox(height: 6),
                        const Text('Your Current Points',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontFamily: 'Poppins')),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('883',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'Poppins')),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('+64 Points',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF16A34A),
                                      fontFamily: 'Poppins')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Tier icons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildGoldBadge(size: 40, color: const Color(0xFFCD7F32)),
                            const SizedBox(width: 12),
                            _buildGoldBadge(size: 40, color: const Color(0xFFC0C0C0)),
                            const SizedBox(width: 12),
                            _buildGoldBadge(size: 40, color: const Color(0xFFFFD700)),
                            const SizedBox(width: 12),
                            _buildGoldBadge(size: 40, color: const Color(0xFF8B5CF6)),
                          ],
                        ),

                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () =>
                                setState(() => _showPromo = false),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(
                                  color: Color(0xFFE2E8F0), width: 1.5),
                            ),
                            child: const Text('Close',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'Poppins')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.easeOut)
                .fadeIn(),
          ),
        ),
      ),
    );
  }

  Widget _buildGoldBadge(
      {double size = 56,
      Color color = const Color(0xFFD97706),
      Color starColor = const Color(0xFFFEF3C7)}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.9), color],
          center: Alignment.center,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: size * 0.3,
              offset: const Offset(0, 4))
        ],
      ),
      child: Icon(Icons.star_rounded, color: starColor, size: size * 0.55),
    );
  }
}

// ─── Painters ─────────────────────────────────────────────────────────────────

class _DonutResultPainter extends CustomPainter {
  final int correct;
  final int incorrect;
  final int unanswered;
  final int total;
  final double progress;

  _DonutResultPainter({
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.total,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeWidth = 13.0;
    const gap = 0.06;

    final segments = [
      {'v': correct / total, 'c': const Color(0xFF22C55E)},
      {'v': incorrect / total, 'c': const Color(0xFFEF4444)},
      {'v': unanswered / total, 'c': const Color(0xFFF59E0B)},
    ];

    double angle = -math.pi / 2;
    for (final seg in segments) {
      final sweep = (seg['v'] as double) * 2 * math.pi * progress;
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
            ..strokeCap = StrokeCap.round);
      angle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutResultPainter old) =>
      old.progress != progress;
}

class _ConfettiPainter extends CustomPainter {
  final bool dense;
  _ConfettiPainter({this.dense = false});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final colors = [
      const Color(0xFF3B4CE8),
      const Color(0xFFF59E0B),
      const Color(0xFF22C55E),
      const Color(0xFFEF4444),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
    ];
    final count = dense ? 60 : 35;

    for (int i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final w = rng.nextDouble() * 8 + 3;
      final h = rng.nextDouble() * 4 + 2;
      final angle = rng.nextDouble() * math.pi;
      final color = colors[rng.nextInt(colors.length)];

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: w, height: h),
          Paint()..color = color.withValues(alpha: 0.7));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
