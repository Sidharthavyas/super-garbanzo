class AutodialerController < ApplicationController
  def index
    @call_logs = CallLog.order(created_at: :desc).limit(100)
    @stats = CallLog.stats
  end

  def create
    phone_number = params[:phone_number]
    ai_message = params[:ai_message]
    
    if phone_number.blank?
      flash[:error] = "Please provide a phone number"
      redirect_to root_path and return
    end
    
    service = TwilioService.new
    result = service.make_call(phone_number, ai_message)
    
    if result[:success]
      flash[:success] = result[:message]
    else
      flash[:error] = "Call failed: #{result[:error]}"
    end
    
    redirect_to root_path
  end

  def bulk_upload
    phone_numbers_raw = params[:phone_numbers]
    
    if phone_numbers_raw.blank?
      flash[:error] = "No phone numbers provided"
      redirect_to root_path and return
    end
    
    phone_numbers = phone_numbers_raw.split(/[\n,;]/).map(&:strip).reject(&:blank?)
    ai_message = params[:ai_message]
    
    service = TwilioService.new
    results = service.make_bulk_calls(phone_numbers, ai_message)
    
    successful = results.count { |r| r[:success] }
    failed = results.count { |r| !r[:success] }
    
    flash[:success] = "Calls complete: #{successful} successful, #{failed} failed"
    redirect_to root_path
  end

  def ai_command
    command = params[:command]
    
    if command.blank?
      flash[:error] = "Please enter a command"
      redirect_to root_path and return
    end
    
    service = TwilioService.new
    parsed = service.parse_ai_command(command)
    
    if parsed[:action] == 'make_call' && parsed[:phone_number]
      result = service.make_call(parsed[:phone_number])
      flash[:success] = "AI Command executed: #{result[:message]}"
    else
      flash[:error] = "Could not parse command: #{parsed[:error]}"
    end
    
    redirect_to root_path
  end
end