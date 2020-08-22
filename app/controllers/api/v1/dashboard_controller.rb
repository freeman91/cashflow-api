module Api
  module V1
    class DashboardController < ApiController
      def data
        now = DateTime.now()
        weeks = weeksInRange(now - (28 * 2), now)
        account = current_user.accounts.first
        recent_expenses, recent_incomes, recent_workHours = [], [], []
        for week in weeks
          recent_expenses.append(Expense.where(account_id: account.id, cwyear: week[:year], cwmonth: week[:month], cweek: week[:week]).pluck(:amount, :date))
          recent_incomes.append(Income.where(account_id: account.id, cwyear: week[:year], cwmonth: week[:month], cweek: week[:week]).pluck(:amount, :date))
          recent_workHours.append(WorkHour.where(account_id: account.id, cwyear: week[:year], cwmonth: week[:month], cweek: week[:week]).pluck(:amount, :date))
        end

        net_income_year = Income.where(account_id: account.id, cwyear: now.cwyear()).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear()).sum(:amount)
        net_income_month = Income.where(account_id: account.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount) - Expense.where(account_id: account.id, cwyear: now.cwyear(), cwmonth: cwmonth(now.cweek())).sum(:amount)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded dashboard data",
                 net_income_year: net_income_year,
                 net_income_month: net_income_month,
                 expenses: recent_expenses,
                 incomes: recent_incomes,
                 workHours: recent_workHours,
               }, status: :ok
      end

      def expenses
        now = DateTime.now()
        account = current_user.accounts.first
        expenses = Expense.where(account_id: account.id, bill: false).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard expenses",
          expenses: expenses,
        }, status: :ok
      end

      def incomes
        now = DateTime.now()
        account = current_user.accounts.first
        incomes = Income.where(account_id: account.id).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard incomes",
          incomes: incomes,
        }, status: :ok
      end

      def work_hours
        now = DateTime.now()
        account = current_user.accounts.first
        work_hours = WorkHour.where(account_id: account.id).last(5).reverse
        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard workHours",
          workHours: work_hours,
        }, status: :ok
      end
    end
  end
end
