import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
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
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF2A3BD4), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('View Answers',
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
    return Stack(
      children: [
        // Confetti background
        Container(
          height: 280,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF8F0), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: CustomPaint(
            painter: _ConfettiPainter(),
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
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(width: 12),
                    const Text('Test Result',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Poppins')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Celebration icon
              Container(
                width: 80,
                height: 80,
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
                    size: 40, color: Color(0xFF2A3BD4)),
              ).animate().scale(
                  duration: 500.ms, curve: Curves.elasticOut),

              const SizedBox(height: 14),

              const Text('You have completed the test for',
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontFamily: 'Poppins')),
              const SizedBox(height: 4),
              Text(widget.testTitle,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins')),
              const SizedBox(height: 4),
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
    final positive = widget.rankChange > 0;

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
    return Container(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.home_rounded,
                  color: Color(0xFF64748B), size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: Color(0xFF2A3BD4), width: 1.5),
              ),
              child: const Text('Switch Difficulty',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A3BD4),
                      fontFamily: 'Poppins')),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A3BD4),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Next Test',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins')),
            ),
          ),
        ],
      ),
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
