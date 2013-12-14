require 'desk/api'

class CasesController < ApplicationController
	respond_to :json, :html
  def index
  	@filters = Desk::API.filters
  	@filter = @filters.first
  	@cases = Desk::API.cases_for_filter @filter

  	respond_with @cases
  end
end
