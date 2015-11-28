Comparison::Group.find_or_create_by(:id => 0).update(:name => 'Студенты', :optimization_id => 0)

Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 0)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 0, :call_run_id => 3)

Comparison::Group.find_or_create_by(:id => 1).update(:name => 'Пенсионеры', :optimization_id => 0)

Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 1, :call_run_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 1, :call_run_id => 6)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 1, :call_run_id => 7)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 1, :call_run_id => 8)



Comparison::Group.find_or_create_by(:id => 10).update(:name => 'Студенты', :optimization_id => 1)

Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 0)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 3)

Comparison::Group.find_or_create_by(:id => 11).update(:name => 'Пенсионеры', :optimization_id => 1)

Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 6)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 7)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 8)
