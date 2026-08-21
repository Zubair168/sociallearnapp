import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sociallearnapp/features/video/screens/video_player_screen.dart';

enum QuestionStatus { correct, incorrect, unanswered }

class FavoritedQuestion {
  final String id;
  final String dateGroup; // 'Today', 'Yesterday', etc.
  final QuestionStatus status;
  final String questionIntro;
  final String exampleText;
  final List<String> romanNumerals;
  final String questionPrompt;
  final List<String> options;
  final String correctOption; // 'B'
  final String topic;
  final String subject;
  final String examType; // 'TYT', 'AYT'
  final String time;
  String? note;
  bool isFavorited;

  FavoritedQuestion({
    required this.id,
    required this.dateGroup,
    required this.status,
    required this.questionIntro,
    required this.exampleText,
    required this.romanNumerals,
    required this.questionPrompt,
    required this.options,
    required this.correctOption,
    required this.topic,
    required this.subject,
    required this.examType,
    required this.time,
    this.note,
    this.isFavorited = true,
  });
}

class FavoritedQuestionsScreen extends StatefulWidget {
  const FavoritedQuestionsScreen({super.key});

  @override
  State<FavoritedQuestionsScreen> createState() =>
      _FavoritedQuestionsScreenState();
}

class _FavoritedQuestionsScreenState extends State<FavoritedQuestionsScreen> {
  String _selectedFilterSubject = 'All';
  String _selectedFilterStatus = 'All';

  late List<FavoritedQuestion> _allQuestions;

  @override
  void initState() {
    super.initState();
    _allQuestions = [
      FavoritedQuestion(
        id: '1',
        dateGroup: 'Today',
        status: QuestionStatus.correct,
        questionIntro:
            'Bir doğal sayının faktöriyeli şeklinde yazılabilen sayılara "Wilson Sayıları" denir.',
        exampleText:
            'Örnek, 6 = 1 • 2 • 3 = 3! olduğundan 6 sayısı bir Wilson sayısıdır.',
        romanNumerals: ['2', '4', '120'],
        questionPrompt: 'sayılarından hangileri bir Wilson sayısıdır?',
        options: [
          'A) Yalnız I',
          'B) Yalnız II',
          'C) I ve II',
          'D) I ve III',
          'E) II ve III',
        ],
        correctOption: 'B',
        topic: 'Linear Equations',
        subject: 'Mathematics',
        examType: 'AYT',
        time: '00:26',
        note: 'Need to confirm this question with the teacher',
      ),
      FavoritedQuestion(
        id: '2',
        dateGroup: 'Yesterday',
        status: QuestionStatus.incorrect,
        questionIntro:
            'Bir doğal sayının faktöriyeli şeklinde yazılabilen sayılara "Wilson Sayıları" denir.',
        exampleText:
            'Örnek, 6 = 1 • 2 • 3 = 3! olduğundan 6 sayısı bir Wilson sayısıdır.',
        romanNumerals: ['2', '4', '120'],
        questionPrompt: 'sayılarından hangileri bir Wilson sayısıdır?',
        options: [
          'A) Yalnız I',
          'B) Yalnız II',
          'C) I ve II',
          'D) I ve III',
          'E) II ve III',
        ],
        correctOption: 'B',
        topic: 'Linear Equations',
        subject: 'Mathematics',
        examType: 'AYT',
        time: '00:26',
        note: null,
      ),
      FavoritedQuestion(
        id: '3',
        dateGroup: 'Yesterday',
        status: QuestionStatus.unanswered,
        questionIntro:
            'Bir doğal sayının faktöriyeli şeklinde yazılabilen sayılara "Wilson Sayıları" denir.',
        exampleText:
            'Örnek, 6 = 1 • 2 • 3 = 3! olduğundan 6 sayısı bir Wilson sayısıdır.',
        romanNumerals: ['2', '4', '120'],
        questionPrompt: 'sayılarından hangileri bir Wilson sayısıdır?',
        options: [
          'A) Yalnız I',
          'B) Yalnız II',
          'C) I ve II',
          'D) I ve III',
          'E) II ve III',
        ],
        correctOption: 'B',
        topic: 'Linear Equations',
        subject: 'Mathematics',
        examType: 'AYT',
        time: '00:26',
        note: null,
      ),
    ];
  }

  List<FavoritedQuestion> get _filteredQuestions {
    return _allQuestions.where((q) {
      if (!q.isFavorited) return false;
      if (_selectedFilterSubject != 'All' &&
          q.subject != _selectedFilterSubject) {
        return false;
      }
      if (_selectedFilterStatus != 'All') {
        if (_selectedFilterStatus == 'Correct' &&
            q.status != QuestionStatus.correct) {
          return false;
        }
        if (_selectedFilterStatus == 'Incorrect' &&
            q.status != QuestionStatus.incorrect) {
          return false;
        }
        if (_selectedFilterStatus == 'Unanswered' &&
            q.status != QuestionStatus.unanswered) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredQuestions;
    final isEmpty = filtered.isEmpty;

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
          'Favorited Questions',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: isEmpty ? _buildEmptyState() : _buildContent(filtered),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dual stacked paper illustration with sparkle
            Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F5F9),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back document
                  Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      width: 58,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 36,
                              height: 3.5,
                              color: Colors.white.withValues(alpha: 0.8)),
                          const SizedBox(height: 6),
                          Container(
                              width: 28,
                              height: 3.5,
                              color: Colors.white.withValues(alpha: 0.8)),
                        ],
                      ),
                    ),
                  ),
                  // Front document
                  Transform.rotate(
                    angle: 0.08,
                    child: Container(
                      width: 62,
                      height: 78,
                      decoration: BoxDecoration(
                        color: const Color(0xFF94A3B8),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 40, height: 4, color: Colors.white),
                          const SizedBox(height: 6),
                          Container(
                              width: 32, height: 4, color: Colors.white),
                          const SizedBox(height: 6),
                          Container(
                              width: 24, height: 4, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOut),

            const SizedBox(height: 28),

            const Text(
              'No Questions Found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "We didn't find any questions favorited by you.\nTry favoriting some questions.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Main Content ─────────────────────────────────────────────────────────
  Widget _buildContent(List<FavoritedQuestion> questions) {
    // Group questions by dateGroup
    final Map<String, List<FavoritedQuestion>> grouped = {};
    for (final q in questions) {
      grouped.putIfAbsent(q.dateGroup, () => []).add(q);
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      children: [
        // ── Subheader ───────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${questions.length} Questions',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Click on the question to view its solution',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            // Filter Button
            GestureDetector(
              onTap: _showFilterSheet,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (_selectedFilterSubject != 'All' ||
                            _selectedFilterStatus != 'All')
                        ? const Color(0xFF2A3BD4)
                        : const Color(0xFF2A3BD4),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF2A3BD4),
                  size: 20,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ── Date Groups ─────────────────────────────────────────────────────
        ...grouped.entries.map((entry) {
          final date = entry.key;
          final dateQuestions = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 4),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              ...dateQuestions.map((q) => _buildQuestionCard(q)),
            ],
          );
        }),
      ],
    );
  }

  // ─── Question Card ────────────────────────────────────────────────────────
  Widget _buildQuestionCard(FavoritedQuestion q) {
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
          onTap: () => _showSolutionBottomSheet(q),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Status & Star
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusChip(q.status),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          q.isFavorited = !q.isFavorited;
                        });
                      },
                      child: Icon(
                        q.isFavorited
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: q.isFavorited
                            ? const Color(0xFFF59E0B)
                            : Colors.grey.shade400,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Question Text Content
                _buildQuestionBodyContent(q),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Meta Row: Topic, Subject, Exam Type
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 14,
                      color: Color(0xFF2A3BD4),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      q.topic,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 1,
                      height: 12,
                      color: const Color(0xFFCBD5E1),
                    ),
                    Text(
                      q.subject,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDE5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        q.examType,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF6B35),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Time Row
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      q.time,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Note Row / Button
                if (q.note != null && q.note!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 14,
                          color: Color(0xFF2A3BD4),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            q.note!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showAddEditNoteDialog(q),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _showAddEditNoteDialog(q),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 14,
                          color: Color(0xFF2A3BD4),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Add new note',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2A3BD4),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Status Chip ──────────────────────────────────────────────────────────
  Widget _buildStatusChip(QuestionStatus status) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case QuestionStatus.correct:
        bg = const Color(0xFFE8F8EE);
        fg = const Color(0xFF16A34A);
        label = 'Correct';
        icon = Icons.check_rounded;
        break;
      case QuestionStatus.incorrect:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        label = 'Incorrect';
        icon = Icons.close_rounded;
        break;
      case QuestionStatus.unanswered:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        label = 'Unanswered';
        icon = Icons.info_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ─── Question Body Text ───────────────────────────────────────────────────
  Widget _buildQuestionBodyContent(FavoritedQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Intro sentence
        Text(
          q.questionIntro,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
            height: 1.4,
          ),
        ),
        const SizedBox(height: 6),

        // Example sentence
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1E293B),
              fontFamily: 'Poppins',
              height: 1.4,
            ),
            children: [
              const TextSpan(
                text: 'Örnek, ',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: q.exampleText.replaceFirst('Örnek, ', ''),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Buna göre,
        const Text(
          'Buna göre,',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),

        const SizedBox(height: 2),

        // Roman numerals
        ...List.generate(q.romanNumerals.length, (i) {
          final roman = ['I', 'II', 'III', 'IV', 'V'][i % 5];
          return Padding(
            padding: const EdgeInsets.only(left: 12, top: 1),
            child: Text(
              '$roman. ${q.romanNumerals[i]}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
          );
        }),

        const SizedBox(height: 6),

        // Prompt
        Text(
          q.questionPrompt,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),

        const SizedBox(height: 8),

        // Multiple choice options grid
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: q.options.map((opt) {
            return Text(
              opt,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Solution Bottom Sheet Modal ──────────────────────────────────────────
  void _showSolutionBottomSheet(FavoritedQuestion q) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Dark Close Button (as shown in design)
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // White Modal Content Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Question text in modal
                    _buildQuestionBodyContent(q),

                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 14),

                    // Correct Answer Label
                    const Text(
                      'Correct Answer',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Options circles (A, B, C, D, E)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['A', 'B', 'C', 'D', 'E'].map((letter) {
                        final isCorrect = letter == q.correctOption;

                        return Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCorrect
                                ? const Color(0xFFE8F8EE)
                                : Colors.white,
                            border: Border.all(
                              color: isCorrect
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFCBD5E1),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isCorrect
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF1E293B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Solution Action Buttons Row
                    Row(
                      children: [
                        // Visual Solution Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              _showVisualSolutionDialog(q);
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2A3BD4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.description_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Visual Solution',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Vertical Separator
                        Container(
                          width: 1,
                          height: 50,
                          color: const Color(0xFFF1F5F9),
                        ),

                        // Video Solution Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const VideoPlayerScreen(
                                    title: 'Wilson Sayıları Çözümü',
                                    videoUrl:
                                        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2A3BD4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.videocam_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Video Solution',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Visual Solution Dialog ───────────────────────────────────────────────
  void _showVisualSolutionDialog(FavoritedQuestion q) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Visual Solution',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close_rounded,
                        color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  '1) Wilson sayısı kuralı: n! şeklinde yazılabilen sayılardır.\n\n'
                  '2) İnceleyelim:\n'
                  '   • I. 2 = 2! (Wilson sayısı)\n'
                  '   • II. 4 = faktöriyel olarak yazılamaz (1!=1, 2!=2, 3!=6)\n'
                  '   • III. 120 = 5! (Wilson sayısı)\n\n'
                  '3) Dolayısıyla sadece II tek başına Wilson sayısı değildir. Doğru Seçenek: B.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A3BD4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Add/Edit Note Dialog ─────────────────────────────────────────────────
  void _showAddEditNoteDialog(FavoritedQuestion q) {
    final textController = TextEditingController(text: q.note ?? '');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q.note != null ? 'Edit Note' : 'Add Note',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 3,
                style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: 'Type your note here...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontFamily: 'Poppins'),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2A3BD4)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          q.note = textController.text.trim().isEmpty
                              ? null
                              : textController.text.trim();
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A3BD4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Filter Sheet ─────────────────────────────────────────────────────────
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const Text(
                  'Filter Questions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 14),

                // Status Filter
                const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['All', 'Correct', 'Incorrect', 'Unanswered']
                      .map((st) {
                    final isSel = _selectedFilterStatus == st;
                    return ChoiceChip(
                      label: Text(st),
                      selected: isSel,
                      selectedColor: const Color(0xFF2A3BD4),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (val) {
                        setSheetState(() => _selectedFilterStatus = st);
                        setState(() => _selectedFilterStatus = st);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),

                // Subject Filter
                const Text(
                  'Subject',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['All', 'Mathematics', 'Turkish', 'Physics']
                      .map((sub) {
                    final isSel = _selectedFilterSubject == sub;
                    return ChoiceChip(
                      label: Text(sub),
                      selected: isSel,
                      selectedColor: const Color(0xFF2A3BD4),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (val) {
                        setSheetState(() => _selectedFilterSubject = sub);
                        setState(() => _selectedFilterSubject = sub);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A3BD4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
