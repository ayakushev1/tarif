Service::CategoryGroup.delete_all
=begin
scg = []

scg << { :id => _scg_free_sum_duration, :name => 'free_sum_duration' }
scg << { :id => _scg_free_count_volume, :name => 'free_count_volume'}
scg << { :id => _scg_free_sum_volume, :name => 'free_sum_volume'}

Service::CategoryGroup.transaction do
  Service::CategoryGroup.create(scg)
end

=end
