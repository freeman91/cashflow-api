# frozen_string_literal: true

require 'date'

start1 = '2021-03-01'
end1 = '2021-03-31'
start2 = '2020-01-01'
end2 = '2020-09-26'

def days_in_range(start_day, end_day)
  (Date.strptime(end_day) - Date.strptime(start_day)).to_i
end

def fetch_expense_total_group(group, start_day, end_day)
  Expense.where(group: group, date: start_day..end_day).sum(:amount)
end

def fetch_expense_total(start_day, end_day)
  Expense.where(date: start_day..end_day).sum(:amount)
end

def sum_each_expense_group_in_range(account_id, start_day, end_day)
  sums = {}
  expenses = Expense.where(account_id: account_id, date: start_day..end_day)
  groups = expenses.pluck(:group).uniq
  groups.sort.each { |group| sums[group] = expenses.where(group: group).sum(:amount).round(2) }
  sums
end

def print_expenses_per_day()
  sums = sum_each_expense_group_in_range(1, start1, end1)
  sums.each { |sum| puts("#{sum[0]}: $#{(sum[1] / days_in_range(start1, end1)).round(2)}") }
  puts("Expense Total per day from #{start1} to #{end1}: $#{(fetch_expense_total(start1, end1) / days_in_range(start1, end1)).round(2)}")
end

def sum_of_groups(sums, groups)
  total = 0
  for group in groups
    total += (sums.has_key?(group) ? sums[group] : 0)
  end
  return total
end

# chart data for percent income
def percent_income_in_range(start: "2021-01-01", _end: "2021-04-04")

  income_sum = Income.where(account_id: 1, date: start.._end).sum(:amount) 

  # fetch grouped expenses
  sums = sum_each_expense_group_in_range(1, start, _end)
  
  shelter_groups =["Rent", "Utilities"]
  food_groups = ["Food", "Grocery"]
  essential_groups = ["Insurance", "Health", "Car", "Tuition"]
  eelse_groups = sums.keys - (shelter_groups + food_groups + essential_groups)

  shelter_sum = sum_of_groups(sums, shelter_groups)
  food_sum = sum_of_groups(sums, food_groups)
  essential_sum = sum_of_groups(sums, essential_groups)
  eelse_sum = sum_of_groups(sums, eelse_groups)

  return {
    :shelter => (shelter_sum / income_sum).round(3) * 100,
    :food => (food_sum / income_sum).round(3) * 100,
    :essential => (essential_sum / income_sum).round(3) * 100,
    :eelse => (eelse_sum / income_sum).round(3) * 100,
    :total => ((shelter_sum + food_sum + essential_sum + eelse_sum) / income_sum).round(3) * 100
  }
end

puts(percent_income_in_range())
