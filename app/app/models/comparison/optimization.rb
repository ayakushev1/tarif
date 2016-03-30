# == Schema Information
#
# Table name: comparison_optimizations
#
#  id                    :integer          not null, primary key
#  name                  :string
#  description           :text
#  publication_status_id :integer
#  publication_order     :integer
#  optimization_type_id  :integer
#  slug                :string
#

class Comparison::Optimization < ActiveRecord::Base
  include FriendlyIdHelper
  friendly_id :slug_candidates, use: [:slugged]#, :finders]
  
  belongs_to :publication_status, :class_name =>'Content::Category', :foreign_key => :publication_status_id
  belongs_to :type, :class_name =>'Comparison::OptimizationType', :foreign_key => :optimization_type_id
  has_many :groups, :class_name =>'Comparison::Group', :foreign_key => :optimization_id
  has_many :result_runs, through: :groups
  
  scope :draft, -> {where(:publication_status_id => 100)}
  scope :reviewed, -> {where(:publication_status_id => 101)}
  scope :published, -> {where(:publication_status_id => 102)}
  scope :hidden, -> {where(:publication_status_id => 103)}

  def slug_candidates
    [
      :short_name_for_slug,
      :name,
    ]
  end
  
  def short_name_for_slug
    max_word_in_slug = 6;  excluded_short_word_length = 3;
    result = []
    i = 0
    name.split(" ").each do |word|
      result << word
      i += 1 if word.length > excluded_short_word_length
    end if name
    result[0..max_word_in_slug].join(" ")
  end

  def self.clean_comparison_results
    all.collect{|optimization| optimization.clean_comparison_results}
  end
  
  def clean_comparison_results
    groups.collect{|group| group.clean_comparison_results}
  end
  
  def self.update_comparison_results
    all.collect{|optimization| optimization.update_comparison_results}
  end
  
  def update_comparison_results
    groups.collect{|group| group.update_comparison_results}
  end
  
  def self.generate_calls(only_new = true, test = false)   
#    raise(StandardError, only_new) 
    all.collect{|optimization| optimization.generate_calls(only_new, test)}   
  end
  
  def generate_calls(only_new = true, test = false)    
    groups.collect{|group| group.generate_calls(only_new, test) }   
  end
  
  def self.calculate_optimizations(calculation_options)    
    result = {}
    all.collect{|optimization| result[optimization.name] = optimization.calculate_optimizations(calculation_options)}
    result      
  end
  
  def calculate_optimizations(calculation_options = default_calculation_options)
    only_new = calculation_options[:only_new]; test = calculation_options[:test]; update_comparison = calculation_options[:update_comparison]; tarifs = calculation_options[:tarifs];

    optimization_type = type.attributes.symbolize_keys #.deep_symbolize_keys
    result = []
    groups.each do |group|
#      raise(StandardError, [only_new, !update_comparison, group.result.try(:place).try(:"0").try(:blank?), 
#        (only_new and !update_comparison and !group.result.try(:place).try(:"0").try(:blank?))].join("\n"))
      next if false and only_new and !update_comparison and !group.result.try(:place).try(:"0").try(:blank?)
      if_clean_output_results = update_comparison ? true : false
      group.call_runs.each do |call_run|        
        local_options = {
          :call_run_id => call_run.id,
          :accounting_period => accounting_period_by_call_run_id(call_run.id),
          :result_run_id => group.result_run.id,
          :operators => [call_run.operator_id],
          :for_service_categories => optimization_type[:for_service_categories],
          :for_services_by_operator => optimization_type[:for_services_by_operator],
          :comparison_group_id => group.id,
          :result_run_name => "#{name}, #{group.name}"
        }
        optimization_type_options = optimization_type.deep_merge(local_options)
        raise(StandardError, [
          Comparison::Optimization::Init.base_params(optimization_type_options)[:services_by_operator],
          Comparison::Optimization::Init.base_params(optimization_type_options).deep_merge({:services_by_operator => {:tarifs => tarifs}})[:services_by_operator],
          only_new,
          test,
          update_comparison,
          tarifs.to_s,
        ].join("\n\n")) if false
        
        options = Comparison::Optimization::Init.base_params(optimization_type_options).merge({:if_clean_output_results => if_clean_output_results})
        calculation_options = update_comparison ? Comparison::Optimization::Init.base_params(optimization_type_options).deep_merge({:services_by_operator => {:tarifs => tarifs}}) : options
        if_clean_output_results = false

        result << calculate_one_optimization(calculation_options, false)
        group.result_run.update_columns(result_run_update_options(options.merge(local_options))) 
      end
    end
    result
  end

  def calculate_one_optimization(options, test = false)    
    result = options[:calculation_choices].slice("result_run_id", "call_run_id")
    result.merge!(options[:services_by_operator].slice(:operators))
    return result if test
#    raise(StandardError, [options[:selected_service_categories]].join("\n"))
    true ? 
      TarifOptimization::TarifOptimizatorRunner.recalculate_with_delayed_job(options) :
      TarifOptimization::TarifOptimizatorRunner.recalculate_direct(options)
          
    result
  end
  
  def result_run_update_options(options)
    {
      :name => options[:result_run_name],
      :description => description,
      :user_id => nil,
      :run => 1,
      
      :call_run_id => nil, #options[:call_run_id],
      :accounting_period => options[:accounting_period],
      :optimization_type_id => 6,
      :optimization_params => options[:optimization_params],
      :calculation_choices => options[:calculation_choices],
      :selected_service_categories => options[:selected_service_categories],
      :services_by_operator =>  {}, #options[:services_by_operator],
      :temp_value => options[:temp_value],
      :service_choices => {},
      :services_select => {},
      :services_for_calculation_select => {},
      :service_categories_select => {},
      :comparison_group_id => options[:comparison_group_id]
    }
  end
  
  def default_calculation_options
    {:only_new => true, :test => false, :update_comparison => false, :tarifs => []}
  end

  def accounting_period_by_call_run_id(call_run_id)
    '1_2015'
  end

end

