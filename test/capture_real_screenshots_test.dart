import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sociallearnapp/core/theme/app_theme.dart';
import 'package:sociallearnapp/core/theme/theme_provider.dart';
import 'package:sociallearnapp/features/auth/screens/login_screen.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/courses/providers/course_provider.dart';
import 'package:sociallearnapp/features/courses/screens/courses_screen.dart';
import 'package:sociallearnapp/features/courses/screens/smart_study_plan_screen.dart';
import 'package:sociallearnapp/features/courses/screens/subject_topics_screen.dart';
import 'package:sociallearnapp/features/courses/screens/test_result_screen.dart';
import 'package:sociallearnapp/features/courses/screens/test_solving_screen.dart';
import 'package:sociallearnapp/features/home/screens/home_screen.dart';
import 'package:sociallearnapp/features/onboarding/screens/onboarding_screen.dart';
import 'package:sociallearnapp/features/progress/services/progress_storage_service.dart';
import 'package:sociallearnapp/features/stats/screens/stats_screen.dart';
import 'package:sociallearnapp/features/welcome/screens/welcome_screen.dart';

Future<void> saveScreenshot(WidgetTester tester, GlobalKey key, String filename) async {
  final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 2.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();
  
  final dir = Directory('report_figures');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  final file = File('report_figures/$filename');
  file.writeAsBytesSync(bytes);
  debugPrint('Saved real screenshot: report_figures/$filename (${bytes.length} bytes)');
}

Widget buildTestableApp({required Widget child, required GlobalKey repaintKey, bool isDark = true}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => CourseProvider()),
      ChangeNotifierProvider(create: (_) => ProgressProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: RepaintBoundary(
        key: repaintKey,
        child: SizedBox(
          width: 390,
          height: 844,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Capture real WelcomeScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const WelcomeScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_welcome_screen.png');
  });

  testWidgets('Capture real OnboardingScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const OnboardingScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_onboarding_screen.png');
  });

  testWidgets('Capture real LoginScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const LoginScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_login_screen.png');
  });

  testWidgets('Capture real HomeScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const HomeScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_home_screen.png');
  });

  testWidgets('Capture real CoursesScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const CoursesScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_courses_screen.png');
  });

  testWidgets('Capture real SubjectTopicsScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const SubjectTopicsScreen(subjectName: 'Mathematics'), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_subject_topics_screen.png');
  });

  testWidgets('Capture real TestSolvingScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const TestSolvingScreen(topicTitle: 'Linear Equations'), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_test_solving_screen.png');
  });

  testWidgets('Capture real TestResultScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const TestResultScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_test_result_screen.png');
  });

  testWidgets('Capture real SmartStudyPlanScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const SmartStudyPlanScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_smart_study_plan_screen.png');
  });

  testWidgets('Capture real StatsScreen screenshot', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final key = GlobalKey();
    await tester.pumpWidget(buildTestableApp(child: const StatsScreen(), repaintKey: key));
    await tester.pump(const Duration(milliseconds: 300));
    await saveScreenshot(tester, key, 'real_stats_screen.png');
  });
}
