Comparison::Group.find_or_create_by(:id => 0).update(:name => 'Студенты', :optimization_id => 0)

Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 0)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 3)
