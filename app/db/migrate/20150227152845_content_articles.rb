class ContentArticles < ActiveRecord::Migration
  def change
    create_table :content_articles do |t|
      t.references :author, index: true
      t.string :title, index:true
      t.json :content
      t.references :type, index: true
      t.references :status, index: true
      t.json :key

      t.timestamps
    end      
  end
  
end
