active-merchant-with-psp-polska-integration-demo-app
====================================================

Intro
-----

This is demo app to show you how to work with PSP Polska payments integration
from our official ActiveMerchant fork. We want to pull our fork to official
ActiveMerchant release, but for now you have to use our AM form from github:
git://github.com/psp-polska/active_merchant.git

This app can be also downloaded from github:
git://github.com/psp-polska/active-merchant-with-psp-polska-integration-demo-app.git

PSP Polska offers XML-based API. You have to send initial xml request to receive 
answer that can be used to redirect user to PSP Polska payment page where user
can do all things required to make payment. After that user is redirected back 
to your site and payment notification is sent to your app that you can use to
change payment/order status.

See API documentation to learn more [will be linked soon]

Actions
-------

We have following routes in our demo app:

 'sale_payments GET  /payments/sale(.:format)         {:controller=>"payments", :action=>"sale"}
   recurring_payments GET  /payments/recurring(.:format)    {:controller=>"payments", :action=>"recurring"}
     success_payments GET  /payments/success(.:format)      {:controller=>"payments", :action=>"success"}
        fail_payments GET  /payments/fail(.:format)         {:controller=>"payments", :action=>"fail"}
notification_payments POST /payments/notification(.:format) {:controller=>"payments", :action=>"notification"}
                 root      /(.:format)                      {:controller=>"payments", :action=>"sale"}'
**Sale action**

This action is used to send initial request to API, receive the response and
redirect user to PSP Polska single payment page.

**Recurring action**

Action is used to send initial recurring request to API, receive the response
and redirect user to PSP Polska recurring start page.

**Success action**

Fake action where user should be redirected to after successful payment.

**Fail action**

Fake action where user should be redirected to after unsuccessful payment.

**Notification action**

Action to receive notification from PSP Polska. The notification is send
when user establish new payment (single payment or recurring). The 
notification has information about payment status. 

First of all we stored this notification in database. After that we say
'OK' to let API know we receive the response correct.

To process notification we use whenever that run following method:
StoredNotification.process
This method is looking up for not processed stored notifications and
call process! action for all of them. Our process! action just log
some info, but real case it should be used to change payment/order
status in your system.

**Configuration file**

Your PSP Polska account should be set up in config/psp_polska.yml
There is example for this file in our repo with public test account.
You can use this account or use your own.

