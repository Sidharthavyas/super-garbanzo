require 'httparty'

class GeminiService
  include HTTParty
  base_uri 'https://generativelanguage.googleapis.com'

  def initialize
    @api_key = ENV['GEMINI_API_KEY']
    raise "GEMINI_API_KEY not set" if @api_key.blank?
  end

  def generate_article(title, details = "")
    prompt = <<~PROMPT
      Write a comprehensive, professional programming article about: "#{title}"
      
      Additional context: #{details}
      
      Requirements:
      - Length: 1000-1500 words
      - Professional but accessible tone
      - Include clear introduction
      - Use section headings
      - Add practical examples and code snippets where relevant
      - Include a strong conclusion
      - Format in HTML using: <h2>, <h3>, <p>, <pre><code>, <ul>, <li>, <strong>
      - Do NOT include <!DOCTYPE>, <html>, <head>, or <body> tags
      
      Write the complete article now:
    PROMPT

    response = self.class.post(
      "/v1beta/models/gemini-2.5-pro:generateContent?key=#{@api_key}",
      headers: { 'Content-Type' => 'application/json' },
      body: {
        contents: [{
          parts: [{ text: prompt }]
        }],
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 8192
        }
      }.to_json
    )

    if response.success?
      content = response.parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
      if content
        content.gsub(/```html\s*/, '').gsub(/```\s*/, '').strip
      else
        raise "No content generated"
      end
    else
      error_msg = response.parsed_response.dig('error', 'message') || response.body
      raise "Gemini API Error: #{error_msg}"
    end
  rescue => e
    Rails.logger.error("Gemini API Error: #{e.message}")
    raise e
  end

  def bulk_generate(titles_with_details)
    articles = []
    
    titles_with_details.each_with_index do |item, index|
      begin
        Rails.logger.info("Generating article #{index + 1}/#{titles_with_details.length}: #{item[:title]}")
        
        content = generate_article(item[:title], item[:details])
        articles << { 
          title: item[:title], 
          content: content, 
          success: true 
        }
        
        # Sleep to avoid rate limiting
        sleep(3) if index < titles_with_details.length - 1
      rescue => e
        Rails.logger.error("Error generating article '#{item[:title]}': #{e.message}")
        articles << { 
          title: item[:title], 
          content: "<p>Error generating article: #{e.message}</p>",
          success: false,
          error: e.message
        }
      end
    end
    
    articles
  end
end