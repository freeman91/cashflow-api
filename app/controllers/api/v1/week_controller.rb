module Api
  module V1
    class WeekController < ApiController
      def data
        now = DateTime.now()
        @week = now.cweek()
        @month = cwmonth(@week)
        @year = now.cwyear()

        @expenses = Expense.where(account_id: current_user.accounts.first.id, cwyear: @year, cweek: @week, bill: false).order(date: :asc)
        @incomes = Income.where(account_id: current_user.accounts.first.id, cwyear: @year, cweek: @week).order(date: :asc)
        @work_hours = WorkHour.where(account_id: current_user.accounts.first.id, cwyear: @year, cweek: @week).order(date: :asc)

        @expTotal = @expenses.sum(:amount)
        @incTotal = @incomes.sum(:amount)
        @wkhrTotal = @work_hours.sum(:amount)

        @netincome = @incTotal - @expTotal

        render json: {
                 status: "SUCCESS",
                 message: "Loaded dashboard data",
                 cwdate: {
                   week: @week,
                   month: @month,
                   year: @year,
                 },
                 netincome: @netincome,
                 expTotal: @expTotal,
                 incTotal: @incTotal,
                 wkhrTotal: @wkhrTotal,
                 expenses: @expenses,
                 incomes: @incomes,
                 work_hours: @work_hours,
               }, status: :ok
      end
    end
  end
end
