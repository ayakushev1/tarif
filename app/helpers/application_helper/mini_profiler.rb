module ApplicationHelper::MiniProfiler

  def check_rack_mini_profiler
    # for example - if current_user.admin?
#    raise(StandardError)
    if current_user_admin?
      Rack::MiniProfiler.authorize_request
    end
  end  



end
