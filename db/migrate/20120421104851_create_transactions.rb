class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :supplier_name
      t.string :sector
      t.datetime :date
      t.decimal :amount, :percision => 10, :scale => 2
      t.string :user_id

      t.timestamps
    end
  end
end
