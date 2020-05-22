class Account < ApplicationRecord
  belongs_to :user
  has_many :expenses
  has_many :incomes
  has_many :debts
  has_many :properties
  has_many :expense_groups
  has_many :income_sources
  has_many :debt_groups
  has_many :property_sources
end
