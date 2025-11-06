# 📞 Autodialer Rails App - Assignment 2

An automated calling system built with Ruby on Rails and Twilio API, featuring AI-powered voice commands, bulk calling capabilities, and comprehensive call logging.

## 🎯 Features

### Core Functionality
- ✅ **Single Call System** - Make individual calls with custom messages
- ✅ **Bulk Calling** - Upload and dial 100+ numbers automatically
- ✅ **AI Voice Commands** - Natural language call commands (e.g., "Call +918001234567")
- ✅ **Call Logs & Analytics** - Track all calls with detailed statistics
- ✅ **Custom AI Voice Messages** - Personalize automated voice messages
- ✅ **Real-time Status Updates** - Monitor call status (queued, ringing, completed, failed)

### Dashboard Features
- 📊 Real-time statistics (Total calls, Successful, Failed, Average duration)
- 📋 Call history with timestamps
- 🔍 Status filtering
- 📱 Responsive design

## 🛠️ Tech Stack

- **Framework:** Ruby on Rails 8.1.1
- **Database:** PostgreSQL 14+
- **Ruby Version:** 3.4.7
- **APIs:** Twilio Voice API
- **Styling:** Custom CSS (No frameworks)
- **Dependencies:**
  - twilio-ruby (~> 6.0) - Twilio API integration
  - httparty - HTTP client
  - dotenv-rails - Environment variable management

## 📋 Prerequisites

Before running this application, ensure you have:

- Ruby 3.4.7+ installed
- PostgreSQL 14+ installed and running
- Twilio Account ([Sign up free](https://www.twilio.com/try-twilio))
- WSL2/Ubuntu (if on Windows)

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
cd ~/AeroLabs-ASSIGNMENT/autodialer-rails

. Install Dependencies
Bash

bundle install
3. Setup Environment Variables
Create a .env file in the root directory:

Bash

nano .env
Add your Twilio credentials:

env

TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+1234567890
How to get Twilio credentials:

Sign up at Twilio
Find Account SID and Auth Token in your Console Dashboard
Get a free phone number from Phone Numbers page
4. Setup Database
Bash

# Start PostgreSQL (WSL/Ubuntu)
sudo service postgresql start

# Create database
rails db:create

# Run migrations
rails db:migrate
5. Start the Server
Bash

rails server
Visit: http://localhost:3000

📱 Usage Guide
Making a Single Call
Navigate to the "Single Call" section
Enter phone number with country code (e.g., +918001234567)
(Optional) Add a custom AI voice message
Click "Make Call"
Bulk Calling
Navigate to "Bulk Upload" section
Enter phone numbers (one per line or comma-separated):
text

+918001234567
+918001234568
+918001234569
(Optional) Add a custom message for all calls
Click "Start Bulk Calling"
AI Voice Command
Navigate to "AI Voice Command" section
Type natural language command:
"Call +918001234567"
"Dial +18005551234"
"Make a call to +917620341518"
Click "Execute AI Command"
AI parses the number and initiates the call
Viewing Call Logs
Scroll to the "Call Logs" section
See all calls with:
Phone number
Status (completed, failed, queued, etc.)
Duration (for completed calls)
Timestamp
🔒 Twilio Free Trial Limitations
Important Notes:
Free Trial Restrictions:

✅ Can make calls
❌ Can ONLY call verified phone numbers
🔊 Calls include "This is a trial account" message
Verifying Phone Numbers
To call a number on free trial:

Go to Verified Caller IDs
Click "Add a new Caller ID"
Enter the phone number
Choose verification method (Call/SMS)
Enter the code received
Number is now callable!
You can verify up to 10 numbers on free trial.

Upgrading to Full Account
To call any number without verification:

Go to Billing
Click "Upgrade"
Add at least $20 credit
Now you can call any number globally
🗂️ Project Structure
text

autodialer-rails/
├── app/
│   ├── controllers/
│   │   └── autodialer_controller.rb    # Main controller
│   ├── models/
│   │   └── call_log.rb                 # Call records model
│   ├── services/
│   │   └── twilio_service.rb           # Twilio API wrapper
│   └── views/
│       └── autodialer/
│           └── index.html.erb          # Main dashboard
├── config/
│   ├── database.yml                     # Database config
│   └── routes.rb                        # Application routes
├── db/
│   └── migrate/
│       └── xxxxxx_create_call_logs.rb  # Database schema
├── .env                                 # Environment variables (git-ignored)
├── Gemfile                              # Ruby dependencies
└── README.md                            # This file
🔧 Configuration
Database Configuration
Edit config/database.yml:

YAML

development:
  adapter: postgresql
  encoding: unicode
  database: autodialer_rails_development
  username: sidvyas
  host: localhost
  pool: 5
Routes
Available routes:

Method	Path	Action	Description
GET	/	index	Dashboard with stats
POST	/autodialer/create	create	Make single call
POST	/autodialer/bulk_upload	bulk_upload	Make bulk calls
POST	/autodialer/ai_command	ai_command	Parse AI command
🧪 Testing
Test Numbers (Important!)
For assignment demonstration, only use:

Verified numbers (add in Twilio console)
Your own phone number (verified during signup)
Toll-free 1800 numbers (if account is upgraded)
Example test numbers:

text

+918001234567 (toll-free)
+18001234567 (US toll-free)
Your verified number
⚠️ DO NOT call random people's numbers!

Manual Testing Steps
Single Call:

text

Phone: Your verified number
Message: "This is a test call"
Expected: Call initiated, appears in logs
Bulk Call:

text

Numbers: 
+918001234567
+918001234568
Expected: Both calls initiated
AI Command:

text

Command: "Call +918001234567"
Expected: Number extracted, call initiated
🐛 Troubleshooting
PostgreSQL Connection Error
Bash

# Start PostgreSQL
sudo service postgresql start

# Check status
sudo service postgresql status
Twilio Authentication Error (HTTP 401)
Problem: Invalid credentials

Solution:

Check .env file has correct values
Verify no extra spaces or quotes
Restart Rails server after changing .env
Bash

# Verify .env format
cat .env
# Should show:
# TWILIO_ACCOUNT_SID=ACxxxxx
# TWILIO_AUTH_TOKEN=xxxxx
# TWILIO_PHONE_NUMBER=+1xxxxx
Unverified Number Error (HTTP 400 - Error 21219)
Problem: Calling unverified number on trial account

Solution:

Verify the number in Twilio Console
Or upgrade to paid account
Or use already verified numbers
Server Not Starting
Bash

# Kill any running Rails processes
pkill -9 ruby

# Try starting again
rails server
Gems Installation Issues
Bash

# Update bundler
gem update bundler

# Clean install
rm Gemfile.lock
bundle install
📊 Database Schema
CallLogs Table
Column	Type	Description
id	bigint	Primary key
phone_number	string	Destination number
status	string	Call status
duration	integer	Call duration (seconds)
error_message	text	Error details if failed
call_sid	string	Twilio call identifier
created_at	datetime	When call was initiated
updated_at	datetime	Last status update
Indexes:

phone_number
status
call_sid
created_at


# Set environment variables
heroku config:set TWILIO_ACCOUNT_SID=ACxxxxx
heroku config:set TWILIO_AUTH_TOKEN=xxxxx
heroku config:set TWILIO_PHONE_NUMBER=+1xxxxx

# Deploy
git push heroku main
heroku run rails db:migrate
heroku open
Deploying to Railway.app
Connect GitHub repository
Add PostgreSQL plugin
Set environment variables in Railway dashboard
Deploy automatically on push
Deploying to Render.com
Create new Web Service
Connect repository
Build command: bundle install; rails db:migrate
Start command: rails server -b 0.0.0.0
Add environment variables
Deploy
📝 Development Notes
Adding New Features
Example: Add SMS functionality

Update TwilioService:
Ruby

def send_sms(to_number, message)
  @client.messages.create(
    from: @phone_number,
    to: to_number,
    body: message
  )
end
Create route and controller action
Update view with SMS form
Code Style
This project follows:

Rails conventions
Rubocop Rails Omakase style guide
RESTful routing principles
🤝 Contributing
This is an assignment project. Not accepting external contributions.

📄 License
This project is for educational purposes only (AeroLabs Technical Assignment).

👤 Author
[Sidharhta vyas]]

Email: [vyassidhartha5@gmail.com]
Phone: [Your Phone]
Assignment: AeroLabs Technical Assessment
