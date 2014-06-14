User.where('id > 1').delete_all
Customer::Service.delete_all
csv =[]; usr = [];

tarif = TarifClass.find(_tarif_classes[:Beeline][:private][:tarif].to_a[0])
operator_rouming = TarifClass.find(_tarif_classes[:Beeline][:private][:operator_rouming].to_a[0])
country_rouming = TarifClass.find(_tarif_classes[:Beeline][:private][:country_rouming].to_a[0])
world_rouming = TarifClass.find(_tarif_classes[:Beeline][:private][:world_rouming].to_a[0])
services = TarifClass.find(_tarif_classes[:Beeline][:private][:services].to_a[0])

user_id = 2

usr << {
  :id => user_id,
  :name => "#{tarif.operator.name} user, tarif #{tarif.name}",
  :password => "111", 
  :password_confirmation => "111"
}

csv << {:id => user_id,     :user_id => user_id, :phone_number => '7000000000', :tarif_class_id => tarif.id, :tarif_list_id => nil, :status_id => _subscribed, :valid_from => Date.today - 100.days, :valid_till => Date.today + 700.days} 
csv << {:id => user_id + 1, :user_id => user_id, :phone_number => '7000000000', :tarif_class_id => operator_rouming.id, :tarif_list_id => nil, :status_id => _subscribed, :valid_from => Date.today - 100.days, :valid_till => Date.today + 700.days} 
csv << {:id => user_id + 2, :user_id => user_id, :phone_number => '7000000000', :tarif_class_id => country_rouming.id, :tarif_list_id => nil, :status_id => _subscribed, :valid_from => Date.today - 100.days, :valid_till => Date.today + 700.days} 
csv << {:id => user_id + 3, :user_id => user_id, :phone_number => '7000000000', :tarif_class_id => world_rouming.id, :tarif_list_id => nil, :status_id => _subscribed, :valid_from => Date.today - 100.days, :valid_till => Date.today + 700.days} 
csv << {:id => user_id + 4, :user_id => user_id, :phone_number => '7000000000', :tarif_class_id => services.id, :tarif_list_id => nil, :status_id => _subscribed, :valid_from => Date.today - 100.days, :valid_till => Date.today + 700.days} 

user_id += 1

Customer::Service.transaction do
  User.create(usr)
  Customer::Service.create(csv)
end

#  id             :integer          not null, primary key
#  user_id        :integer
#  phone_number   :string(255)
#  tarif_class_id :integer
#  tarif_list_id  :integer
#  status_id      :integer
#  valid_from     :datetime
#  valid_till     :datetime
#  description    :json
#  created_at     :datetime
#  updated_at     :datetime
#
