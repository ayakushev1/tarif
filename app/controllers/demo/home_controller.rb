class Demo::HomeController < ApplicationController

  def full_demo_results
    render nothing: true
  end

  def customer_service_sets
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_service_sets_array)
  end
  
  def customer_tarif_results
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_results_array(session[:current_id]['service_sets_id']))
  end

  def customer_tarif_detail_results
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_detail_results_array(
      session[:current_id]['service_sets_id'], session[:current_id]['service_id']))
  end
  
  def final_tarif_results_presenter
    options = {
      :user_id=> (current_user ? current_user.id.to_i : nil),
      :show_zero_tarif_result_by_parts => 'false',
      }
    @optimization_result_presenter ||= ServiceHelper::FinalTarifResultsPresenter.new(options)
  end
  
  def customer_has_free_trials?
    true #(current_user and current_user.customer_infos_services_used and current_user.customer_infos_services_used.customer_has_free_trials?)
  end
end
