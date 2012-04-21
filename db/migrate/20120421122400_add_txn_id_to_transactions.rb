class AddTxnIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :txn_id, :integer, :null => false
    add_column :transactions, :address, :text
  end
end
