module Api
  module V1
    class MonthController < ApiController
      def data
        now = DateTime.now()
        @week = now.cweek()
        @month = cwmonth(@week)
        @year = now.cwyear()

        @expenses = Expense.where(account_id: current_user.accounts.first.id, cwyear: @year, cwmonth: @month).order(date: :asc)
        @incomes = Income.where(account_id: current_user.accounts.first.id, cwyear: @year, cwmonth: @month).order(date: :asc)
        @work_hours = WorkHour.where(account_id: current_user.accounts.first.id, cwyear: @year, cwmonth: @month).order(date: :asc)

        weeks = cweeks(@month)

        @monthStats = {}
        weeks.each { |wk|
          wkIncTotal = @incomes.where(cweek: wk).sum(:amount)
          wkExpTotal = @expenses.where(cweek: wk).sum(:amount)
          wkWkhrTotal = @work_hours.where(cweek: wk).sum(:amount)
          temp = {}
          temp["net"] = wkIncTotal - wkExpTotal
          temp["expense"] = wkExpTotal
          temp["income"] = wkIncTotal
          temp["work_hours"] = wkWkhrTotal
          temp["wage"] = wkWkhrTotal === 0 ? 0 : wkIncTotal / wkWkhrTotal
          @monthStats[wk] = temp
        }

        @expTotal = @expenses.sum(:amount)
        @incTotal = @incomes.sum(:amount)
        @wkhrTotal = @work_hours.sum(:amount)

        @netincome = @incTotal - @expTotal

        render json: {
                 status: "SUCCESS",
                 message: "Loaded month data",
                 cwdate: {
                   week: @week,
                   month: @month,
                   year: @year,
                 },
                 monthStats: @monthStats.to_json,
                 netincome: @netincome,
                 expTotal: @expTotal,
                 incTotal: @incTotal,
                 wkhrTotal: @wkhrTotal,
               }, status: :ok
      end

      def bills
        now = DateTime.now()
        week = now.cweek()
        month = cwmonth(week)
        year = now.cwyear()
        bills = Expense.where(account_id: current_user.accounts.first.id, cwyear: year, cwmonth: month, bill: true).order(date: :asc)
        render json: {
          status: "SUCCESS",
          message: "Loaded month bills",
          bills: bills,
        }, status: :ok
      end
    end
  end
end
