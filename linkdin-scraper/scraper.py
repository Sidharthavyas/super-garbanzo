import time
import csv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from dotenv import load_dotenv
import os
import random

# Load environment variables
load_dotenv()

class LinkedInScraper:
    def __init__(self):
        print("🚀 Initializing LinkedIn Scraper...")
        self.setup_driver()
        self.profile_data = []
        
    def setup_driver(self):
        """Setup Chrome driver with options to avoid detection"""
        print("🔧 Setting up Chrome driver...")
        try:
            chrome_options = Options()
            chrome_options.add_argument('--disable-blink-features=AutomationControlled')
            chrome_options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
            chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"])
            chrome_options.add_experimental_option('useAutomationExtension', False)
            chrome_options.add_argument('--no-sandbox')
            chrome_options.add_argument('--disable-dev-shm-usage')
            # chrome_options.add_argument('--headless')  # Uncomment for headless mode
            
            self.driver = webdriver.Chrome(
                service=Service(ChromeDriverManager().install()),
                options=chrome_options
            )
            self.driver.maximize_window()
            self.driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
            print("✅ Chrome driver initialized successfully")
            
        except Exception as e:
            print(f"❌ Failed to initialize Chrome driver: {str(e)}")
            raise
        
    def login(self):
        """Login to LinkedIn"""
        try:
            print("🔐 Attempting to log in to LinkedIn...")
            self.driver.get('https://www.linkedin.com/login')
            time.sleep(3)
            
            email = os.getenv('LINKEDIN_EMAIL')
            password = os.getenv('LINKEDIN_PASSWORD')
            
            if not email or not password:
                raise ValueError("LinkedIn credentials not found in .env file!")
            
            # Enter email
            email_field = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.ID, "username"))
            )
            email_field.clear()
            email_field.send_keys(email)
            time.sleep(1)
            
            # Enter password
            password_field = self.driver.find_element(By.ID, "password")
            password_field.clear()
            password_field.send_keys(password)
            time.sleep(1)
            
            # Click login
            login_button = self.driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
            login_button.click()
            
            time.sleep(5)
            
            # Check if login was successful
            if "feed" in self.driver.current_url or "mynetwork" in self.driver.current_url:
                print("✅ Logged in successfully!")
            else:
                print("⚠️  Login may have failed or requires verification")
                print(f"Current URL: {self.driver.current_url}")
                input("Press Enter after you've completed any verification...")
            
        except Exception as e:
            print(f"❌ Login failed: {str(e)}")
            print("Please check your credentials in the .env file")
            raise
            
    def scrape_profile(self, profile_url):
        """Scrape a single LinkedIn profile"""
        try:
            print(f"\n📊 Scraping: {profile_url}")
            self.driver.get(profile_url)
            time.sleep(random.uniform(3, 6))  # Random delay to avoid detection
            
            profile = {
                'url': profile_url,
                'name': '',
                'headline': '',
                'location': '',
                'about': '',
                'experience': '',
                'education': '',
            }
            
            # Scrape Name
            try:
                name = WebDriverWait(self.driver, 10).until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, "h1.text-heading-xlarge, h1.inline"))
                )
                profile['name'] = name.text.strip()
            except:
                profile['name'] = 'N/A'
            
            # Scrape Headline
            try:
                headline = self.driver.find_element(By.CSS_SELECTOR, "div.text-body-medium")
                profile['headline'] = headline.text.strip()
            except:
                profile['headline'] = 'N/A'
            
            # Scrape Location
            try:
                location = self.driver.find_element(By.CSS_SELECTOR, "span.text-body-small.inline, div.text-body-small")
                profile['location'] = location.text.strip()
            except:
                profile['location'] = 'N/A'
            
            # Scroll to load more content
            self.driver.execute_script("window.scrollTo(0, 800);")
            time.sleep(2)
            
            # Scrape About
            try:
                # Try multiple selectors for About section
                about_selectors = [
                    "section.artdeco-card div.display-flex",
                    "div.pv-about__summary-text",
                    "section[data-section='summary'] div.pv-shared-text-with-see-more"
                ]
                
                for selector in about_selectors:
                    try:
                        about_section = self.driver.find_element(By.CSS_SELECTOR, selector)
                        profile['about'] = about_section.text.strip()[:500]
                        break
                    except:
                        continue
                        
                if not profile['about']:
                    profile['about'] = 'N/A'
            except:
                profile['about'] = 'N/A'
            
            # Scroll more to load experience
            self.driver.execute_script("window.scrollTo(0, 1500);")
            time.sleep(2)
            
            # Scrape Experience
            try:
                experience = self.driver.find_element(By.CSS_SELECTOR, 
                    "div.pvs-list__paged-list-item, section#experience-section ul li")
                profile['experience'] = experience.text.strip()[:300]
            except:
                profile['experience'] = 'N/A'
            
            # Scrape Education
            try:
                education = self.driver.find_element(By.CSS_SELECTOR, 
                    "section#education-section ul li, div.pvs-list__paged-list-item")
                profile['education'] = education.text.strip()[:200]
            except:
                profile['education'] = 'N/A'
            
            print(f"✅ Scraped: {profile['name']}")
            self.profile_data.append(profile)
            
        except Exception as e:
            print(f"❌ Failed to scrape {profile_url}")
            print(f"   Error: {str(e)}")
            # Still add the profile with URL even if scraping failed
            self.profile_data.append({
                'url': profile_url,
                'name': 'Failed to scrape',
                'headline': str(e),
                'location': 'N/A',
                'about': 'N/A',
                'experience': 'N/A',
                'education': 'N/A'
            })
            
    def save_to_csv(self, filename='linkedin_profiles.csv'):
        """Save scraped data to CSV"""
        if not self.profile_data:
            print("⚠️  No data to save")
            return
            
        try:
            keys = self.profile_data[0].keys()
            
            with open(filename, 'w', newline='', encoding='utf-8') as output_file:
                dict_writer = csv.DictWriter(output_file, keys)
                dict_writer.writeheader()
                dict_writer.writerows(self.profile_data)
                
            print(f"\n✅ Data saved to {filename}")
            print(f"📊 Total profiles scraped: {len(self.profile_data)}")
            
        except Exception as e:
            print(f"❌ Failed to save CSV: {str(e)}")
        
    def close(self):
        """Close the browser"""
        try:
            self.driver.quit()
            print("🔒 Browser closed")
        except:
            pass


def main():
    print("=" * 60)
    print("LinkedIn Profile Scraper")
    print("=" * 60)
    
    # Updated LinkedIn profile URLs
    profile_urls = [
        "https://www.linkedin.com/in/williamhgates/",
        "https://www.linkedin.com/in/rbranson/",
        "https://www.linkedin.com/in/satyanadella/",
        "https://www.linkedin.com/in/jeffweiner08/",
        "https://www.linkedin.com/in/ariannahuffington/",
        "https://www.linkedin.com/in/simonsinek/",
        "https://www.linkedin.com/in/markcuban/",
        "https://www.linkedin.com/in/tonyrobbins/",
        "https://www.linkedin.com/in/jack-welch/",
        "https://www.linkedin.com/in/melindafrenchgates/",
        "https://www.linkedin.com/in/derekshen/",
        "https://www.linkedin.com/in/danielgoleman/",
        "https://www.linkedin.com/in/garyvaynerchuk/",
        "https://www.linkedin.com/in/deepakchopra/",
        "https://www.linkedin.com/in/thomas-lam/",
        "https://www.linkedin.com/in/peterthiel/",
        "https://www.linkedin.com/in/adamgrant/",
        "https://www.linkedin.com/in/brenebrown/",
        "https://www.linkedin.com/in/narendramodi/",
        "https://www.linkedin.com/in/kevinolearytv/",
    ]
    
    print(f"📋 Will scrape {len(profile_urls)} profiles\n")
    
    scraper = LinkedInScraper()
    
    try:
        scraper.login()
        
        for i, url in enumerate(profile_urls, 1):
            print(f"\n[{i}/{len(profile_urls)}]", end=" ")
            scraper.scrape_profile(url)
            
            # Random delay between profiles (important!)
            delay = random.uniform(5, 10)
            if i < len(profile_urls):
                print(f"⏳ Waiting {delay:.1f} seconds before next profile...")
                time.sleep(delay)
        
        scraper.save_to_csv()
        
        print("\n" + "=" * 60)
        print("✅ Scraping completed successfully!")
        print("=" * 60)
        
    except KeyboardInterrupt:
        print("\n\n⚠️  Scraping interrupted by user")
        scraper.save_to_csv()  # Save whatever we got
        
    except Exception as e:
        print(f"\n\n❌ An error occurred: {str(e)}")
        import traceback
        traceback.print_exc()
        
    finally:
        scraper.close()


if __name__ == "__main__":
    main()