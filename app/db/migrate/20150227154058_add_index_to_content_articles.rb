class AddIndexToContentArticles < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_content_articles_on_key_operators ON content_articles ( (key->>'operators') );
      CREATE INDEX index_content_articles_on_key_roumings ON content_articles ( (key->>'roumings') );
      CREATE INDEX index_content_articles_on_key_services ON content_articles ( (key->>'services') );
      CREATE INDEX index_content_articles_on_key_destinations ON content_articles ( (key->>'destinations') );
      CREATE INDEX index_content_articles_on_key_intensities ON content_articles ( (key->>'intensities') );
    SQL
  end
  
  def down
    execute <<-SQL
      DROP INDEX index_content_articles_on_key_operators;
      DROP INDEX index_content_articles_on_key_roumings;
      DROP INDEX index_content_articles_on_key_services;
      DROP INDEX index_content_articles_on_key_destinations;
      DROP INDEX index_content_articles_on_key_intensities;
    SQL
  end
  
end
