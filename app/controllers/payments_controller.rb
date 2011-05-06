class PaymentsController < ApplicationController

  # send initial redirect to psp-polska
  def new
    @psp_polska_request = ActiveMerchant::Billing::Integrations::PspPolska::PspPolskaRequest.new(:action => "sale", :amount => 100, :currency => "EUR", :title => "bzdet", :session_id => "some_session_id", :email => "email@example.com", :first_name => "John", :last_name => "Smith", :client_ip => request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip)
    res = @psp_polska_request.send
    @return = ActiveMerchant::Billing::Integrations::PspPolska::Return.new(res.body, :ip => IPSocket::getaddress("sandbox.psp-polska.pl"))
    if @return.success?
      redirect_to @return.redirect_url
    else
      raise "Request failed: #{@return.params.inspect}"
    end
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
end
