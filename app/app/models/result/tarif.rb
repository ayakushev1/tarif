# == Schema Information
#
# Table name: result_tarifs
#
#  id       :integer          not null, primary key
#  run_id   :integer
#  tarif_id :integer
#

class Result::Tarif < ActiveRecord::Base
  extend BatchInsert
  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id
  belongs_to :tarif, :class_name =>'TarifClass', :foreign_key => :tarif_id

end

