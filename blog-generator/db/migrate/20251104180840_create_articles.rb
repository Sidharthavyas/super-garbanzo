class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :author
      t.boolean :published, default: false

      t.timestamps
    end
    
    add_index :articles, :published
    add_index :articles, :created_at
  end
end