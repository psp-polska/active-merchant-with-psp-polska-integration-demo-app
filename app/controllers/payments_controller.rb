class PaymentsController < ApplicationController

  # send initial redirect to psp-polska
  def new
    @psp_polska_request = ActiveMerchant::Billing::Integrations::PspPolska::PspPolskaRequest.new(:action => "sale", :amount => 100, :currency => "EUR", :title => "bzdet", :session_id => "some_session_id", :email => "email@example.com", :first_name => "John", :last_name => "Smith", :client_ip => request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip)
    res = @psp_polska_request.send
    @return = ActiveMerchant::Billing::Integrations::PspPolska::Return.new(res.body)
    if @return.success?
      redirect_to @return.redirect_url
    else
      raise "Request failed: #{@return.params.inspect} VALID: #{@return.valid?}"
    end
  end

  # handle all returns from psp-polska
  def create

  end

  # handle notifications from psp-polska
  def update

  end
end
