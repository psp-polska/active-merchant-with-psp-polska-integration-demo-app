require 'test_helper'

class StoredNotificationTest < ActiveSupport::TestCase
  
VALID_XML_DATA = "<?xml version='1.0' encoding='UTF-8'?>
  <response>
    <action>sale</action>
    <app-id>example</app-id>
    <session-id>some_session_id</session-id>
    <title>bzdet</title>
    <amount>100</amount>
    <transaction-id>639923858</transaction-id>
    <status>approved</status>
    <checksum>bf09add36fe32c196eca13a9a86ba709</checksum>
    <ts>1303297377</ts>
  </response>"

  def setup   
    @not_processed = StoredNotification.create(:xml_data => VALID_XML_DATA, :processed => false)
    @processed = StoredNotification.create(:xml_data => VALID_XML_DATA, :processed => true)
  end

  test "scopes" do
    assert StoredNotification.not_processed.include?(@not_processed)
    assert !StoredNotification.not_processed.include?(@processed)
    assert StoredNotification.processed.include?(@processed)
    assert !StoredNotification.processed.include?(@not_processed)
  end

  test "process! on processed" do
    assert @processed.process!
  end

  test "process! on not processed" do
    assert @not_processed.process!
    assert @not_processed.processed?
  end

  test "self.process" do
    StoredNotification.process
    assert StoredNotification.not_processed.empty?
  end
end
