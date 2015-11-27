Comparison::Optimization.find_or_create_by(:id => 0).update(
  :name => 'base_rank', :description => "all_operators, tarifs_only, own_and_home_regions for students", 
  :publication_status_id => 100, :publication_order => 10000, :optimization_type_id => 0)

