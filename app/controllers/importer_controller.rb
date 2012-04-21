class ImporterController < ApplicationController
  skip_before_filter :verify_authenticity_token
  #respond_to :json

  def import
    puts params.inspect
    #req = ActiveSupport::JSON.decode(request.body)
    user = 'golda' # FIXME ? 
    #txns = req['txns']
    #txns = [req]
    txns = [params]
    txns.each do |txn|
      t = Transaction.find_or_initialize_by_txn_id(txn['txnId'])
      t.update_attributes({
        :amount => txn['sum'],
        :supplier_name => txn['supplierName'].reverse,
        :sector => txn['sector'].reverse,
        :date => DateTime.parse("#{txn['date']} #{txn['time']}"),
        :address => txn['address'].reverse
      })
      t.user_id = user
      t.save!
    end
    #respond_with({:user_id => user}, :location => nil)
    render :text => 'klsdfjklsdkljfds'
  end
end
