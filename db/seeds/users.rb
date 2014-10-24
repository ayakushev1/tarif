#User.delete_all
u = User.new(id: 0, name: "demo", email: 'ayakushev@rambler.ru', password: ENV["TARIF_ADMIN_PASSWORD"], password_confirmation: ENV["TARIF_ADMIN_PASSWORD"])
u.skip_confirmation_notification!
u.save!(:validate => false)

#u = User.new(id: 1, name: "admin", email: ENV["TARIF_ADMIN_USERNAME"], password: ENV["TARIF_ADMIN_PASSWORD"], password_confirmation: ENV["TARIF_ADMIN_PASSWORD"])
#u.skip_confirmation_notification!
#u.save!(:validate => false)

