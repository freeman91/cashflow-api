# frozen_string_literal: true

class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.references :account, foreign_key: true
      t.float :amount, null: false
      t.string :group, null: false
      t.string :vendor
      t.string :description
      t.boolean :bill, null: true
      t.integer :cwday, null: true
      t.integer :cweek, null: true
      t.integer :cwmonth, null: true
      t.integer :cwyear, null: true
      t.date :date, null: false

      t.timestamps
    end
  end
end
