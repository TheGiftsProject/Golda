class ImporterController < ApplicationController
  respond_to :json

  def import
    req = ActiveSupport::JSON.decode(request.body)
    user = req['id']
    txns = req['txns']
    txns.each do |txn|
      t = Transaction.new({
        :amount => txn['amount'],
        :supplier_name => txn['supplier_name'],
        :sector => txn['sector'],
        :date => Time.now
      })
      t.user_id = user
      t.save!
    end
    respond_with({:user_id => req['id']}, :location => nil)
  end
end
