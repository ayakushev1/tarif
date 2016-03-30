# == Schema Information
#
# Table name: comparison_group_call_runs
#
#  id                  :integer          not null, primary key
#  comparison_group_id :integer
#  call_run_id         :integer
#

class Comparison::GroupCallRun < ActiveRecord::Base
  belongs_to :comparison_group, :class_name =>'Comparison::Group', :foreign_key => :comparison_group_id
  belongs_to :call_run, :class_name =>'Customer::CallRun', :foreign_key => :call_run_id
 
end

