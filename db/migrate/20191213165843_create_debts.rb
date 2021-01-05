# frozen_string_literal: true

class CreateDebts < ActiveRecord::Migration[5.1]
  def change
    create_table :debts do |t|
      t.references :account, foreign_key: true
      t.float :amount, null: false
      t.string :group, null: false
      t.string :description
      t.integer :cwmonth, null: true
      t.integer :cwyear, null: true
      t.date :date, null: false

      t.timestamps
    end
  end
end
