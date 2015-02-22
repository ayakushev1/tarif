#TODO use include ActiveModel::Model with attr_accessor to imitate ActiveRecord::Base class
#TODO use edit.html.ruby instead of edit.html.erb to use plain ruby code
#TODO using #extending (e.g. ActiveRecord::QueryMethods)

#TODO Создание публичного сайта
#TODO   Полная версия пользовательского сайта
#TODO     Дизайн
#TODO Добавить robots.txt 
#TODO Добавить анализ поведения пользователей (статистку и обязательно сколько раз пользователи пользовались основными сервисами)
    
#TODO Глобальные задач
#TODO добавить анализ чувствительности (исходя из известных ключевых точках тарифов)


#TODO Добавить форму письма администратору, и соответствующую обработку писем с сохранением их в БД в специальную таблицу 
#TODO Проверить что обновление счетчиков количества оставшихся расчетов пользователей изменяются до самих расчетов
#TODO Добавить возможность расчета парсинга и моделирования через delayed_job
#TODO 
#TODO 
#TODO 
#TODO 
#TODO 
#TODO 
#TODO Определиться когда использовать платежи за подключение опций и тарифов и внести изменения 
#TODO Определиться когда считать опции с лимитами (пока сделал все опции безлимитными, что на самом деле ускорило расчеты tarif_results)
#TODO Добавить многомесячный расчет (во время парсинга объединяешь результаты)    
#TODO Добавить генерацию модели поведения на основе многомесячной детализации

#TODO Улучшающие задачи по работе сайта

#TODO сделать проверку на отрицательное значение price_value и вывод сообщения об ошибке
#TODO Понять почему кол-во минут в основных расчетах и в call-stat отличается
#TODO Разобраться все-таки как зависить потребление памяти от использование переменных (где (в контроллере или хелпере))(как влияет обнуление таких переменных)
#TODO Проверить что в катерориях везде используется @tarif_operator_id равный текущему рассчитываемому оператору 
#TODO Добавить вывод сообщений и ошибок в tarif_optimizators_controller
#TODO Убрать :result in при сохранении и извлечении из customer_stats
#TODO Добавить сохранение результатов расчета тарифов в БД для использования пользователем (или для последующего анализа). Сохранять не все вычисления, а только нужные.
#TODO Добавить обработку многовариантного выбора в javascript 
#TODO добавить удаление звонков из БД после расчета тарифов или их перенос в архивную таблицу
#TODO Сделать более мелкое (отдельных частей страницы сайта) обновление ajax

#TODO Улучшающие задачи по оптимизации тарифов
#TODO Добавить поиск всех наборов тарифов которые близки к оптимальному (повторный расчет с изменной оценкой потенциально лучшего тарифа на какой-то процент)    
#TODO Добавить учет возможности отключения сервисов с ненулевым подключением и ненулевым ежедневным платежом которые подключаются при первом использовании (as everywhere_as_home)
#TODO Оценить влияние количества записей в customer_calls на скорость расчетов



#TODO Менее приоритетные
#TODO Добавить ввод и расчет цен регионов
#TODO Добавить обработчик заданий
#TODO Придумать как разделить development and production calculation engine
#TODO Перевести как можно больше вычислений в БД

#TODO Учет сколько пользователей рассчитывают тариф
#TODO Учет сколько пользователей online
#TODO Добавить систему авторизации devise
#TODO Добавить почтовый сервер
#TODO Разработать workflow для различных процессов

  