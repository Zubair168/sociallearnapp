import os
import subprocess

ADB = r"C:\Users\Rana\AppData\Local\Android\sdk\platform-tools\adb.exe"
OUT_DIR = os.path.join(os.getcwd(), "report_figures")
os.makedirs(OUT_DIR, exist_ok=True)

def capture_screencap(filename):
    filepath = os.path.join(OUT_DIR, filename)
    result = subprocess.run([ADB, "exec-out", "screencap", "-p"], stdout=subprocess.PIPE)
    with open(filepath, "wb") as f:
        f.write(result.stdout)
    print(f"Captured {filename} ({len(result.stdout)} bytes)")
    return filepath

if __name__ == '__main__':
    capture_screencap("real_screen_1.png")
