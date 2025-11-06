require 'httparty'
require 'json'



response = HTTParty.post(
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=#{api_key}",
  headers: { 'Content-Type' => 'application/json' },
  body: {
    contents: [{
      parts: [{ text: "Write 2 sentences about Ruby on Rails" }]
    }]
  }.to_json
)

puts "Status Code: #{response.code}"
puts "\nResponse Body:"
puts response.body
puts "\n"

if response.success?
  text = response.parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
  puts "✅ SUCCESS! Generated Text:"
  puts text
else
  puts "❌ ERROR!"
  puts response.parsed_response
end
