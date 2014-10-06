class Demo::OptimizationStepsController < ApplicationController
  layout 'demo_application'

  def load_calls_options
    @load_calls_options ||= Filtrable.new(self, "load_calls_options")
  end
end
