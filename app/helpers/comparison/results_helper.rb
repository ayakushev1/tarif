module Comparison::ResultsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers

  def comparison_results_table
    create_tableable(Comparison::Result)
  end
  

end
