Comparison::Group.find_or_create_by(:id => 0).update(:name => 'Студенты', :optimization_id => 0)
Comparison::Group.find_or_create_by(:id => 1).update(:name => 'Пенсионеры', :optimization_id => 0)

#For ОЭСР in home region rating
Comparison::Group.find_or_create_by(:id => 10).update(:name => 'Малая корзина (80 мин звонков, 110 смс)', :optimization_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 0)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 10, :call_run_id => 3)


Comparison::Group.find_or_create_by(:id => 11).update(:name => 'Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета)', :optimization_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 6)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 7)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 11, :call_run_id => 8)

Comparison::Group.find_or_create_by(:id => 12).update(:name => 'Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета)', :optimization_id => 1)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 10)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 11)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 12)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 12, :call_run_id => 13)

#For ОЭСР in own country rating
Comparison::Group.find_or_create_by(:id => 15).update(:name => 'Малая корзина (80 мин звонков, 110 смс, 10% поездки по России)', :optimization_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 20)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 21)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 22)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 15, :call_run_id => 23)


Comparison::Group.find_or_create_by(:id => 16).update(:name => 'Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета, 10% поездки по России)', :optimization_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 25)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 26)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 27)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 16, :call_run_id => 28)

Comparison::Group.find_or_create_by(:id => 17).update(:name => 'Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета, 10% поездки по России)', :optimization_id => 2)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 30)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 31)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 32)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 17, :call_run_id => 33)

#For internet in home region rating
Comparison::Group.find_or_create_by(:id => 20).update(:name => 'Объем потребления интернета 100 Мб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 20, :call_run_id => 40)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 20, :call_run_id => 41)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 20, :call_run_id => 42)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 20, :call_run_id => 43)

Comparison::Group.find_or_create_by(:id => 21).update(:name => 'Объем потребления интернета 300 Мб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 21, :call_run_id => 50)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 21, :call_run_id => 51)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 21, :call_run_id => 52)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 21, :call_run_id => 53)

Comparison::Group.find_or_create_by(:id => 22).update(:name => 'Объем потребления интернета 500 Мб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 22, :call_run_id => 60)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 22, :call_run_id => 61)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 22, :call_run_id => 62)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 22, :call_run_id => 63)

Comparison::Group.find_or_create_by(:id => 23).update(:name => 'Объем потребления интернета 1 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 23, :call_run_id => 70)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 23, :call_run_id => 71)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 23, :call_run_id => 72)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 23, :call_run_id => 73)

Comparison::Group.find_or_create_by(:id => 24).update(:name => 'Объем потребления интернета 2 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 24, :call_run_id => 80)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 24, :call_run_id => 81)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 24, :call_run_id => 82)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 24, :call_run_id => 83)

Comparison::Group.find_or_create_by(:id => 25).update(:name => 'Объем потребления интернета 3 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 25, :call_run_id => 90)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 25, :call_run_id => 91)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 25, :call_run_id => 92)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 25, :call_run_id => 93)

Comparison::Group.find_or_create_by(:id => 26).update(:name => 'Объем потребления интернета 5 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 26, :call_run_id => 100)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 26, :call_run_id => 101)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 26, :call_run_id => 102)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 26, :call_run_id => 103)

Comparison::Group.find_or_create_by(:id => 27).update(:name => 'Объем потребления интернета 10 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 27, :call_run_id => 110)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 27, :call_run_id => 111)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 27, :call_run_id => 112)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 27, :call_run_id => 113)

Comparison::Group.find_or_create_by(:id => 28).update(:name => 'Объем потребления интернета 15 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 28, :call_run_id => 120)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 28, :call_run_id => 121)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 28, :call_run_id => 122)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 28, :call_run_id => 123)

Comparison::Group.find_or_create_by(:id => 29).update(:name => 'Объем потребления интернета 20 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 29, :call_run_id => 130)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 29, :call_run_id => 131)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 29, :call_run_id => 132)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 29, :call_run_id => 133)

Comparison::Group.find_or_create_by(:id => 30).update(:name => 'Объем потребления интернета 30 Гб', :optimization_id => 3)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 30, :call_run_id => 140)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 30, :call_run_id => 141)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 30, :call_run_id => 142)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 30, :call_run_id => 143)


#For internet in own country rating
Comparison::Group.find_or_create_by(:id => 31).update(:name => 'Объем потребления интернета 100 Мб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 31, :call_run_id => 150)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 31, :call_run_id => 151)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 31, :call_run_id => 152)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 31, :call_run_id => 153)

Comparison::Group.find_or_create_by(:id => 32).update(:name => 'Объем потребления интернета 300 Мб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 32, :call_run_id => 160)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 32, :call_run_id => 161)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 32, :call_run_id => 162)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 32, :call_run_id => 163)

Comparison::Group.find_or_create_by(:id => 33).update(:name => 'Объем потребления интернета 500 Мб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 33, :call_run_id => 170)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 33, :call_run_id => 171)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 33, :call_run_id => 172)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 33, :call_run_id => 173)

Comparison::Group.find_or_create_by(:id => 34).update(:name => 'Объем потребления интернета 1 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 34, :call_run_id => 180)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 34, :call_run_id => 181)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 34, :call_run_id => 182)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 34, :call_run_id => 183)

Comparison::Group.find_or_create_by(:id => 35).update(:name => 'Объем потребления интернета 2 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 35, :call_run_id => 190)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 35, :call_run_id => 191)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 35, :call_run_id => 192)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 35, :call_run_id => 193)

Comparison::Group.find_or_create_by(:id => 36).update(:name => 'Объем потребления интернета 3 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 36, :call_run_id => 200)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 36, :call_run_id => 201)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 36, :call_run_id => 202)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 36, :call_run_id => 203)

Comparison::Group.find_or_create_by(:id => 37).update(:name => 'Объем потребления интернета 5 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 37, :call_run_id => 210)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 37, :call_run_id => 211)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 37, :call_run_id => 212)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 37, :call_run_id => 213)

Comparison::Group.find_or_create_by(:id => 38).update(:name => 'Объем потребления интернета 10 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 38, :call_run_id => 220)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 38, :call_run_id => 221)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 38, :call_run_id => 222)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 38, :call_run_id => 223)

Comparison::Group.find_or_create_by(:id => 39).update(:name => 'Объем потребления интернета 15 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 39, :call_run_id => 230)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 39, :call_run_id => 231)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 39, :call_run_id => 232)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 39, :call_run_id => 233)

Comparison::Group.find_or_create_by(:id => 40).update(:name => 'Объем потребления интернета 20 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 40, :call_run_id => 240)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 40, :call_run_id => 241)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 40, :call_run_id => 242)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 40, :call_run_id => 243)

Comparison::Group.find_or_create_by(:id => 41).update(:name => 'Объем потребления интернета 30 Гб', :optimization_id => 4)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 41, :call_run_id => 250)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 41, :call_run_id => 251)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 41, :call_run_id => 252)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 41, :call_run_id => 253)


#Calls only in own region
Comparison::Group.find_or_create_by(:id => 50).update(:name => 'Общая длительность звонков 120 минут', :optimization_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 50, :call_run_id => 300)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 50, :call_run_id => 301)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 50, :call_run_id => 302)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 50, :call_run_id => 303)

Comparison::Group.find_or_create_by(:id => 51).update(:name => 'Общая длительность звонков 300 минут', :optimization_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 51, :call_run_id => 310)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 51, :call_run_id => 311)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 51, :call_run_id => 312)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 51, :call_run_id => 313)

Comparison::Group.find_or_create_by(:id => 52).update(:name => 'Общая длительность звонков 600 минут', :optimization_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 52, :call_run_id => 320)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 52, :call_run_id => 321)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 52, :call_run_id => 322)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 52, :call_run_id => 323)

Comparison::Group.find_or_create_by(:id => 53).update(:name => 'Общая длительность звонков 1000 минут', :optimization_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 53, :call_run_id => 330)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 53, :call_run_id => 331)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 53, :call_run_id => 332)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 53, :call_run_id => 333)

Comparison::Group.find_or_create_by(:id => 54).update(:name => 'Общая длительность звонков 1500 минут', :optimization_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 54, :call_run_id => 340)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 54, :call_run_id => 341)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 54, :call_run_id => 342)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 54, :call_run_id => 343)

Comparison::Group.find_or_create_by(:id => 55).update(:name => 'Общая длительность звонков 2000 минут', :optimization_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 55, :call_run_id => 350)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 55, :call_run_id => 351)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 55, :call_run_id => 352)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 55, :call_run_id => 353)

Comparison::Group.find_or_create_by(:id => 56).update(:name => 'Общая длительность звонков 3000 минут', :optimization_id => 5)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 56, :call_run_id => 360)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 56, :call_run_id => 361)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 56, :call_run_id => 362)
Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => 56, :call_run_id => 363)
