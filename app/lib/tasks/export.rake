namespace :export do
  desc "Prints Category.all in a seeds.rb way."
  task :seeds_format => :environment do
#    File.delete('db/seeds/autoload/tarif_description/tarif_classes.rb') if File.exist?('db/seeds/autoload/tarif_description/tarif_classes.rb')
    File.open('db/seeds/autoload/tarif_description/tarif_classes.rb', 'w+') do |f|
      File.truncate(f, 0)
      TarifClass.limit(2).order(:id).all.each do |row|
        
        f.write "TarifClass.create(JSON.parse(#{row.to_json(:except => [:id, :created_at, :age ]).inspect}))\n"
      end
    end
  end
end