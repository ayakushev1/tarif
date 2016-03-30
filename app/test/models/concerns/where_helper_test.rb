require 'test_helper'
class Dumy < ActiveRecord::Base
  include WhereHelper
  self.table_name = 'customer_calls'
end

describe Dumy do
  before do
    data ={}
    @valid_json_key = 'own_phone'
    @valid_json_value = {'number' => '444', 'operator_id' => '1111'}
    @invalid_json_key = 'own_phone1'
    
    @field_to_exclude = @valid_json_key
    @field_to_exclude_hash = "own_phone[number]"

    @valid_else_key = 'user_id'
    @valid_else_value = '111'
    @invalid_else_key = 'own_phone1'
    
  end
  
  it 'must include where_from_filtr and query_from_filtr methods from WhereHelper' do
    assert Dumy.methods.include?(:where_from_filtr)
    assert Dumy.methods.include?(:query_from_filtr)
  end

  it 'where_from_filtr must return valid where part of sql' do
    Dumy.where_from_filtr(nil, nil).must_be_kind_of( ActiveRecord::Relation)
    Dumy.where_from_filtr(nil, nil).to_sql.must_be :=~, /WHERE/
    Dumy.where_from_filtr(@valid_else_key, @valid_else_value).where_values_hash.must_be :==, {@valid_else_key => @valid_else_value}
    Dumy.where_from_filtr(@invalid_else_key, @valid_else_value).where_values_hash.must_be :==, {}
    Dumy.where_from_filtr(@valid_json_key, @valid_json_value).to_sql.must_be :=~, /own_phone->>'number'/
    Dumy.where_from_filtr(@invalid_json_key, @valid_json_value).to_sql.wont_be :=~, /own_phone1/
  end
    
  it 'query_from_filtr must return valid where part of sql' do
    Dumy.query_from_filtr(nil).must_be_kind_of( ActiveRecord::Relation)
    Dumy.query_from_filtr('sssssssss').must_be_kind_of( ActiveRecord::Relation)
    Dumy.query_from_filtr({'sssssssss'=> "ssss"}).must_be_kind_of( ActiveRecord::Relation)
    
    Dumy.query_from_filtr({@valid_else_key=>@valid_else_value}).where_values_hash.must_be :==, {@valid_else_key => @valid_else_value}
    Dumy.query_from_filtr({@invalid_else_key=>@valid_else_value}).where_values_hash.must_be :==, {}

    Dumy.query_from_filtr({@valid_json_key=>@valid_json_value}).to_sql.must_be :=~, /own_phone->>'number'/
    Dumy.query_from_filtr({@invalid_json_key=>@valid_json_value}).to_sql.wont_be :=~, /own_phone1/    
  end
  
  it 'query_from_filtr must exclude provided field from sql' do    
    Dumy.query_from_filtr({@valid_else_key=>@valid_else_value}).where_values_hash.must_be :==, {@valid_else_key => @valid_else_value}
    Dumy.query_from_filtr({@invalid_else_key=>@valid_else_value}).where_values_hash.must_be :==, {}
    Dumy.query_from_filtr({@valid_json_key=>@valid_json_value}, @field_to_exclude).to_sql.wont_be :=~, /own_phone/
    Dumy.query_from_filtr({@valid_json_key=>@valid_json_value},  "own_phone[number]").to_sql.wont_be :=~, /own_phone->>'number'/
  end
  
  it 'query_from_filtr must not change original data hash' do
    original = {@valid_else_key=>@valid_else_value}
    provided = {@valid_else_key=>@valid_else_value}
    Dumy.query_from_filtr(provided, 'user_id')
    original.must_be :==, provided
  end
  
  it 'query_hash_from_filtr_with_all_keys_excluded must give hash of queries with key as excluded field' do
    Dumy.methods.include?(:query_hash_from_filtr_with_all_keys_excluded).must_be :==, true
    data = {@valid_else_key=>@valid_else_value, @valid_json_key=>@valid_json_value}
    Dumy.query_hash_from_filtr_with_all_keys_excluded(data).keys.must_be :==, ["user_id", "own_phone[number]", "own_phone[operator_id]"] 
    Dumy.query_hash_from_filtr_with_all_keys_excluded(data).values[0].kind_of?(ActiveRecord::Relation).must_be :==, true  
  end
end
