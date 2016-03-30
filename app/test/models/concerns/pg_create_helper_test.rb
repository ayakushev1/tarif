require 'test_helper'

class DumyPGCreate < ActiveRecord::Base
  include PgCreateHelper
  self.table_name = 'customer_stats'
end

describe DumyPGCreate do
  describe 'method extract_hash_values_from_array' do
    it 'must work' do
      array_of_hashes = [ {:user_id => 1, :result => {:count => 11, :sum => 111} }, {:user_id => 2, :result => {:count => 22, :sum => 222} } ]
      DumyPGCreate.extract_hash_values_from_array(array_of_hashes, :result).must_be :==, [{:count=>11, :sum=>111}, {:count=>22, :sum=>222}]
    end  
  end
  
  describe 'method field_values' do
    it 'must work' do
      array_of_hashes = [ {:user_id => 1, :result => {:count => 11, :sum => 111} }, {:user_id => 2, :result => {:count => 22, :sum => 222} } ]
      second_keys = array_of_hashes[0][:result].keys  
      second_attrs = DumyPGCreate.extract_hash_values_from_array(array_of_hashes, :result)
      DumyPGCreate.field_values(second_attrs, second_keys).must_be :==, "( (0), (11), (111) ), ( (1), (22), (222) )"
    end  
  end
  
  describe 'method pg_json_create' do
    it 'must work for simple hash' do
      assert_difference('DumyPGCreate.count', 1) { DumyPGCreate.pg_json_create(:user_id => 1, :phone_number => '+7000000') }
    end
    
    it 'must work for simple array of hash' do
      assert_difference('DumyPGCreate.count', 2) do
         DumyPGCreate.pg_json_create([{:user_id => 1, :phone_number => '+7000000'}, {:user_id => 2, :phone_number => '+8000000'}]) 
      end
    end
    
    it 'must work for simple array of hash when one hash value is sql string' do
      assert_difference('DumyPGCreate.count', 1) do
         DumyPGCreate.pg_json_create({:user_id => 1, :phone_number => 'select count(*) from users'}) 
      end
      DumyPGCreate.last['phone_number'].must_be :==, User.count.to_s
    end
    
    it 'must work for simple hash when one hash value is hash' do
      assert_difference('DumyPGCreate.count', 1) do
         DumyPGCreate.pg_json_create({:user_id => 1, :result => {:count => 1} }) 
      end
      DumyPGCreate.last[:result]['count'].must_be :==, 1
    end
    
    it 'must work for array of hashes when one hash value is hash' do
      assert_difference('DumyPGCreate.count', 2) do
         DumyPGCreate.pg_json_create([{:user_id => 1, :result => {:count => 1} }, {:user_id => 2, :result => {:count => 2} }]) 
      end
      last_id = DumyPGCreate.last.id
      DumyPGCreate.find(last_id-1)[:result]['count'].must_be :==, 1
      DumyPGCreate.find(last_id)[:result]['count'].must_be :==, 2
    end
    
    it 'must work for array of hashes when one hash value is hash with more than one key' do
      create_array = [ {:user_id => 1, :result => {:count => 11, :sum => 111} }, {:user_id => 2, :result => {:count => 22, :sum => 222} } ]
#      DumyPGCreate.pg_json_create_sql(create_array).must_be :==, true
      assert_difference('DumyPGCreate.count', 2) do
         DumyPGCreate.pg_json_create(create_array) 
      end
      last_id = DumyPGCreate.last.id
      DumyPGCreate.find(last_id-1)[:result]['count'].must_be :==, 11
      DumyPGCreate.find(last_id)[:result]['count'].must_be :==, 22
      DumyPGCreate.find(last_id)[:result]['sum'].must_be :==, 222, DumyPGCreate.find(last_id)[:result]
    end
    
    it 'must work for array of hashes when one hash value is hash with sql value' do
      assert_difference('DumyPGCreate.count', 1) do
         DumyPGCreate.pg_json_create({:user_id => 1, :result => {:count => 'select count(id) from users'} }) 
      end
      DumyPGCreate.last[:result]['count'].must_be :==, User.count
    end
    
    it 'must work for array of hashes when one hash value is hash with nil value' do
      assert_difference('DumyPGCreate.count', 2) do
         DumyPGCreate.pg_json_create([{:user_id => 1, :result => {:count => 1} }, {:user_id => 2, :result => {:count => nil} }]) 
      end
    end
    
    
  end  

end
