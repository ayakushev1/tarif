#TODO Добавить автовыбор описания подбора тарифа, если пустой
#TODO Выделить кнопки выбора модели поведения при моделировании
#TODO Убрать кнопки, на которые не надо нажимать пока идут расчеты
#TODO Уведомления об ошибке админа
#TODO Подумать вернуть ахой
#TODO Выбор рейтинга на лендинге
#TODO Синхронизация корзин рейтингов и начальных параметров для моделирования
#TODO Задать наводящие вопросы для выбора рекомендаций
#TODO Добавить выбор региона
#TODO Добавить хлебные крошки
#TODO Добавить ЧПУ
#TODO
#TODO
#TODO
#TODO
#TODO
#TODO
#TODO
#TODO


    
#TODO Глобальные задач
#TODO добавить анализ чувствительности (исходя из известных ключевых точках тарифов)
#TODO Добавить возможность расчета парсинга и моделирования через delayed_job

#TODO Определиться когда считать опции с лимитами (пока сделал все опции безлимитными, что на самом деле ускорило расчеты tarif_results)
#TODO Добавить многомесячный расчет (во время парсинга объединяешь результаты)    
#TODO Добавить генерацию модели поведения на основе многомесячной детализации

#TODO Улучшающие задачи по работе сайта

#TODO Разобраться все-таки как зависить потребление памяти от использование переменных (где (в контроллере или хелпере))(как влияет обнуление таких переменных)
#TODO добавить удаление звонков из БД после расчета тарифов или их перенос в архивную таблицу

#TODO Улучшающие задачи по оптимизации тарифов
#TODO Добавить поиск всех наборов тарифов которые близки к оптимальному (повторный расчет с изменной оценкой потенциально лучшего тарифа на какой-то процент)    
#TODO Добавить учет возможности отключения сервисов с ненулевым подключением и ненулевым ежедневным платежом которые подключаются при первом использовании (as everywhere_as_home)
#TODO Оценить влияние количества записей в customer_calls на скорость расчетов



#TODO Менее приоритетные
#TODO Добавить ввод и расчет цен регионов
#TODO Придумать как разделить development and production calculation engine
#TODO Перевести как можно больше вычислений в БД

#TODO Учет сколько пользователей рассчитывают тариф
#TODO Учет сколько пользователей online
#TODO Разработать workflow для различных процессов

  