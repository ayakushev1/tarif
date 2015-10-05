module SavableInSession::SessionInitializers

  def pagination_action
    request.path_info
  end
  
  private
  
  def init_session_for_filtrable(filtr_name)
    session[:filtr][filtr_name] ||= {}
  end
  
  def set_session_from_params_for_filtrable(filtr_name)    
    params_to_set = params.extract!(filtr_name)
#    raise(StandardError, [filtr_name, params_to_set, params]) if filtr_name == "services_for_calculation_select_filtr"
    params_to_set[filtr_name].each do |key, value|
      session[:pagination].each do |key_p, value_p|
        session[:pagination][key_p] = 1
      end if session[:filtr][filtr_name][key] != value
      
      session[:filtr][filtr_name][key] = value
    end if params_to_set[filtr_name]
  end

  def init_session_for_formable(formable)
    session[:form][formable.form_name] ||= {}
  end

  def set_session_from_params_for_formable(formable)
    form_name = formable.form_name
    params_to_set = params.extract!(form_name)
    
    if params[:id]
      if params_to_set[form_name]
        session[:form][form_name][:id] = params[:id]
        session[:form][form_name] = params_to_set[form_name]
      else
        if session[:form][form_name][:id] != params[:id]
          session[:form][form_name][:id] = params[:id]
          formable.model.attributes.each do |col, value|
            session[:form][form_name][col] = value    
          end
        end        
      end
    else
      if params_to_set[form_name]
        session[:form][form_name][:id] = nil
        session[:form][form_name] = params_to_set[form_name]
      end
    end
  end
  
  def set_pagination_current_id(tableable)
    pagination_name = tableable.pagination_name
    pagination_per_page = tableable.pagination_per_page
    current_id_name = tableable.current_id_name

    if (params[:pagination] and params[:pagination][pagination_name]) 
      if session[:pagination][pagination_name] != params[:pagination][pagination_name]
        session[:current_id][current_id_name] = nil 
        params[:current_id][current_id_name] = nil if params[:current_id]
      end
      session[:pagination][pagination_name] = params[:pagination][pagination_name]
    end
    
    session[:pagination][pagination_name] = 1 unless session[:pagination][pagination_name]
      
    if session[:pagination][pagination_name].to_i > (1.0 * tableable.model_size / pagination_per_page).ceil
      session[:pagination][pagination_name] = 1
    end
  end

  def set_tables_current_id(tableable)
    pagination_name = tableable.pagination_name
    current_id_name = tableable.current_id_name
    id_name = tableable.id_name
    row_model = tableable.model
    
    params[:current_id][current_id_name] = nil if (params[:current_id] and params[:current_id][current_id_name].blank?)
    session[:current_id][current_id_name] = params[:current_id][current_id_name] if (params[:current_id] and params[:current_id][current_id_name])
    session[:current_id][current_id_name] = row_model.first[id_name] if session[:current_id][current_id_name].blank? and row_model.first
    check_if_current_id_exist_in_row_model = false
    row_model.each do |row|
      check_if_current_id_exist_in_row_model = true if row[id_name].to_s == session[:current_id][current_id_name].to_s
      break if check_if_current_id_exist_in_row_model
    end
    session[:current_id][current_id_name] = row_model.first[id_name] if row_model and row_model.first and !check_if_current_id_exist_in_row_model
  end

  def init_session_for_progress_barable(progress_barable)
    session[:progress_bar][progress_barable.progress_bar_name] ||= {}
  end
  
  def set_session_from_options_for_progress_barable(progress_barable)    
    options = progress_barable.options
    progress_bar_name = progress_barable.progress_bar_name
    
    options.each do |key, value|
      session[:progress_bar][progress_bar_name][key.to_s] = value
    end if options
  end
  
  def set_session_from_params_for_progress_barable(progress_barable)    
    progress_bar_name = progress_barable.progress_bar_name
    params_to_set = params.extract!(progress_bar_name)
    
    params_to_set[progress_bar_name].each do |key, value|
      session[:progress_bar][progress_bar_name][key] = value
    end if params_to_set[progress_bar_name]
  end

end