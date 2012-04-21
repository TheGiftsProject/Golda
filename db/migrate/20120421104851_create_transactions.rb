class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :supplier_name
      t.string :sector
      t.datetime :date
      t.decimal :amount, :precision => 10, :scale => 2, :default => 0
      t.string :user_id

      t.timestamps
    end
  end
end
