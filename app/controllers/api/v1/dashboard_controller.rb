module Api
  module V1
    class DashboardController < ApiController
      def data
        now = DateTime.now()
        account = current_user.accounts.first
        @work_hours = WorkHour.where(account_id: account.id).last(5).reverse
        @net_income_year = (Income.where(account_id: account.id, cwyear: now.cwyear()).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear()).sum(:amount))
        @net_income_month = (Income.where(account_id: account.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount))
        @net_income_week = (Income.where(account_id: account.id, cwyear: now.cwyear(), cweek: now.cweek()).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear(), cweek: now.cweek()).sum(:amount))

        render json: {
                 status: "SUCCESS",
                 message: "Loaded dashboard data",
                 work_hours: @work_hours,
                 net_income_year: @net_income_year,
                 net_income_month: @net_income_month,
                 net_income_week: @net_income_week,
               }, status: :ok
      end

      def expenses
        now = DateTime.now()
        account = current_user.accounts.first
        @expenses = Expense.where(account_id: account.id, bill: false).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard expenses",
          expenses: @expenses,
        }, status: :ok
      end

      def incomes
        now = DateTime.now()
        account = current_user.accounts.first
        @incomes = Income.where(account_id: account.id).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard incomes",
          incomes: @incomes,
        }, status: :ok
      end

      def work_hours
        now = DateTime.now()
        account = current_user.accounts.first
        @work_hours = Expense.where(account_id: account.id).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard work_hours",
          work_hours: @work_hours,
        }, status: :ok
      end
    end
  end
end
