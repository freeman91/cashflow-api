# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApiController
      def data
        now = DateTime.now()
        weeks = weeksInRange(now - (28 * 2), now)
        account = @current_user.accounts.first
        recent_expenses = []
        recent_incomes_total = 0
        recent_workHours_total = 0
        weeks.each do |week|
          recent_expenses.append(Expense.where(account_id: account.id, cwyear: week[:year], cwmonth: week[:month], cweek: week[:week]).pluck(:amount, :date))
          recent_incomes_total += Income.where(account_id: account.id, cwyear: week[:year], cwmonth: week[:month], cweek: week[:week]).sum(:amount)
          recent_workHours_total += WorkHour.where(account_id: account.id, cwyear: week[:year], cwmonth: week[:month], cweek: week[:week]).sum(:amount)
        end

        render json: {
          status: 'SUCCESS',
          message: 'Loaded dashboard data',
          expenses: recent_expenses,
          incomeTotal: recent_incomes_total,
          workHourTotal: recent_workHours_total
        }, status: :ok
      end

      def expenses
        now = DateTime.now()
        account = @current_user.accounts.first
        expenses = Expense.where(account_id: account.id, bill: false).last(5).reverse
        render json: {
          status: 'SUCCESS',
          message: 'Loaded dashboard expenses',
          expenses: expenses
        }, status: :ok
      end

      def incomes
        now = DateTime.now()
        account = @current_user.accounts.first
        incomes = Income.where(account_id: account.id).last(5).reverse
        render json: {
          status: 'SUCCESS',
          message: 'Loaded dashboard incomes',
          incomes: incomes
        }, status: :ok
      end

      def work_hours
        now = DateTime.now()
        account = @current_user.accounts.first
        work_hours = WorkHour.where(account_id: account.id).last(5).reverse
        render json: {
          status: 'SUCCESS',
          message: 'Loaded dashboard workHours',
          workHours: work_hours
        }, status: :ok
      end
    end
  end
end
