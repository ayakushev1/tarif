Comparison::Optimization.find_or_create_by(:id => 0).update(
  :name => 'base_rank', :description => "all_operators_no_tarif_options_only_own_and_home_regions_rouming", 
  :publication_status_id => 100, :publication_order => 10000, :optimization_type_id => 0)

Comparison::Optimization.find_or_create_by(:id => 1).update(
  :name => 'Базовый рейтинг тарифов сотовой связи', 
  :description => "Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.\
    В состав услуг включены услуги только в пределах собственного и домашнего региона. \ 
    Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru \
    для каждого тарифа и для каждой корзины", 
  :publication_status_id => 102, :publication_order => 100, :optimization_type_id => 1)

Comparison::Optimization.find_or_create_by(:id => 2).update(
  :name => 'Основной рейтинг тарифов сотовой связи', 
  :description => "Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.\
    В состав услуг включены услуги только в пределах России. \ 
    Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru \
    для каждого тарифа и для каждой корзины", 
  :publication_status_id => 102, :publication_order => 101, :optimization_type_id => 1)

Comparison::Optimization.find_or_create_by(:id => 3).update(
  :name => 'Рейтинг лучших тарифов и опций для интернета при нахождении в собственном регионе', 
  :description => "Рейтинг подготовлен для различного уровня потребления интернета. \
    Звонки учтены на минимальном уровне 5 мин в месяц. \
    Другие мобильные услуги (смс и ммс) не учитывались. \
    В состав услуг включены услуги только в пределах региона подключения. \ 
    Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.", 
  :publication_status_id => 102, :publication_order => 200, :optimization_type_id => 2)

Comparison::Optimization.find_or_create_by(:id => 4).update(
  :name => 'Рейтинг лучших тарифов и опций для интернета при путешествии по России', 
  :description => "Рейтинг подготовлен для различного уровня потребления интернета. \
    Звонки учтены на минимальном уровне 5 мин в месяц. \
    Другие мобильные услуги (смс и ммс) не учитывались. \
    В состав услуг включен интернет только за пределах региона подключения, 100 % по России. \ 
    Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.", 
  :publication_status_id => 100, :publication_order => 201, :optimization_type_id => 3)

Comparison::Optimization.find_or_create_by(:id => 5).update(
  :name => 'Рейтинг лучших тарифов и опций для звонков при нахождении в собственном регионе', 
  :description => "Рейтинг подготовлен для разного количество минут. \
    Другие мобильные услуги (интернет, смс и ммс) не учитывались. \
    В состав услуг включены звонки только в пределах региона подключения. \ 
    Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.", 
  :publication_status_id => 102, :publication_order => 150, :optimization_type_id => 2)

