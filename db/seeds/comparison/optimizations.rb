Comparison::Optimization.find_or_create_by(:id => 0).update(
  :name => 'base_rank', :description => "all_operators_no_tarif_options_only_own_and_home_regions_rouming", 
  :publication_status_id => 100, :publication_order => 10000, :optimization_type_id => 0)

Comparison::Optimization.find_or_create_by(:id => 1).update(
  :name => 'base_rank', :description => "all_operators_all_tarif_optionss_all_rouming", 
  :publication_status_id => 100, :publication_order => 10000, :optimization_type_id => 1)

