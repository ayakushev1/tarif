require 'test_helper'

describe ParameterHelper do
  describe 'ParameterPresenter class' do
    before do
      @v = @controller.view_context
      Customer::Call.create(:base_subservice_id => 50, :own_phone => {"number" => "7000000000", "operator_id" => "1025", "region_id" =>"1501"})
      
      @par_without_json =Parameter.new( { 'id' => 1, 'source_type_id' => _call_data, 'nick_name' => 'base_sub_service', 'name' => 'base subservice', 'description' => '', 
                'source' => { 'table' => 'customer_calls', 'query' => 'select base_subservice_id from customer_calls', 'class' => 'Customer::Call', 'field' => 'base_subservice_id', 'sub_field' => '', 'field_type_id' => _reference, 'sub_field_type_id' => nil},          
                'display' => {'display_type_id' => _table, 'list' => '', 'table' => 'categories.service_directions', 'query' => '', 'class' => 'Categories', 'id_field' => 'id', 'name_field' => 'name'},
                'unit' => {'unit_id' => nil, 'field_name' => ''} } )
      
      @par_with_json =Parameter.new( { 'id' => 2, 'source_type_id' => _call_data, 'nick_name' => 'own_phone_number', 'name' => 'own phone number', 'description' => '', 
                'source' => { 'table' => 'customer_calls', 'query' => 'select own_phone from customer_calls', 'class' => 'Customer::Call', 'field' => 'own_phone', 'sub_field' => 'number', 'field_type_id' => _json, 'sub_field_type_id' => _string},          
                'display' => {'display_type_id' => _value, 'list' => {'MTC'=> 1025, 'Megafone'=> 1024}, 'table' => '', 'query' => '', 'class' => '', 'id_field' => '', 'name_field' => ''},
                'unit' => {'unit_id' => nil, 'field_name' => ''} } )

      @par_with_json_with_id =Parameter.new( { 'id' => 3, 'source_type_id' => _call_data, 'nick_name' => 'own_phone_operator_id', 'name' => 'own phone operator_id', 'description' => '', 
                'source' => { 'table' => 'customer_calls', 'query' => 'select own_phone from customer_calls', 'class' => 'Customer::Call', 'field' => 'own_phone', 'sub_field' => 'operator_id', 'field_type_id' => _json, 'sub_field_type_id' => _reference},          
                'display' => {'display_type_id' => _value, 'list' => '', 'table' => 'categories', 'query' => 'select * from categories where type_id = 2', 'string' => 'Category::Operator.operators', 'class' => 'Category', 'id_field' => 'id', 'name_field' => 'name'},
                'unit' => {'unit_id' => nil, 'field_name' => ''} } )
                
                
    end
    
    it 'must exist' do
      ParameterHelper::ParameterPresenter.must_be :==, ParameterHelper::ParameterPresenter
    end
    
    describe 'value method ' do
      it 'must give correct values' do
        ['class', 'table', 'query'].collect do |choice|
          choice + " = " + ParameterHelper::ParameterPresenter.new(@par_without_json, @controller.view_context).value(choice).to_s
        end.join(', ').must_be :==, "class = 70, table = 70, query = 70"
        
        ['class', 'table', 'query'].collect do |choice|
          choice + " = " + ParameterHelper::ParameterPresenter.new(@par_with_json, @controller.view_context).value(choice).to_s
        end.join(', ').must_be :==, "class = 7000000000, table = 7000000000, query = 7000000000"
      end
      
      it 'must give correct values' do
        [135, 136, 137, 138, 139].collect do |display_type_id|
          ParameterHelper::ParameterPresenter.new(@par_with_json_with_id, @controller.view_context).display.wont_be_nil
        end

      end
    end
  end
end

