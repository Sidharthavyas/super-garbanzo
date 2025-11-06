require 'twilio-ruby'

class TwilioService
  def initialize
    @account_sid = ENV['TWILIO_ACCOUNT_SID']
    @auth_token = ENV['TWILIO_AUTH_TOKEN']
    @phone_number = ENV['TWILIO_PHONE_NUMBER']
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)
  end

  def make_call(to_number, ai_message = nil)
    begin
      to_number = normalize_phone(to_number)
      message = ai_message || "Hello! This is an automated test call from Autodialer system. Thank you for your time. Goodbye."
      
      call = @client.calls.create(
        from: @phone_number,
        to: to_number,
        twiml: generate_twiml(message)
      )

      CallLog.create!(
        phone_number: to_number,
        status: call.status,
        call_sid: call.sid
      )

      { success: true, call_sid: call.sid, message: "Call initiated to #{to_number}" }
    rescue Twilio::REST::RestError => e
      CallLog.create!(
        phone_number: to_number,
        status: 'failed',
        error_message: e.message
      )
      { success: false, error: e.message }
    rescue => e
      { success: false, error: e.message }
    end
  end

  def make_bulk_calls(phone_numbers, ai_message = nil)
    results = []
    phone_numbers.each do |number|
      result = make_call(number, ai_message)
      results << result
      sleep(1)
    end
    results
  end

  def parse_ai_command(command)
    # Simple regex to extract phone number
    phone_match = command.match(/(\+?\d[\d\s\-\(\)]+)/)
    if phone_match
      { action: 'make_call', phone_number: phone_match[1].gsub(/[\s\-\(\)]/, '') }
    else
      { action: 'invalid', error: 'No phone number found' }
    end
  end

  private

  def normalize_phone(number)
    cleaned = number.to_s.gsub(/[^0-9+]/, '')
    cleaned = "+#{cleaned}" unless cleaned.start_with?('+')
    cleaned
  end

  def generate_twiml(message)
    "<Response>
      <Say voice='Polly.Aditi' language='en-IN'>#{message}</Say>
      <Pause length='1'/>
      <Say voice='Polly.Aditi' language='en-IN'>Goodbye!</Say>
    </Response>"
  end
end