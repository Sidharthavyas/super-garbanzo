cd ~/AeroLabs-ASSIGNMENT/linkdin-scraper
nano README.md
Paste this:

Markdown

# 🔍 LinkedIn Profile Scraper - Assignment 1

Automated web scraper that extracts professional profile information from LinkedIn using Selenium WebDriver and exports data to structured CSV format.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Output Format](#output-format)
- [Challenges & Solutions](#challenges--solutions)
- [Ethical Considerations](#ethical-considerations)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This Python-based web scraper automates the extraction of LinkedIn profile data for educational and assessment purposes. It uses Selenium for browser automation and handles dynamic JavaScript-rendered content.

**Assignment Goal:** Scrape 20+ LinkedIn profiles and export data to CSV format.

**Key Challenge:** LinkedIn's anti-bot measures and login requirements.

---

## ✨ Features

| Feature | Description | Status |
|---------|-------------|--------|
| 🔐 **Authentication** | Handles LinkedIn login with test account | ✅ Working |
| 📊 **Data Extraction** | Name, headline, location, experience, education, skills | ✅ Working |
| 📁 **CSV Export** | Structured data export using pandas | ✅ Working |
| 🔄 **Error Handling** | Retry logic and graceful error management | ✅ Working |
| ⏱️ **Rate Limiting** | Respects LinkedIn's rate limits with configurable delays | ✅ Working |
| 🎭 **Headless Mode** | Optional background execution | ✅ Working |
| 📝 **Logging** | Detailed execution logs for debugging | ✅ Working |

---

## 🛠️ Technology Stack

### Dependencies

```python
selenium==4.15.2          # Browser automation
webdriver-manager==4.0.1  # Automatic ChromeDriver management
pandas==2.1.3             # Data manipulation and CSV export
python-dotenv==1.0.0      # Environment variable management
Requirements
Python: 3.8 or higher
Chrome Browser: Latest version
ChromeDriver: Auto-managed by webdriver-manager
LinkedIn Account: Test/dummy account recommended
📋 Prerequisites
1. Python Installation
Bash

# Check Python version (must be 3.8+)
python3 --version

# If not installed (Ubuntu/WSL):
sudo apt update
sudo apt install python3 python3-pip
2. Chrome Browser
Bash

# Ubuntu/WSL
sudo apt install chromium-browser

# Or download from: https://www.google.com/chrome/
3. LinkedIn Test Account
⚠️ Important: Create a separate test account for scraping

Don't use your personal LinkedIn account
Use a disposable email
Complete basic profile setup
🚀 Installation
Step 1: Navigate to Project
Bash

cd linkdin-scraper
Step 2: Install Dependencies
Bash

# Install all required packages
pip install -r requirements.txt

# Or install individually:
pip install selenium==4.15.2
pip install webdriver-manager==4.0.1
pip install pandas==2.1.3
pip install python-dotenv==1.0.0
Step 3: Verify Installation
Bash

# Check if packages are installed
pip list | grep selenium
pip list | grep pandas
⚙️ Configuration
Create Configuration File
Bash

nano config.py
Add your settings:

Python

# LinkedIn Credentials (use test account)
LINKEDIN_EMAIL = "your_test_email@example.com"
LINKEDIN_PASSWORD = "your_test_password"

# Profile URLs to scrape (add 20+ URLs)
PROFILE_URLS = [
    "https://www.linkedin.com/in/username1/",
    "https://www.linkedin.com/in/username2/",
    "https://www.linkedin.com/in/username3/",
    # Add 17 more URLs...
]

# Scraper Settings
HEADLESS_MODE = False          # Set True for background execution
DELAY_BETWEEN_REQUESTS = 3     # Seconds (respect rate limits)
MAX_RETRIES = 3                # Retry attempts for failed requests
OUTPUT_FILE = "profiles.csv"   # Output filename
Environment Variables (Alternative)
Create .env file:

env

LINKEDIN_EMAIL=test@example.com
LINKEDIN_PASSWORD=testpassword123
HEADLESS_MODE=False
DELAY=3
💻 Usage
Basic Usage
Bash

# Run the scraper
python scraper.py
Expected Output:

text

Starting LinkedIn Profile Scraper...
Logging in to LinkedIn...
✓ Login successful

Scraping profiles...
[1/20] Scraping: https://linkedin.com/in/johndoe
  ✓ Name: John Doe
  ✓ Headline: Software Engineer at Google
  ✓ Location: San Francisco, CA
[2/20] Scraping: https://linkedin.com/in/janedoe
  ✓ Name: Jane Doe
  ...

Scraping completed!
✓ Successfully scraped: 