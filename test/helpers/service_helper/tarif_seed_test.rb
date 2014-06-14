require 'test_helper'
tarif_file_name = 'mts/tarif_options/everywhere_as_home.rb'
#Dir[Rails.root.join("db/seeds/tarifs/#{tarif_file_name}")].each { |f| require f }
#Dir[Rails.root.join("db/seeds/tarif_tests/#{tarif_file_name}")].each { |f| require f }

describe ServiceHelper::TarifSeedTester do
  class Foo
    @@init_tarif_optimizator_for_tarif_seed_test = nil
    @@tarif_seed_tester = nil
  end

  before do
    unless Foo.class_variable_get(:@@init_tarif_optimizator_for_tarif_seed_test)
      options = {:operators => [1030], :tarifs => [[203]], :tarif_sets => [[[203]]], :common_services => [[[]]], :tarif_options => [[[[nil]]]]}
#      options = {:operators => [1030], :tarifs => [[203]], :tarif_sets => [[[276, 277, 203]]], :common_services => [[[276, 277]]], :tarif_options => [[[[nil, 283, 293]]]]}
      tarif_seed_tester = ServiceHelper::TarifSeedTester.new(options)
      tarif_seed_tester.tarif_optimizator.calculate_one_operator_tarifs(0)
      Foo.class_variable_set(:@@tarif_seed_tester, tarif_seed_tester)
      Foo.class_variable_set(:@@init_tarif_optimizator_for_tarif_seed_test, 'done')
    end
    @tarif_optimizator = Foo.class_variable_get(:@@tarif_seed_tester).tarif_optimizator
    @tarif_set_id = '203'
#    @tarif_set_id = '276_277_203_293'
    @tarif_id = 203
    @prev_service_call_ids = @tarif_optimizator.prev_service_call_ids[@tarif_set_id][@tarif_id]
  end

  it 'must init Customer::Call' do
#    @tarif_optimizator.tarif_results[@tarif_set_id][@tarif_id].must_be :==, true
    Customer::Call.count.must_be :==, 0
  end

  describe 'service_category_tarif_class' do
    it 'must has at least one calls record' do
      raise(StandardError, [@tarif_optimizator.tarif_results_ord.keys ]) if !@tarif_optimizator or !@tarif_optimizator.tarif_results_ord or !@tarif_optimizator.tarif_results_ord[@tarif_set_id] or !@tarif_optimizator.tarif_results_ord[@tarif_set_id][@tarif_id]
      @tarif_optimizator.tarif_results_ord[@tarif_set_id][@tarif_id].each do |key, details_by_order|
        details_by_order['price_values'].each do |tarif_result_detail|
          tarif_classes_category_where_hash_sql = if tarif_result_detail['service_category_tarif_class_id'] > 1 
            @tarif_optimizator.query_constructor.tarif_classes_category_where_hash(tarif_result_detail['service_category_tarif_class_id'])
          else
#            raise(StandardError, tarif_result_detail)
#            @tarif_optimizator.query_constructor.joined_tarif_classes_category_where_hash(tarif_result_detail['service_category_tarif_class_ids'])
          end
          
#          tarif_classes_category_where_hash_sql.must_be :==, true if tarif_result_detail['service_category_name'] == '_sctcg_mts_sic_1_calls_to_russia'

          if tarif_result_detail['call_id_count'] == 0 
            case tarif_result_detail['service_category_name']
            when 'one_time_tarif_switch_on'
              tarif_result_detail['price_value'].must_be :==, 0
            when 'periodic_monthly_fee'
              tarif_result_detail['price_value'].must_be :==, 900
            when 'periodic_day_fee'
              tarif_result_detail['price_value'].must_be :==, 150
            else
              tarif_classes_category_where_hash_sql.must_be :==, true, [tarif_result_detail].join("\n") 
#              tarif_classes_category_where_hash_sql.must_be :==, true, [tarif_result_detail, @prev_service_call_ids].join("\n") 
            end
          end
        end  
      end
    end

    it 'must sum all calls records and should not be duplicated call_ids' do
      sum = 0; call_ids = []; ids_and_names = []; ids_to_add = []
      @tarif_set_id.split('_').each do |tarif_id|
        @tarif_optimizator.tarif_results_ord[@tarif_set_id][tarif_id.to_i].each do |key, details_by_order|
          details_by_order['price_values'].each do |tarif_result_detail|
#            raise(StandardError, tarif_result_detail) unless tarif_result_detail['service_category_tarif_class_id'] 
            tarif_classes_category_where_hash_sql = if tarif_result_detail['service_category_tarif_class_id'] > 0 
              @tarif_optimizator.query_constructor.tarif_classes_category_where_hash(tarif_result_detail['service_category_tarif_class_id'])
            else
              @tarif_optimizator.query_constructor.joined_tarif_classes_category_where_hash(tarif_result_detail['service_category_tarif_class_ids']) if tarif_result_detail['service_category_tarif_class_ids']
            end
            
            

            ids_to_add = (tarif_result_detail['call_ids'] || []).flatten.compact
            ids_and_names << {:ids_to_add => ids_to_add, :service_category_name => tarif_result_detail['service_category_name']}
#            raise(StandardError, [tarif_result_detail, tarif_classes_category_where_hash_sql].join("\n") ) if tarif_result_detail['service_category_name'] == '_sctcg_mts_europe_sms_outcoming'
            if  tarif_result_detail['service_category_tarif_class_id'] > -1
#              (ids_to_add & call_ids).count.must_be :==, 0, ['duplicated:', ids_to_add & call_ids, ids_and_names, tarif_classes_category_where_hash_sql, tarif_result_detail['service_category_name']].join("\n") 
#              (ids_to_add & call_ids).count.must_be :==, 0, [ids_to_add & call_ids, tarif_classes_category_where_hash_sql, tarif_result_detail['service_category_name']].join("\n") 
            end
            call_ids = (call_ids + ids_to_add).flatten.compact.uniq
            call_ids.include?('mms_outcoming').must_be :==, false, [tarif_result_detail, nil, (tarif_result_detail['call_ids'] || []).flatten.compact].join("\n") 
          end  
        end
      end
      
      ids_not_covered = Customer::Call.pluck(:id) - call_ids
      ids_over_covered = call_ids - Customer::Call.pluck(:id)
      ids_not_covered.count.must_be :==, 0, ['ids_not_covered: ', ids_not_covered, ids_over_covered]#.join("\n") 
      ids_over_covered.count.must_be :==, 0, ['ids_over_covered: ', ids_over_covered]#.join("\n") 
    end

    it 'should not be duplicated service_category_tarif_class_id or service_category_group_id for each service_id and formula_order' do
      @tarif_set_id.split('_').each do |tarif_id|
        @tarif_optimizator.tarif_results_ord[@tarif_set_id][tarif_id.to_i].each do |key, details_by_order|
          service_category_tarif_class_ids = [], service_category_group_ids = []
          details_by_order['price_values'].each do |tarif_result_detail|
            service_category_tarif_class_ids.include?(tarif_result_detail['service_category_tarif_class_id']).must_be :==, false, tarif_result_detail['service_category_tarif_class_id']
            service_category_tarif_class_ids << tarif_result_detail['service_category_tarif_class_id'] unless tarif_result_detail['service_category_tarif_class_id'] == -1

            service_category_group_ids.include?(tarif_result_detail['service_category_group_id']).must_be :==, false, tarif_result_detail['service_category_group_id']
            service_category_group_ids << tarif_result_detail['service_category_group_id'] unless tarif_result_detail['service_category_group_id'] == -1
          end  
        end
      end
    end

    it 'should not be service_id in tarif_set results that are not in tarif_set_ids' do
      @tarif_optimizator.tarif_results.each do |key, tarif_set|
        tarif_set.keys.count.must_be :==, key.split('_').count, [@tarif_optimizator.tarif_results.keys, key, tarif_set.keys].join("\n") 
      end      
      
    end

  end

end
#_sctcg_mts_sic_1_calls_to_rouming_country
#_sctcg_mts_sic_1_calls_to_russia
