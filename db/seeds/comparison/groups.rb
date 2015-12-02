Comparison::Group.find_or_create_by(:id => 0).update(:name => 'Студенты', :optimization_id => 0)
Comparison::Group.find_or_create_by(:id => 1).update(:name => 'Пенсионеры', :optimization_id => 0)


Comparison::Group.find_or_create_by(:id => 10).update(:name => 'Малая корзина', :optimization_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 0)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 3)


Comparison::Group.find_or_create_by(:id => 11).update(:name => 'Средняя корзина', :optimization_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 6)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 7)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 8)

Comparison::Group.find_or_create_by(:id => 12).update(:name => 'Дорогая корзина', :optimization_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 10)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 11)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 12)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 13)
