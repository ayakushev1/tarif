#User.delete_all
if !User.where(:id => 0, :name => "demo").first
  u = User.new(id: 0, name: "demo", email: 'ayakushev@rambler.ru', password: ENV["TARIF_ADMIN_PASSWORD"], password_confirmation: ENV["TARIF_ADMIN_PASSWORD"])
  u.skip_confirmation_notification!
  u.save!(:validate => false)
end

if !User.where(:id => 1, :name => "admin").first
  u = User.new(id: 1, name: "admin", email: ENV["TARIF_ADMIN_USERNAME"], password: ENV["TARIF_ADMIN_PASSWORD"], password_confirmation: ENV["TARIF_ADMIN_PASSWORD"])
  u.skip_confirmation_notification!
  u.save!(:validate => false)
end
