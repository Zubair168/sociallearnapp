import os
import sys
from PIL import Image, ImageDraw, ImageFont
import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

# Ensure output directory for figures
IMG_DIR = os.path.join(os.getcwd(), 'report_figures')
os.makedirs(IMG_DIR, exist_ok=True)

def create_ui_mockup(title, subtitle, badge_text, items, bg_color, card_color, accent_color, filename):
    width, height = 750, 480
    img = Image.new('RGB', (width, height), color=bg_color)
    draw = ImageDraw.Draw(img)
    
    # Try default font or basic drawing
    try:
        font_large = ImageFont.truetype("arial.ttf", 26)
        font_med = ImageFont.truetype("arial.ttf", 18)
        font_small = ImageFont.truetype("arial.ttf", 14)
        font_bold = ImageFont.truetype("arialbd.ttf", 20)
    except:
        font_large = ImageFont.load_default()
        font_med = ImageFont.load_default()
        font_small = ImageFont.load_default()
        font_bold = ImageFont.load_default()
        
    # Draw Phone Container / Glass Frame
    draw.rounded_rectangle([30, 25, width-30, height-25], radius=20, fill=card_color, outline=(71, 85, 105), width=2)
    
    # Top App Bar
    draw.rounded_rectangle([45, 40, width-45, 100], radius=12, fill=(30, 41, 59), outline=accent_color, width=2)
    draw.text((65, 52), title, fill=(255, 255, 255), font=font_large)
    draw.text((65, 80), subtitle, fill=(148, 163, 184), font=font_small)
    
    # Status Badge
    draw.rounded_rectangle([width-180, 52, width-60, 85], radius=15, fill=accent_color)
    draw.text((width-170, 58), badge_text, fill=(255, 255, 255), font=font_small)
    
    # Content Items / Cards
    y = 120
    for idx, item in enumerate(items):
        icon_num = f"{idx+1}"
        draw.rounded_rectangle([55, y, width-55, y+65], radius=12, fill=(30, 41, 59), outline=(51, 65, 85), width=1)
        
        # Circle badge for number
        draw.ellipse([70, y+15, 105, y+50], fill=accent_color)
        draw.text((82, y+22), icon_num, fill=(255, 255, 255), font=font_bold)
        
        # Item Text
        header, desc = item
        draw.text((120, y+14), header, fill=(248, 250, 252), font=font_bold)
        draw.text((120, y+38), desc, fill=(148, 163, 184), font=font_small)
        
        # Checkmark/Status tag on right
        draw.rounded_rectangle([width-150, y+20, width-70, y+48], radius=8, fill=(15, 23, 42), outline=accent_color, width=1)
        draw.text((width-140, y+25), "✓ Active", fill=accent_color, font=font_small)
        
        y += 78
        
    img_path = os.path.join(IMG_DIR, filename)
    img.save(img_path)
    return img_path

def create_cicd_diagram(filename):
    width, height = 800, 360
    img = Image.new('RGB', (width, height), color=(15, 23, 42))
    draw = ImageDraw.Draw(img)
    
    try:
        font_large = ImageFont.truetype("arialbd.ttf", 22)
        font_med = ImageFont.truetype("arialbd.ttf", 16)
        font_small = ImageFont.truetype("arial.ttf", 13)
    except:
        font_large = ImageFont.load_default()
        font_med = ImageFont.load_default()
        font_small = ImageFont.load_default()
        
    draw.text((40, 25), "GitHub Actions CI/CD Quality & Release Pipeline", fill=(255, 255, 255), font=font_large)
    draw.text((40, 55), "Automated Code Analysis -> Test Coverage -> Release APK Compilation", fill=(148, 163, 184), font=font_small)
    
    stages = [
        ("1. Git Trigger", "Push to main / Tag v*", (59, 130, 246)),
        ("2. Environment", "Java 17 + Flutter Stable", (16, 185, 129)),
        ("3. Static Analysis", "flutter analyze (0 errors)", (139, 92, 246)),
        ("4. Automated Tests", "15/15 Tests + Coverage", (236, 72, 153)),
        ("5. Release Build", "app-release.apk (66.5 MB)", (245, 158, 11))
    ]
    
    box_w = 130
    box_h = 180
    start_x = 35
    y = 110
    
    for i, (title, desc, color) in enumerate(stages):
        bx = start_x + i * 150
        # Draw Card
        draw.rounded_rectangle([bx, y, bx + box_w, y + box_h], radius=12, fill=(30, 41, 59), outline=color, width=2)
        # Header bar
        draw.rounded_rectangle([bx, y, bx + box_w, y + 45], radius=10, fill=color)
        draw.text((bx + 10, y + 12), title, fill=(255, 255, 255), font=font_med)
        
        # Body
        draw.text((bx + 10, y + 65), desc, fill=(226, 232, 240), font=font_small)
        
        # Status Pill
        draw.rounded_rectangle([bx + 15, y + box_h - 40, bx + box_w - 15, y + box_h - 15], radius=8, fill=(15, 23, 42), outline=color)
        draw.text((bx + 28, y + box_h - 35), "PASSED", fill=color, font=font_small)
        
        # Arrow to next stage
        if i < len(stages) - 1:
            arrow_x = bx + box_w + 5
            arrow_y = y + box_h // 2
            draw.line([(arrow_x, arrow_y), (arrow_x + 12, arrow_y)], fill=(148, 163, 184), width=3)
            draw.polygon([(arrow_x + 12, arrow_y - 5), (arrow_x + 18, arrow_y), (arrow_x + 12, arrow_y + 5)], fill=(148, 163, 184))
            
    img_path = os.path.join(IMG_DIR, filename)
    img.save(img_path)
    return img_path

# Generate visual mockups
fig1 = create_ui_mockup(
    "EduVerse Onboarding & Persona Setup",
    "Tailored journeys for Students, Teachers, and Parents",
    "Step 1: Role Gate",
    [
        ("Student Learning Track", "Personalized exam prep, smart study task syncing & topic mastery"),
        ("Teacher & Mentor Hub", "Course curation, assignment tracking, and student performance insights"),
        ("Parent Oversight Portal", "Weekly study streak overview, time management, and milestone alerts")
    ],
    (15, 23, 42), (30, 41, 59), (59, 130, 246), "fig1_onboarding.png"
)

fig2 = create_ui_mockup(
    "Course Catalog & 1-Tap Enrollment",
    "Categorized syllabus (TYT & AYT) with real-time syncing",
    "Step 2: Learn Hub",
    [
        ("Mathematics Mastery", "Calculus, Trigonometry & Algebra — 24 Lessons & 12 Practice Quizzes"),
        ("Physics & Chemistry Labs", "Interactive video experiments, formula sheets, and mock exams"),
        ("Dynamic Progress Sync", "Instant enrollment adds subject to Smart Study Planner & Home Dashboard")
    ],
    (15, 23, 42), (30, 41, 59), (16, 185, 129), "fig2_courses.png"
)

fig3 = create_ui_mockup(
    "Active Learning, Video & Quiz Engine",
    "Integrated video player, timed assessments & bookmark vault",
    "Step 3: Practice",
    [
        ("Interactive Video Player", "Scrubbing, 0.75x-2x playback speeds, and timestamped lesson notes"),
        ("Timed Quiz Solving Screen", "Real-time clock, instant explanations, shuffling, and streak bonuses"),
        ("Favorited Questions Vault", "Star tough questions during tests to review in a dedicated revision deck")
    ],
    (15, 23, 42), (30, 41, 59), (236, 72, 153), "fig3_learning.png"
)

fig4 = create_ui_mockup(
    "Smart Study Plan & Gamified Analytics",
    "Bidirectional task sync across screens + performance report",
    "Step 4: Mastery",
    [
        ("Unified Study Task Sync", "Checking tasks on Home or Smart Planner updates persistent state instantly"),
        ("Celebration Result Screen", "Dynamic grade calculation, full-width confetti celebration & review"),
        ("Topic Analysis & Radar Charts", "Accurate weakness detection and subject readiness benchmarks")
    ],
    (15, 23, 42), (30, 41, 59), (245, 158, 11), "fig4_progress.png"
)

fig5 = create_cicd_diagram("fig5_cicd_pipeline.png")

print("Generated all 5 figures successfully.")
