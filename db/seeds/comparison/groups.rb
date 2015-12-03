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


Comparison::Group.find_or_create_by(:id => 15).update(:name => 'Малая корзина', :optimization_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 20)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 21)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 22)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 23)


Comparison::Group.find_or_create_by(:id => 16).update(:name => 'Средняя корзина', :optimization_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 25)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 26)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 27)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 28)

Comparison::Group.find_or_create_by(:id => 17).update(:name => 'Дорогая корзина', :optimization_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 30)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 31)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 32)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 33)
