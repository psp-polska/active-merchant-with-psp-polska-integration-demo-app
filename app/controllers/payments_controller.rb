class PaymentsController < ApplicationController
  include ActiveMerchant::Billing::Integrations::PspPolska

  # send initial redirect to psp-polska
  def sale
    @psp_polska_request = PspPolskaRequest.new(request_data)
    handle_request
  end

  def recurring
    @psp_polska_request = PspPolskaRequest.new(request_data.merge(:action => "recurring_start", :cycle => "1m"))
    handle_request  
  end

  # handle success redirect from psp-polska
  def success 
    render :text => "OK"
  end

  def fail
    render :text => "FAIL"
  end

  # handle notifications from psp-polska
  def notification
    StoredNotification.create!(:xml_data => params[:response].to_xml(:root => "response"), :processed => false)
    render :text => "OK"
  end

  private 

  def request_data
    {:action => "sale", :amount => 100, :currency => "EUR", :title => "bzdet", :session_id => "some_session_id", :email => "email@example.com", :first_name => "John", :last_name => "Smith", :client_ip => request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip}
  end

  def handle_request
    res = @psp_polska_request.send
    @return = Return.new(res.body, :ip => IPSocket::getaddress("sandbox.psp-polska.pl"))
    if @return.success?
      redirect_to @return.redirect_url
    else
      raise "Request failed: #{@return.params.inspect} | #{res.body} | #{@psp_polska_request.to_xml}"
    end
  end
end
