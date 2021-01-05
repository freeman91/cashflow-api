# frozen_string_literal: true

module Api
  module V1
    class YearController < ApiController
      def data
        year = Integer(params["year"])

        expenses = Expense.where(account_id: current_user.accounts.first.id, date: Date.new(year, 1, 1)..Date.new(year, 12, 31)).order(date: :asc)
        incomes = Income.where(account_id: current_user.accounts.first.id, date: Date.new(year, 1, 1)..Date.new(year, 12, 31)).order(date: :asc)
        work_hours = WorkHour.where(account_id: current_user.accounts.first.id, date: Date.new(year, 1, 1)..Date.new(year, 12, 31)).order(date: :asc)

        yearStats = []
        months = (1..12).to_a
        months.each do |month|
          monthIncTotal = incomes.where(date: Date.new(year, month, 1)..Date.new(year, month, -1)).sum(:amount)
          monthExpTotal = expenses.where(date: Date.new(year, month, 1)..Date.new(year, month, -1)).sum(:amount)
          monthWkhrTotal = work_hours.where(date: Date.new(year, month, 1)..Date.new(year, month, -1)).sum(:amount)
          temp = {}
          temp["net"] = monthIncTotal - monthExpTotal
          temp["expense"] = monthExpTotal
          temp["income"] = monthIncTotal
          temp["work_hours"] = monthWkhrTotal
          temp["wage"] = monthWkhrTotal === 0 ? 0 : monthIncTotal / monthWkhrTotal
          yearStats[month - 1] = temp
        end

        expenseTotal = expenses.sum(:amount)
        incomeTotal = incomes.sum(:amount)
        workHourTotal = work_hours.sum(:amount)

        netIncome = incomeTotal - expenseTotal

        render json: {
          status: "SUCCESS",
          message: "Loaded dashboard data",
          yearStats: yearStats.to_json,
          netIncome: netIncome,
          expenseTotal: expenseTotal,
          incomeTotal: incomeTotal,
          workHourTotal: workHourTotal,
        }, status: :ok
      end
    end
  end
end
