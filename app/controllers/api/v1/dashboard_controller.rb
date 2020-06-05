module Api
  module V1
    class DashboardController < ApiController
      def data
        now = DateTime.now()
        @expenses = Expense.where(account_id: current_user.accounts.first.id, bill: false).last(5).reverse
        @incomes = Income.where(account_id: current_user.accounts.first.id).last(5).reverse
        @work_hours = WorkHour.where(account_id: current_user.accounts.first.id).last(5).reverse
        @net_income_year = (Income.where(account_id: current_user.accounts.first.id, cwyear: now.cwyear()).sum(:amount) - Expense.where(account_id: current_user.accounts.first.id, cwyear: now.cwyear()).sum(:amount))
        @net_income_month = (Income.where(account_id: current_user.accounts.first.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount) - Expense.where(account_id: current_user.accounts.first.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount))
        @net_income_week = (Income.where(account_id: current_user.accounts.first.id, cwyear: now.cwyear(), cweek: now.cweek()).sum(:amount) - Expense.where(account_id: current_user.accounts.first.id, cwyear: now.cwyear(), cweek: now.cweek()).sum(:amount))

        render json: {
                 status: "SUCCESS",
                 message: "Loaded dashboard data",
                 expenses: @expenses,
                 incomes: @incomes,
                 work_hours: @work_hours,
                 net_income_year: @net_income_year,
                 net_income_month: @net_income_month,
                 net_income_week: @net_income_week,
               }, status: :ok
      end
    end
  end
end
