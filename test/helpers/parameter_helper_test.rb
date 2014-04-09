require 'test_helper'

describe ParameterHelper do
  describe 'ParameterPresenter class' do
    before do
      @v = @controller.view_context
      _original = 130; _intermediate = 131; #source_type_id
      _boolean = 3; _integer = 4; _string = 5; _text = 6; _decimal = 7; _list = 8; _reference = 9; _datetime = 10; _json = 11; _array = 12; #field type
      _value = 135; _list = 136; _table = 137; _raw_query = 138; #display type
      Call.create(:base_subservice_id => 50, :own_phone => {"number" => "+7 000 000000", "operator_id" => "1025", "region_id" =>"1501"})
      
      @par_without_json =Parameter.new( { 'id' => 1, 'source_type_id' => _original, 'nick_name' => 'base_sub_service', 'name' => 'base subservice', 'description' => '', 
                'source' => { 'table' => 'calls', 'query' => 'select base_subservice_id from calls', 'class' => 'Call', 'field' => 'base_subservice_id', 'sub_field' => '', 'field_type_id' => _reference, 'sub_field_type_id' => nil},          
                'display' => {'display_type_id' => _table, 'list' => '', 'table' => 'categories.service_directions', 'query' => '', 'class' => 'Categories', 'id_field' => 'id', 'name_field' => 'name'},
                'unit' => {'unit_id' => nil, 'field_name' => ''} } )
      
      @par_with_json =Parameter.new( { 'id' => 2, 'source_type_id' => _original, 'nick_name' => 'own_phone_number', 'name' => 'own phone number', 'description' => '', 
                'source' => { 'table' => 'calls', 'query' => 'select own_phone from calls', 'class' => 'Call', 'field' => 'own_phone', 'sub_field' => 'number', 'field_type_id' => _json, 'sub_field_type_id' => _string},          
                'display' => {'display_type_id' => _value, 'list' => {'MTC'=> 1025, 'Megafone'=> 1024}, 'table' => '', 'query' => '', 'class' => '', 'id_field' => '', 'name_field' => ''},
                'unit' => {'unit_id' => nil, 'field_name' => ''} } )

      @par_with_json_with_id =Parameter.new( { 'id' => 3, 'source_type_id' => _original, 'nick_name' => 'own_phone_operator_id', 'name' => 'own phone operator_id', 'description' => '', 
                'source' => { 'table' => 'calls', 'query' => 'select own_phone from calls', 'class' => 'Call', 'field' => 'own_phone', 'sub_field' => 'operator_id', 'field_type_id' => _json, 'sub_field_type_id' => _reference},          
                'display' => {'display_type_id' => _value, 'list' => '', 'table' => 'categories', 'query' => 'select * from categories where type_id = 2', 'string' => 'Category.operators', 'class' => 'Category', 'id_field' => 'id', 'name_field' => 'name'},
                'unit' => {'unit_id' => nil, 'field_name' => ''} } )
                
                
    end
    
    it 'must exist' do
      ParameterHelper::ParameterPresenter.must_be :==, ParameterHelper::ParameterPresenter
    end
    
    describe 'value method ' do
      it 'must give correct values' do
        ['class', 'table', 'query'].collect do |choice|
          choice + " = " + ParameterHelper::ParameterPresenter.new(@par_without_json).value(choice).to_s
        end.join(', ').must_be :==, "class = 50, table = 50, query = 50"
        
        ['class', 'table', 'query'].collect do |choice|
          choice + " = " + ParameterHelper::ParameterPresenter.new(@par_with_json).value(choice).to_s
        end.join(', ').must_be :==, "class = +7 000 000000, table = +7 000 000000, query = +7 000 000000"
      end
      
      it 'must give correct values' do
        [135, 136, 137, 138, 139].collect do |display_type_id|
          ParameterHelper::ParameterPresenter.new(@par_with_json_with_id).display(@controller.view_context, display_type_id).wont_be_nil
        end

      end
    end
  end
end

