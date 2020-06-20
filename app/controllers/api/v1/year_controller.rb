module Api
  module V1
    class YearController < ApiController
      def data
        now = DateTime.now()
        @week = now.cweek()
        @month = cwmonth(@week)
        @year = now.cwyear()

        @expenses = Expense.where(account_id: current_user.accounts.first.id, cwyear: @year).order(date: :asc)
        @incomes = Income.where(account_id: current_user.accounts.first.id, cwyear: @year).order(date: :asc)
        @work_hours = WorkHour.where(account_id: current_user.accounts.first.id, cwyear: @year).order(date: :asc)

        @yearStats = {}
        months = (1..12).to_a
        months.each { |month|
          monthIncTotal = @incomes.where(cwmonth: month).sum(:amount)
          monthExpTotal = @expenses.where(cwmonth: month).sum(:amount)
          monthWkhrTotal = @work_hours.where(cwmonth: month).sum(:amount)
          temp = {}
          temp["net"] = monthIncTotal - monthExpTotal
          temp["expense"] = monthExpTotal
          temp["income"] = monthIncTotal
          temp["work_hours"] = monthWkhrTotal
          temp["wage"] = monthWkhrTotal === 0 ? 0 : monthIncTotal / monthWkhrTotal
          @yearStats[month] = temp
        }

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
                 yearStats: @yearStats.to_json,
                 netincome: @netincome,
                 expTotal: @expTotal,
                 incTotal: @incTotal,
                 wkhrTotal: @wkhrTotal,
               }, status: :ok
      end
    end
  end
end