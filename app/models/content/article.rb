# == Schema Information
#
# Table name: content_articles
#
#  id         :integer          not null, primary key
#  author_id  :integer
#  title      :string(255)
#  content    :json
#  type_id    :integer
#  status_id  :integer
#  key        :json
#  created_at :datetime
#  updated_at :datetime
#

class Content::Article < ActiveRecord::Base
  belongs_to :type, :class_name =>'::Category', :foreign_key => :type_id
  belongs_to :status, :class_name =>'::Category', :foreign_key => :status_id

  scope :demo_results, -> {where(:type_id => 1)}

  scope :draft, -> {where(:status_id => 100)}
  scope :reviewed, -> {where(:status_id => 101)}
  scope :published, -> {where(:status_id => 102)}
  scope :hidden, -> {where(:status_id => 103)}
  
end

