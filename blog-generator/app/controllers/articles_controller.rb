class ArticlesController < ApplicationController
  def index
    @articles = Article.published.recent
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    # Just render the form
  end

  def generate
    titles_input = params[:titles]
    
    if titles_input.blank?
      flash[:error] = "Please provide article titles"
      redirect_to new_articles_path and return
    end
    
    # Parse input: "Title | Details" or just "Title"
    titles_with_details = titles_input.split("\n").map do |line|
      line = line.strip
      next if line.blank?
      
      if line.include?('|')
        parts = line.split('|', 2).map(&:strip)
        { title: parts[0], details: parts[1] }
      else
        { title: line, details: "" }
      end
    end.compact
    
    if titles_with_details.empty?
      flash[:error] = "No valid titles found"
      redirect_to new_articles_path and return
    end
    
    begin
      service = GeminiService.new
      articles = service.bulk_generate(titles_with_details)
      
      created_count = 0
      failed_count = 0
      
      articles.each do |article|
        if article[:success] != false
          Article.create!(
            title: article[:title],
            content: article[:content],
            author: "AI Generator (Gemini)",
            published: true
          )
          created_count += 1
        else
          failed_count += 1
        end
      end
      
      if created_count > 0
        flash[:success] = "Successfully generated #{created_count} article(s)!"
        flash[:error] = "#{failed_count} article(s) failed to generate" if failed_count > 0
      else
        flash[:error] = "Failed to generate articles. Please check your Gemini API key."
      end
    rescue => e
      flash[:error] = "Error: #{e.message}"
    end
    
    redirect_to articles_path
  end
end