class Customer::OptimizationResultMover < ActiveType::Object
  attribute :article_id, :integer
  attribute :user_id_copy_from, :integer, default:  1
  attribute :user_id_copy_to, :integer, default:  0
  attribute :data_to_copy, default:  ['minor_results', 'prepared_final_tarif_results']
        
  validates_numericality_of :article_id, :user_id_copy_from, :user_id_copy_to
  validates_presence_of :article_id, :user_id_copy_from, :user_id_copy_to, :data_to_copy
  
  def initialize(init_values = {})
    super
  end 
  
  def copy
    delete_customer_stat
    insert_customer_stat
  end
  
  def insert_customer_stat
    data_to_insert = customer_stat_records_to_copy
#    raise(StandardError, data_to_insert.map{|a| a[:user_id]})
    Customer::Stat.create(data_to_insert)    
  end
  
  def customer_stat_records_to_copy
    result = []
    Customer::Stat.where(:user_id => user_id_copy_from, :result_name => data_to_copy).
                   where("(result_key->'demo_result'->>'id')::integer is null").each do |record|
      result << record.attributes.symbolize_keys.except(:id).
                  merge({:user_id => user_id_copy_to, :result_key => {:demo_result => {:id => article_id}}})
#      raise(StandardError, result[0].keys)            
    end
#    raise(StandardError, result) 
    result
  end
  
  def delete_customer_stat
    Customer::Stat.where(:user_id => user_id_copy_to, :result_name => data_to_copy).
                   where("result_key->'demo_result'->>'id' = ?", (article_id || '').to_s).
                   delete_all
  end
  
  def persisted?
    false
  end  
end

