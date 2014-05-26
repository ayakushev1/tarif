require 'test_helper'

describe 'Service::Criterium' do
  describe 'seed data' do
  end
  
  describe 'method where_hash' do
    before do
       Customer::Call.create(:base_subservice_id => 50,
        :own_phone => {"number" => "7000000000", "operator_id" => "1025", "region_id" =>"1501"},
        :partner_phone => {"number" => "79999999999", "operator_id"=>"1025", "region_id" => "1501"},
        :connect => {"operator_id" => "1025", "region_id" =>"1501"},
        :description => {"time" => "2014-01-01T10:00:13.000+00:00", "duration" => 30.270091687653668, "volume" => nil, "volume_unit_id" => nil}  
       )

      @crit = Service::Criterium.find(10)
      @fq_tarif_operator_id = _beeline
      @fq_tarif_region_id = _moscow
    end

    it 'must exists' do
      Service::Criterium.new.must_respond_to(:where_hash)
    end 
    
    it 'must return where part of sql as string' do
#      ParameterHelper::ParameterPresenter.new( Parameter.find(_fq_tarif_operator_id), self,  {:integer => _mobile} ).value.must_be :==, true
      @crit.where_hash(self).must_be_kind_of(String)
    end
    
    describe 'various input choices' do
      it 'must produce options' do
        Service::Criterium.new(
          :id => 10 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field,
          :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => 1).
          where_hash(self).must_be :==, "(customer_calls.connect->>'operator_id' = '#{@fq_tarif_operator_id}')"

        Service::Criterium.new(
          :id => 30 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
          :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => 3).
          where_hash(self).must_be :==, "(customer_calls.connect->>'region_id' = any('{#{Relation.home_regions(@fq_tarif_operator_id, @fq_tarif_region_id)}}') )"

        Service::Criterium.new(
          :id => 40 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
          :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 4).
          where_hash(self).must_be :==, "(customer_calls.connect->>'country_id' = '#{Category.find(@fq_tarif_region_id).parent_id}')"

        Service::Criterium.new(
          :id => 61 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
          :eval_string => 'Relation.operator_country_groups(nil, 1600)', :service_category_id => 6).
          where_hash(self).must_be :==, "(customer_calls.connect->>'country_id' = any('{#{Relation.operator_country_groups(nil, 1600)}}') )"
          
#          ParameterHelper::ParameterPresenter.new( Parameter.find(49), self,  {:integer => _mobile} ).value.must_be :==, true

        Service::Criterium.new(
          :id => 1921 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => {:integer => _mobile}, :service_category_id => 192).
          where_hash(self).must_be :==, "(customer_calls.partner_phone->>'operator_type_id' = '#{_mobile}')"

      end
      
    end
  end
  

end
