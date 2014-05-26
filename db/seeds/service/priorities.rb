Service::Priority.delete_all

pri = [];

TarifClass.all.each do |tarif_class|
  next if _correct_tarif_class_ids.include?(tarif_class.id)
  general_priority = case tarif_class.standard_service_id
  when _tarif
    _tarif_class_priority
  when _rouming
    _rouming_priority
  when _special_service
    _special_service_priority
  when _tarif_option
    _tarif_option_priority
  else
    -1
  end

  pri << {:type_id => _general_priority, :main_tarif_class_id => tarif_class.id, :value => general_priority}
  
end

ActiveRecord::Base.transaction do
  Service::Priority.create(pri)
end

#  id                          :integer          not null, primary key
#  type_id                     :integer
#  main_tarif_class_id         :integer
#  dependent_tarif_class_id    :integer
#  relation_id                 :integer
#  value                       :integer
#  arr_value                   :integer          default([]), is an Array
