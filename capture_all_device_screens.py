import os
import time
import subprocess
from PIL import Image

ADB = r"C:\Users\Rana\AppData\Local\Android\sdk\platform-tools\adb.exe"
OUT_DIR = os.path.join(os.getcwd(), "report_figures")
os.makedirs(OUT_DIR, exist_ok=True)

def run_adb(args):
    return subprocess.run([ADB] + args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def capture_screen(name):
    path = os.path.join(OUT_DIR, name)
    res = run_adb(["exec-out", "screencap", "-p"])
    with open(path, "wb") as f:
        f.write(res.stdout)
    print(f"Captured real device screenshot: {name} ({len(res.stdout)} bytes)")
    return path

def tap(x, y):
    run_adb(["shell", "input", "tap", str(x), str(y)])
    time.sleep(1.2)

def keyevent(key_code):
    run_adb(["shell", "input", "keyevent", str(key_code)])
    time.sleep(1.2)

# 1. Capture current active screen (Drawing / Test Solving)
capture_screen("real_app_test_solving.png")

# Tap outside scrim to dismiss dialog if open (e.g. at 540, 500)
tap(540, 500)
capture_screen("real_app_test_screen.png")

# Tap back button (top-left usually around 80, 150 or Android KEYCODE_BACK = 4)
keyevent(4)
capture_screen("real_app_subject_topics.png")

# Tap back again to reach Courses / Home
keyevent(4)
capture_screen("real_app_courses.png")

# Tap Home icon on bottom bar (around 150, 2250)
tap(150, 2250)
capture_screen("real_app_home_dashboard.png")

# Tap Study Plan tab on bottom bar (around 400, 2250)
tap(390, 2250)
capture_screen("real_app_smart_study_plan.png")

# Tap Stats tab on bottom bar (around 680, 2250)
tap(680, 2250)
capture_screen("real_app_stats_screen.png")

# Tap Profile tab on bottom bar (around 930, 2250)
tap(930, 2250)
capture_screen("real_app_profile_screen.png")

print("All real device screenshots captured.")
