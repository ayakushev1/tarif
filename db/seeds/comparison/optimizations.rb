Comparison::Optimization.find_or_create_by(:id => 0).update(
  :name => 'base_rank', :description => "all_operators_no_tarif_options_only_own_and_home_regions_rouming", 
  :publication_status_id => 100, :publication_order => 10000, :optimization_type_id => 0)

Comparison::Optimization.find_or_create_by(:id => 1).update(
  :name => 'Базовый рейтинг тарифов сотовой связи на основе методологии ОЭСР', 
  :description => "Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.\
    В состав услуг включены услуги только в пределах собственного и домашнего региона. \ 
    Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru \
    для каждого тарифа и для каждой корзины", 
  :publication_status_id => 100, :publication_order => 10000, :optimization_type_id => 1)

