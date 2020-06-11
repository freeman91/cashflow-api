module Api
  module V1
    class DashboardController < ApiController
      def data
        now = DateTime.now()
        account = current_user.accounts.first
        @expenses = Expense.where(account_id: account.id, bill: false).last(5).reverse
        @incomes = Income.where(account_id: account.id).last(5).reverse
        @work_hours = WorkHour.where(account_id: account.id).last(5).reverse
        @net_income_year = (Income.where(account_id: account.id, cwyear: now.cwyear()).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear()).sum(:amount))
        @net_income_month = (Income.where(account_id: account.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount))
        @net_income_week = (Income.where(account_id: account.id, cwyear: now.cwyear(), cweek: now.cweek()).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear(), cweek: now.cweek()).sum(:amount))
        @expense_groups = ExpenseGroup.where(account_id: account.id)
        @income_sources = IncomeSource.where(account_id: account.id)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded dashboard data",
                 expenses: @expenses,
                 incomes: @incomes,
                 work_hours: @work_hours,
                 expense_groups: @expense_groups,
                 income_sources: @income_sources,
                 net_income_year: @net_income_year,
                 net_income_month: @net_income_month,
                 net_income_week: @net_income_week,
               }, status: :ok
      end
    end
  end
end
