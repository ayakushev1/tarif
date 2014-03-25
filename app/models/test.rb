# == Schema Information
#
# Table name: tests
#
#  id      :integer          not null, primary key
#  name    :string(255)
#  user_id :integer
#

class Test < ActiveRecord::Base
end

