module Portal
  class DashboardController < BaseController
    def show
      authorize :portal, :dashboard?
    end
  end
end
