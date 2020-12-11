# frozen_string_literal: true

class CreateWorkHours < ActiveRecord::Migration[5.1]
  def change
    create_table :work_hours do |t|
      t.references :account, foreign_key: true
      t.float :amount, null: false
      t.string :source, null: false
      t.integer :cwday, null: false
      t.integer :cweek, null: false
      t.integer :cwmonth, null: false
      t.integer :cwyear, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
