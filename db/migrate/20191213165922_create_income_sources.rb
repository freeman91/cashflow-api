# frozen_string_literal: true

class CreateIncomeSources < ActiveRecord::Migration[5.1]
  def change
    create_table :income_sources do |t|
      t.references :account, foreign_key: true
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
