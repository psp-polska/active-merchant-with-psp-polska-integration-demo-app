class StoredNotification < ActiveRecord::Base
  scope :not_processed, where(:processed => false)
  scope :processed, where(:processed => true)

  def processed?
    processed
  end

  def process!
    return true if processed?
    notification = ActiveMerchant::Billing::Integrations::PspPolska::Notification.new(xml_data)
    if notification.valid? and notification.acknowledge
      # do something when payment is completed
      logger.debug("Notification completed: #{self.inspect}")
    else
      # do something else in opposite case
      logger.debug("Notification not completed: #{self.inspect}")
    end
    update_attribute("processed", true) 
  end

  def self.process
    for stored_notification in StoredNotification.not_processed
      stored_notification.process!
    end
  end
end
