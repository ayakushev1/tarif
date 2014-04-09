#constant definition
_original = 130; _intermediate = 131; #source_type_id
_boolean = 3; _integer = 4; _string = 5; _text = 6; _decimal = 7; _list = 8; _reference = 9; _datetime = 10; _json = 11; _array = 12; #field type
_value = 135; _list = 136; _table = 137; _string = 138; _query = 139; #display type
_byte = 80; _k_byte = 81; m_byte = 82; g_byte = 83; #volume unit ids

Parameter.delete_all
pars = []
pars << { :id => 0, :source_type_id => _original, :nick_name => 'base_service', :name => 'base service', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'base_service_id', :sub_field => '', :field_type_id => _reference, :sub_field_type_id => nil},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.base_services', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 1, :source_type_id => _original, :nick_name => 'base_sub_service', :name => 'base subservice', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'base_subservice_id', :sub_field => '', :field_type_id => _reference, :sub_field_type_id => nil},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.service_directions', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 2, :source_type_id => _original, :nick_name => 'own_phone_number', :name => 'own phone number', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'own_phone', :sub_field => 'number', :field_type_id => _json, :sub_field_type_id => _string},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '',:name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 3, :source_type_id => _original, :nick_name => 'own_phone_operator_id', :name => 'own phone operator_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'own_phone', :sub_field => 'operator_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operators', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 4, :source_type_id => _original, :nick_name => 'own_phone_region_id', :name => 'own phone region_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'own_phone', :sub_field => 'region_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.regions', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 5, :source_type_id => _original, :nick_name => 'own_phone_country_id', :name => 'own phone country_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'own_phone', :sub_field => 'country_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.countries', :query => '', :class => 'Category',:id_field => 'id',:name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 6, :source_type_id => _original, :nick_name => 'partner_phone_number', :name => 'partner phone number', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'partner_phone', :sub_field => 'number', :field_type_id => _json, :sub_field_type_id => _string},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '',:name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 7, :source_type_id => _original, :nick_name => 'partner_phone_operator_id', :name => 'partner phone operator_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'partner_phone', :sub_field => 'operator_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operators', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 8, :source_type_id => _original, :nick_name => 'partner_phone_operator_type_id', :name => 'partner phone operator_type_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'partner_phone', :sub_field => 'operator_type_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operator_types', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 9, :source_type_id => _original, :nick_name => 'partner_phone_region_id', :name => 'partner phone region_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'partner_phone', :sub_field => 'region_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.regions', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 10, :source_type_id => _original, :nick_name => 'partner_phone_country_id', :name => 'partner phone country_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'partner_phone', :sub_field => 'country_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.countries', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 11, :source_type_id => _original, :nick_name => 'connect_operator_id', :name => 'connect operator_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'connect', :sub_field => 'operator_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.operators', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 12, :source_type_id => _original, :nick_name => 'connect_region_id', :name => 'connect region_id', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'connect', :sub_field => 'region_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.regions', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 13, :source_type_id => _original, :nick_name => 'connect_country_id', :name => 'connect country', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'connect', :sub_field => 'country_id', :field_type_id => _json, :sub_field_type_id => _reference},          
          :display => {:display_type_id => _string, :list => '', :table => '', :string => 'Category.countries', :query => '', :class => 'Category',:id_field => 'id', :name_field => 'name'},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 14, :source_type_id => _original, :nick_name => 'description_time', :name => 'description time', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'description', :sub_field => 'time', :field_type_id => _json, :sub_field_type_id => _datetime},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 15, :source_type_id => _original, :nick_name => 'description_duration', :name => 'description duration', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'description', :sub_field => 'duration', :field_type_id => _json, :sub_field_type_id => _decimal},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => nil, :field_name => '', :sub_field_name => ''} }

pars << { :id => 16, :source_type_id => _original, :nick_name => 'description_volume', :name => 'description volume', :description => '', 
          :source => { :table => 'calls',:query => '', :class => 'Call', :field => 'description', :sub_field => 'volume', :field_type_id => _json, :sub_field_type_id => _decimal},          
          :display => {:display_type_id => _value, :list => '', :table => '', :string => '', :query => '', :class => '',:id_field => '', :name_field => ''},
          :unit => {:unit_id => _byte, :field_name => 'description', :sub_field_name => 'volume_unit_id'} }



ActiveRecord::Base.transaction do
  Parameter.create(pars)
end
    