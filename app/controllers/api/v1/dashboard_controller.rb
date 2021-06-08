# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApiController
      def data
        groupSums = {}

        expenses = Expense.where(account_id: current_user.accounts.first, date: 90.days.ago..Date.today)
        income_sum = Income.where(account_id: current_user.accounts.first, date: 90.days.ago..Date.today).sum(:amount)
        work_hour_sum = WorkHour.where(account_id: current_user.accounts.first, date: 90.days.ago..Date.today).sum(:amount)

        expense_sum = expenses.sum(:amount)

        groups = expenses.pluck("group").uniq
        groups.each { |group| groupSums[group] = expenses.where(group: group).sum(:amount) }

        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard data",
          data: groupSums,
          expense_sum: expense_sum,
          income_sum: income_sum,
          work_hour_sum: work_hour_sum,
        }, status: :ok
      end

      def expense_sum
        now = DateTime.now()
        expense_sum = Expense.where(account_id: current_user.accounts.first, date: Date.new(now.year, 1, 1)..Date.today).sum(:amount)

        render json: {
          status: "SUCCESS",
          message: "Loaded expense sum",
          expense_sum: expense_sum,
        }, status: :ok
      end

      def income_sum
        now = DateTime.now()
        income_sum = Income.where(account_id: current_user.accounts.first, date: Date.new(now.year, 1, 1)..Date.today).sum(:amount)

        render json: {
          status: "SUCCESS",
          message: "Loaded income sum",
          income_sum: income_sum,
        }, status: :ok
      end

      def work_hour_sum
        now = DateTime.now()
        work_hour_sum = WorkHour.where(account_id: current_user.accounts.first, date: Date.new(now.year, 1, 1)..Date.today).sum(:amount)

        render json: {
          status: "SUCCESS",
          message: "Loaded work hour sum",
          work_hour_sum: work_hour_sum,
        }, status: :ok
      end

      def expenses
        now = DateTime.now()
        account = current_user.accounts.first
        expenses = Expense.where(account_id: account.id, date: 10.days.ago..Date.today).order(date: :asc).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard expenses",
          expenses: expenses,
        }, status: :ok
      end

      def incomes
        now = DateTime.now()
        account = current_user.accounts.first
        incomes = Income.where(account_id: account.id, date: 90.days.ago..Date.today).order(date: :asc).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard incomes",
          incomes: incomes,
        }, status: :ok
      end

      def work_hours
        now = DateTime.now()
        account = current_user.accounts.first
        work_hours = WorkHour.where(account_id: account.id, date: 20.days.ago..Date.today).order(date: :asc).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard workHours",
          workHours: work_hours,
        }, status: :ok
      end

      def percent_income
        start = params["start"]
        _end = params["end"]
        account_id = params["account_id"]
        expense_sums = {}

        income_sum = Income.where(account_id: account_id, date: start.._end).sum(:amount) 
        expenses = Expense.where(account_id: account_id, date: start.._end)
        groups = expenses.pluck(:group).uniq

        groups.sort.each { |group| expense_sums[group] = expenses.where(group: group).sum(:amount).round(2) }

        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard percent income data",
          income_sum: income_sum,
          expense_sums: expense_sums
        }
      end
    end
  end
end
