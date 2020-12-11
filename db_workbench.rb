# frozen_string_literal: true

require 'date'

start1 = '2019-01-01'
end1 = '2019-12-31'
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

# sums = sum_each_expense_group_in_range(1, start1, end1)
# sums.each { |sum| puts("#{sum[0]}: $#{(sum[1] / days_in_range(start1, end1)).round(2)}") }

# sums = sum_each_expense_group_in_range(1, start2, end2)
# sums.each { |sum| puts("#{sum[0]}: $#{(sum[1] / days_in_range(start2, end2)).round(2)}") }

# puts("Expense Total per day from #{start1} to #{end1}: $#{(fetchExpenseTotal(start1, end1) / days_in_range(start1, end1)).round(2)}")
# puts("Expense Total per day from #{start2} to #{end2}: $#{(fetchExpenseTotal(start2, end2) / days_in_range(start2, end2)).round(2)}")

# group_inp = ARGV[0]
# puts("range 1: $#{(fetchExpenseTotalGroup(group_inp.chomp, start1, end1) / days_in_range(start1, end1)).round(2)}")
# puts("range 2: $#{(fetchExpenseTotalGroup(group_inp.chomp, start2, end2) / days_in_range(start2, end2)).round(2)}")
