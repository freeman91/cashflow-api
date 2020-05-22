class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.references :account, foreign_key: true
      t.float :amount, null: false
      t.string :source, null: false
      t.string :description
      t.integer :cwmonth, null: false
      t.integer :cwyear, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
