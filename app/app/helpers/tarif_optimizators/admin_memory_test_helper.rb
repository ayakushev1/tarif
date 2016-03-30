class TarifOptimizators::AdminMemoryTestHelper

  def init_for_memory_test
#    raise(StandardError, session[:filtr])
    @current_user ||= User.find(1)
    session[:filtr]['calculation_choices_filtr']['result_run_id'] = 4 #Result::Run.where(:user_id => 1).first.id if !session[:filtr]['calculation_choices_filtr']['result_run_id']
    session[:filtr]['calculation_choices_filtr']['call_run_id'] = 66 #Result::Run.where(:user_id => 1).first.id if !session[:filtr]['calculation_choices_filtr']['call_run_id']
    session[:filtr]['calculation_choices_filtr']['accounting_period'] = '1_2015' #Result::Run.where(:user_id => 1).first.id if !session[:filtr]['calculation_choices_filtr']['accounting_period']

    session[:filtr]['optimization_params_filtr'] ||= {} 
    session[:filtr]['optimization_params_filtr']  = Customer::Info::TarifOptimizationParams.default_values
    session[:filtr]['optimization_params_filtr']['calculate_on_background'] = 'false'
    session[:filtr]['optimization_params_filtr']['service_ids_batch_size'] = 1
    
#    session[:filtr]['services_select_filtr'] ||= {}
#    session[:filtr]['services_select_filtr']  = Customer::Info::ServicesSelect.info(1)

#    session[:filtr]['service_categories_select_filtr'] ||= {}
#    session[:filtr]['service_categories_select_filtr']  = Customer::Info::ServiceCategoriesSelect.info(1, :admin)
    
    session[:filtr]['service_choices_filtr']= {
      "tarifs" => {
        "tel" => [800, 801, 802, 805], 
        "bln" => [600, 601, 602, 603, 604, 605, 610, 611, 612, 613, 622, 623, 624], 
        "mgf" => [100, 101, 102, 103, 104, 105, 106, 107, 109, 110, 113], 
        "mts" => [
          200, 
          201, 
          202, 
          203, 204, 205, 206, 207, 208, 212, 213, 214
          ]}, 
      "tarif_options" => {
        "tel" => [890, 895, 840, 860, 861, 850, 880, 881, 882, 883, 884, 885, 886],  
        "bln" => [660, 661, 662, 663, 670, 671, 672, 673, 674, 720, 700, 701, 702, 680, 681, 682, 683, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739], 
        "mgf" => [400, 401, 402, 403, 404, 405, 406, 407, 410, 411, 412, 413, 430, 431, 432, 440, 441, 442, 443, 444, 445, 493, 450, 451, 452, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 470, 471, 472, 473, 489, 490, 491, 492, 475, 476, 477, 478, 479, 480, 481, 482, 484, 485, 486, 487, 488, 494, 495],
        "mts" => [288, 289, 290, 291, 292, 347, 294, 282, 283, 321, 322, 348, 323, 324, 325, 326, 295, 296, 305, 306, 307, 308, 333, 334, 335, 336, 337, 338, 339, 346, 349, 328, 329, 330, 331, 332, 281, 309, 293, 280, 302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 319, 320, 342, 343, 344, 345]}, 
      "common_services" => {
        "tel" => [830, 831, 832], 
        "bln" => [650, 651, 652, 653, 654, 655], 
        "mgf" => [174, 177, 178, 179], 
        "mts" => [276, 277, 312, 297]}  
    }
    

  end 

end
