class Demo::HistoryParserController < Customer::HistoryParserController

  def check_if_parsing_params_in_session
    if !session[:filtr] or session[:filtr]['user_params_filtr'].blank?
      saved_user_params = parsing_params_saver('user_params').results || {}
      session[:filtr] ||= {}; session[:filtr]['user_params_filtr'] ||= {}
      session[:filtr]['user_params_filtr'] = if saved_user_params['history_parser_user_params'].blank?
        {'own_phone_number' => '100000000', 
         'operator_id' => 1030, 
         'region_id' => 1238, 
         'country_id' => 1100,
         'accounting_period_month' => 1,
         'accounting_period_year' => 2014,
         }
      else
        saved_user_params
      end
    end

    if !session[:filtr] or session[:filtr]['parsing_params_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['parsing_params_filtr'] ||= {}
      session[:filtr]['parsing_params_filtr']  = {
        'calculate_on_background' => 'true',
        'save_processes_result_to_stat' => 'true',
        'file_upload_remote_mode' => 'false',
        'file_upload_turbolink_mode' => 'false',
        'file_upload_form_method' => 'post',
        'file_upload_max_size' => 1,
        'call_history_max_line_to_process' => 5000,
        'allowed_call_history_file_types' => ['html'],
        'background_update_frequency' => 100,
      } 
    end
  end

end
