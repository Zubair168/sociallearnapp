import 'package:flutter/material.dart';
import 'package:sociallearnapp/features/courses/screens/test_result_screen.dart';

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<List<DrawingPoint>> lines;
  DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i].offset, line[i + 1].offset, line[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TestSolvingScreen extends StatefulWidget {
  final String topicTitle;
  const TestSolvingScreen({super.key, required this.topicTitle});

  @override
  State<TestSolvingScreen> createState() => _TestSolvingScreenState();
}

class _TestSolvingScreenState extends State<TestSolvingScreen> {
  int _currentQuestionIndex = 0;
  final int _totalQuestions = 6;
  String? _selectedOption; // 'A', 'B', 'C', 'D', 'E'
  bool _isFavorite = false;

  // Drawing Canvas State
  bool _isDrawingMode = true;
  bool _isEraser = false;
  Color _selectedColor = const Color(0xFFEF4444); // Default Red
  double _strokeWidth = 3.0;
  final List<List<DrawingPoint>> _lines = [];
  final List<List<DrawingPoint>> _redoLines = [];

  // Speed Dial Menu State
  bool _isSpeedDialOpen = false;

  final List<Color> _palette = [
    const Color(0xFFEF4444), // Red
    const Color(0xFFF97316), // Orange
    const Color(0xFF22C55E), // Green
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFF64748B), // Grey
    const Color(0xFF0F172A), // Black
  ];

  final List<double> _strokeSizes = [2.0, 3.5, 5.0, 7.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── 1. Top Bar / Drawing Toolbar ─────────────────────────────
                _buildTopToolbar(),

                const Divider(height: 1, color: Color(0xFFF1F5F9)),

                // ── 2. Question View Area with Drawing Canvas ────────────────
                Expanded(
                  child: Stack(
                    children: [
                      // Question Text & Content
                      Positioned.fill(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bir doğal sayının faktöriyeli şeklinde yazılabilen sayılara "Wilson Sayıları" denir.',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'Poppins',
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Örnek, 6 = 1 • 2 • 3 = 3! olduğundan 6 sayısı bir Wilson sayısıdır.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF334155),
                                  fontFamily: 'Poppins',
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Buna göre,\n  I.  2\n II.  4\nIII.  120\nsayılarından hangileri bir Wilson sayısıdır?',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'Poppins',
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'A) Yalnız I        B) Yalnız II        C) I ve II\n         D) I ve III            E) II ve III',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF475569),
                                  fontFamily: 'Poppins',
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Interactive Drawing Canvas Overlay
                      if (_isDrawingMode)
                        Positioned.fill(
                          child: GestureDetector(
                            onPanStart: (details) {
                              final localPos = details.localPosition;
                              setState(() {
                                _lines.add([
                                  DrawingPoint(
                                    offset: localPos,
                                    paint: Paint()
                                      ..color = _isEraser ? Colors.white : _selectedColor
                                      ..isAntiAlias = true
                                      ..strokeWidth = _isEraser ? 16.0 : _strokeWidth
                                      ..strokeCap = StrokeCap.round
                                      ..blendMode = _isEraser ? BlendMode.clear : BlendMode.srcOver,
                                  ),
                                ]);
                                _redoLines.clear();
                              });
                            },
                            onPanUpdate: (details) {
                              final localPos = details.localPosition;
                              setState(() {
                                if (_lines.isNotEmpty) {
                                  _lines.last.add(
                                    DrawingPoint(
                                      offset: localPos,
                                      paint: Paint()
                                        ..color = _isEraser ? Colors.white : _selectedColor
                                        ..isAntiAlias = true
                                        ..strokeWidth = _isEraser ? 16.0 : _strokeWidth
                                        ..strokeCap = StrokeCap.round
                                        ..blendMode = _isEraser ? BlendMode.clear : BlendMode.srcOver,
                                    ),
                                  );
                                }
                              });
                            },
                            child: CustomPaint(
                              painter: DrawingPainter(lines: _lines),
                              size: Size.infinite,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── 3. Option Selector Row (A, B, C, D, E) ────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['A', 'B', 'C', 'D', 'E'].map((opt) {
                      final isSel = _selectedOption == opt;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedOption = opt),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFEEF2FF) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0),
                              width: isSel ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFF64748B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // ── 4. Bottom Navigation Bar with Speed Dial ──────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                  ),
                  child: Row(
                    children: [
                      // Prev Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _currentQuestionIndex > 0
                              ? () => setState(() => _currentQuestionIndex--)
                              : null,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 46),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, size: 24, color: Color(0xFF2A3BD4)),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Next Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentQuestionIndex < _totalQuestions - 1) {
                              setState(() {
                                _currentQuestionIndex++;
                                _selectedOption = null;
                                _lines.clear();
                              });
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TestResultScreen(
                                    testTitle: widget.topicTitle,
                                    totalQuestions: _totalQuestions,
                                    correct: 5,
                                    incorrect: 1,
                                    unanswered: 0,
                                    netScore: 4.75,
                                    avgScore: 4.20,
                                    timeTakenSeconds: 340,
                                    avgTimeSeconds: 420,
                                    currentNet: 1513.25,
                                    rankChange: 10,
                                    currentRank: 23,
                                    promoted: true,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A3BD4),
                            minimumSize: const Size(0, 46),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Icon(Icons.chevron_right_rounded, size: 24, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 3-dot / Speed Dial Button
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1E293B), size: 20),
                          onPressed: () => setState(() => _isSpeedDialOpen = !_isSpeedDialOpen),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Speed Dial Overlay Menu (Screenshot 10) ──────────────────────
            if (_isSpeedDialOpen) _buildSpeedDialMenu(),
          ],
        ),
      ),
    );
  }

  // ─── Top Drawing & Control Toolbar (Screenshot 9) ──────────────────────────
  Widget _buildTopToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Pen Tool
              IconButton(
                icon: Icon(Icons.edit_outlined, color: (!_isEraser && _isDrawingMode) ? const Color(0xFF2A3BD4) : const Color(0xFF64748B), size: 20),
                onPressed: () => setState(() {
                  _isDrawingMode = true;
                  _isEraser = false;
                }),
              ),
              // Hand / Pan Tool
              IconButton(
                icon: Icon(Icons.pan_tool_outlined, color: !_isDrawingMode ? const Color(0xFF2A3BD4) : const Color(0xFF64748B), size: 20),
                onPressed: () => setState(() => _isDrawingMode = false),
              ),
              // Eraser Tool
              IconButton(
                icon: Icon(Icons.auto_fix_normal_outlined, color: _isEraser ? const Color(0xFF2A3BD4) : const Color(0xFF64748B), size: 20),
                onPressed: () => setState(() {
                  _isDrawingMode = true;
                  _isEraser = true;
                }),
              ),
              // Color Palette Circle
              GestureDetector(
                onTap: _showPaletteSheet,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                  ),
                ),
              ),
              // Undo
              IconButton(
                icon: const Icon(Icons.undo_rounded, size: 20, color: Color(0xFF64748B)),
                onPressed: _lines.isNotEmpty
                    ? () {
                        setState(() {
                          _redoLines.add(_lines.removeLast());
                        });
                      }
                    : null,
              ),
              // Redo
              IconButton(
                icon: const Icon(Icons.redo_rounded, size: 20, color: Color(0xFF64748B)),
                onPressed: _redoLines.isNotEmpty
                    ? () {
                        setState(() {
                          _lines.add(_redoLines.removeLast());
                        });
                      }
                    : null,
              ),
              // Clear / Trash
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFEF4444)),
                onPressed: () => setState(() {
                  _lines.clear();
                  _redoLines.clear();
                }),
              ),
            ],
          ),

          // Question number & timer row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentQuestionIndex + 1}/$_totalQuestions',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins'),
                ),
                const Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF64748B)),
                    SizedBox(width: 4),
                    Text(
                      '00:31',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaletteSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setPaletteState) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Pen Color & Stroke', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
              const SizedBox(height: 14),
              // Colors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _palette.map((c) {
                  final isSel = _selectedColor == c;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedColor = c);
                      setPaletteState(() {});
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSel ? const Color(0xFF2A3BD4) : Colors.transparent, width: 3),
                      ),
                      child: isSel ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              // Stroke sizes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _strokeSizes.map((sz) {
                  final isSel = _strokeWidth == sz;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _strokeWidth = sz);
                      setPaletteState(() {});
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFEEF2FF) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: sz * 2.5,
                        height: sz * 2.5,
                        decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Speed Dial Menu (Screenshot 10) ───────────────────────────────────────
  Widget _buildSpeedDialMenu() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _isSpeedDialOpen = false),
        child: Container(
          color: Colors.black.withValues(alpha: 0.35),
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.only(right: 20, bottom: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 1. Solution / Check
              _buildSpeedDialItem(
                label: 'Solution',
                icon: Icons.check_circle_outline_rounded,
                color: const Color(0xFF2A3BD4),
                onTap: () {
                  setState(() => _isSpeedDialOpen = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Viewing solution!'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
              const SizedBox(height: 12),

              // 2. Favorite Star
              _buildSpeedDialItem(
                label: 'Favorite',
                icon: _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: const Color(0xFFFBBF24),
                onTap: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                    _isSpeedDialOpen = false;
                  });
                },
              ),
              const SizedBox(height: 12),

              // 3. Finish Test
              _buildSpeedDialItem(
                label: 'Finish Test',
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444),
                onTap: () {
                  setState(() => _isSpeedDialOpen = false);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),

              // 4. Question List
              _buildSpeedDialItem(
                label: 'Question List',
                icon: Icons.format_list_bulleted_rounded,
                color: const Color(0xFF0284C7),
                onTap: () {
                  setState(() => _isSpeedDialOpen = false);
                  _showQuestionListGrid();
                },
              ),
              const SizedBox(height: 12),

              // 5. Report Error
              _buildSpeedDialItem(
                label: 'Report Error',
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFF97316),
                onTap: () {
                  setState(() => _isSpeedDialOpen = false);
                  _showReportErrorDialog();
                },
              ),
              const SizedBox(height: 12),

              // 6. Add Note
              _buildSpeedDialItem(
                label: 'Add Note',
                icon: Icons.note_add_outlined,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  setState(() => _isSpeedDialOpen = false);
                  _showAddNoteModal();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedDialItem({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins'),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ],
      ),
    );
  }

  void _showQuestionListGrid() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Question Navigator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(_totalQuestions, (i) {
                final isCurrent = _currentQuestionIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() => _currentQuestionIndex = i);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isCurrent ? const Color(0xFF2A3BD4) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isCurrent ? Colors.white : const Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportErrorDialog() {
    final issueCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Report an error', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
              const SizedBox(height: 4),
              Text('Describe the error that you are facing. Please be as specific as possible', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'Poppins')),
              const SizedBox(height: 14),
              TextField(
                controller: issueCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe your issue...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.attach_file_rounded, size: 16, color: Color(0xFF64748B)),
                label: const Text('Attach a file', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 38)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error reported. Thank you!'), behavior: SnackBarBehavior.floating));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4)),
                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
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

  void _showAddNoteModal() {
    final noteCtrl = TextEditingController(
      text: '• Break the problem into smaller steps.\n• Check the keywords to understand what is being asked.\n• Check for negative signs in calculations.\n• Ask this to the teacher.',
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).padding.bottom + 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            const Text('Note', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
            const SizedBox(height: 4),
            Text('Last Updated: 13 Jan 2024', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade400, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                fillColor: const Color(0xFFF8FAFC),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note saved!'), behavior: SnackBarBehavior.floating));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A3BD4),
                      minimumSize: const Size(0, 44),
                      elevation: 0,
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


