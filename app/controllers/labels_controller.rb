require 'desk/api'
class LabelsController < ApplicationController
  respond_to :json, :html
 
 protect_from_forgery

after_filter :set_csrf_cookie_for_ng

def set_csrf_cookie_for_ng
  cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
end

  def index
  	@labels = Desk::API.labels
  	respond_with @labels
  end

  def add
  	puts params.to_hash
  	@labelname = params["labelname"]
  	if(!@labelname.blank?)

			resp = Desk::API.addlabel @labelname
			if(resp)
				puts 'success'
				@response = {:status => "success", :message => "Label #{@labelname} successfully added!", :label => @labelname}
			else
				puts 'failure'
				@response =  {:status => "failure", :message => "An Error occured while adding labels!"}
			end	
		else
			puts 'labelname is blank!'
			@response = {:status => "failure", :message => "Labelname cannot be blank!"}
		end

  	respond_with @response

  end

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

end
