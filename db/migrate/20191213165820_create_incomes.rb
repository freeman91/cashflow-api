# frozen_string_literal: true

class CreateIncomes < ActiveRecord::Migration[5.1]
  def change
    create_table :incomes do |t|
      t.references :account, foreign_key: true
      t.float :amount, null: false
      t.string :source, null: false
      t.string :description
      t.integer :cwday, null: true
      t.integer :cweek, null: true
      t.integer :cwmonth, null: true
      t.integer :cwyear, null: true
      t.date :date, null: false

      t.timestamps
    end
  end
end
