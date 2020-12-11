# frozen_string_literal: true

class ExpenseGroup < ApplicationRecord
  belongs_to :account
end
