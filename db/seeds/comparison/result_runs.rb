Result::Run.find_or_create_by(:id => 0).update(:user_id => nil, :comparison_group_id => 0)
Result::Run.find_or_create_by(:id => 1).update(:user_id => nil, :comparison_group_id => 1)

