Result::Run.find_or_create_by(:id => 0).update(:user_id => nil, :comparison_group_id => 0, :call_run_id => nil)
Result::Run.find_or_create_by(:id => 1).update(:user_id => nil, :comparison_group_id => 1, :call_run_id => nil)

Result::Run.find_or_create_by(:id => 10).update(:user_id => nil, :comparison_group_id => 10, :call_run_id => nil)
Result::Run.find_or_create_by(:id => 11).update(:user_id => nil, :comparison_group_id => 11, :call_run_id => nil)
Result::Run.find_or_create_by(:id => 12).update(:user_id => nil, :comparison_group_id => 12, :call_run_id => nil)
