Parameter.delete_all
pars = []
pars << { :id => _call_base_service_id, :source_type_id => _call_data, :nick_name => 'base_service', :name => 'base service', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'base_service_id', :sub_field => '', :field_type_id => _reference, :sub_field_type_id => nil},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.base_services', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_base_sub_service_id, :source_type_id => _call_data, :nick_name => 'base_sub_service', :name => 'base subservice', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'base_subservice_id', :sub_field => '', :field_type_id => _reference, :sub_field_type_id => nil},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.service_directions', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_own_phone_number, :source_type_id => _call_data, :nick_name => 'own_phone_number', :name => 'own phone number', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'own_phone', :sub_field => 'number', :field_type_id => _json, :sub_field_type_id => _string},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '',:name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_own_phone_operator_id, :source_type_id => _call_data, :nick_name => 'own_phone_operator_id', :name => 'own phone operator_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'own_phone', :sub_field => 'operator_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.russian_operators', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_own_phone_region_id, :source_type_id => _call_data, :nick_name => 'own_phone_region_id', :name => 'own phone region_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'own_phone', :sub_field => 'region_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.regions', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_own_phone_country_id, :source_type_id => _call_data, :nick_name => 'own_phone_country_id', :name => 'own phone country_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'own_phone', :sub_field => 'country_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.countries', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_partner_phone_number, :source_type_id => _call_data, :nick_name => 'partner_phone_number', :name => 'partner phone number', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'partner_phone', :sub_field => 'number', :field_type_id => _json, :sub_field_type_id => _string},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '',:name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_partner_phone_operator_id, :source_type_id => _call_data, :nick_name => 'partner_phone_operator_id', :name => 'partner phone operator_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'partner_phone', :sub_field => 'operator_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operators', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_partner_phone_operator_type_id, :source_type_id => _call_data, :nick_name => 'partner_phone_operator_type_id', :name => 'partner phone operator_type_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'partner_phone', :sub_field => 'operator_type_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operator_types', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_partner_phone_region_id, :source_type_id => _call_data, :nick_name => 'partner_phone_region_id', :name => 'partner phone region_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'partner_phone', :sub_field => 'region_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.regions', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_partner_phone_country_id, :source_type_id => _call_data, :nick_name => 'partner_phone_country_id', :name => 'partner phone country_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'partner_phone', :sub_field => 'country_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.countries', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_connect_operator_id, :source_type_id => _call_data, :nick_name => 'connect_operator_id', :name => 'connect operator_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'connect', :sub_field => 'operator_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operators', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_connect_region_id, :source_type_id => _call_data, :nick_name => 'connect_region_id', :name => 'connect region_id', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'connect', :sub_field => 'region_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.regions', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_connect_country_id, :source_type_id => _call_data, :nick_name => 'connect_country_id', :name => 'connect country', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'connect', :sub_field => 'country_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.countries', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_description_time, :source_type_id => _call_data, :nick_name => 'description_time', :name => 'description time', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'description', :sub_field => 'time', :field_type_id => _json, :sub_field_type_id => _datetime},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_description_duration, :source_type_id => _call_data, :nick_name => 'description_duration', :name => 'description duration', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'description', :sub_field => 'duration', :field_type_id => _json, :sub_field_type_id => _decimal},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _call_description_volume, :source_type_id => _call_data, :nick_name => 'description_volume', :name => 'description volume', :description => '', 
          :source => { :table => 'customer_calls',:query => '', :class => 'Customer::Call', :field => 'description', :sub_field => 'volume', :field_type_id => _json, :sub_field_type_id => _decimal},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => _byte, :field_name => 'description', :sub_field_name => 'volume_unit_id'} }

pars << { :id => _category_operator_type_id, :source_type_id => _intermediate_data, :nick_name => 'category_operator_type_id', :name => 'category_operator_type_id', :description => '', 
          :source => { :table => 'categories',:query => '', :class => 'Category', :field => 'id', :sub_field => nil, :field_type_id => _integer, :sub_field_type_id => nil},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operator_types', :query => '', :class => '',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => nil, :sub_field_name => nil} }

pars << { :id => _fq_tarif_operator_id, :source_type_id => _input_data, :nick_name => '@fq_tarif_operator_id', :name => '@fq_tarif_operator_id', :description => '', 
          :source => {:input => 'variable', :field => '@fq_tarif_operator_id', :sub_field => '', :field_type_id => _integer, :sub_field_type_id => nil},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _fq_tarif_region_id, :source_type_id => _input_data, :nick_name => '@fq_tarif_region_id', :name => '@fq_tarif_region_id', :description => '', 
          :source => {:input => 'variable', :field => '@fq_tarif_region_id', :sub_field => '', :field_type_id => _integer, :sub_field_type_id => nil},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _fq_tarif_home_region_ids, :source_type_id => _intermediate_data, :nick_name => 'fq_tarif_home_region_ids', :name => 'fq_tarif_home_region_ids', :description => '', 
          :source => { :string => 'Relation.home_regions(@fq_tarif_operator_id, @fq_tarif_region_id)', :class => 'Relation', :field => 'children', :sub_field =>  nil, :field_type_id => _array, :sub_field_type_id => nil},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => _fq_tarif_country_id, :source_type_id => _intermediate_data, :nick_name => 'fq_tarif_country_id', :name => 'fq_tarif_country_id', :description => '', 
          :source => { :string => 'Category.locations.where(:id => @fq_tarif_region_id).first.parent_id', :class => 'Category', :field => 'parent_id', :sub_field =>  nil, :field_type_id => _integer, :sub_field_type_id => nil},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }




ActiveRecord::Base.transaction do
  Parameter.create(pars)
end
    