require 'spec_helper'

describe ImporterController do

  describe "POST 'import'" do
    it "returns http success" do
      request.env['HTTP_ACCEPT'] = 'application/json'
      request.env['RAW_POST_DATA'] = {
        'id' => 'abyx',
        'txns' => [
          {'amount' => 10.3, 'supplier_name' => 'supplier',
           'sector' => 'my sector', 'date' => 'date', 
           'time' => 'time' }
        ]
      }.to_json
      post :import,
        {},
        :format => :json
      response.should be_success
      response.body.should match(/abyx/)

      txn = Transaction.first
      txn.user_id.should == 'abyx'
      txn.sector.should == 'my sector'
    end
  end
end
