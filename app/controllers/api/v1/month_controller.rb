# frozen_string_literal: true

module Api
  module V1
    class MonthController < ApiController
      def data
        week = Integer(params['week'])
        year = Integer(params['year'])
        month = cwmonth(week)
        account_id = current_user.accounts.first.id

        expenses = Expense.where(account_id: account_id, cwyear: year, cwmonth: month).order(date: :asc)
        incomes = Income.where(account_id: account_id, cwyear: year, cwmonth: month).order(date: :asc)
        work_hours = WorkHour.where(account_id: account_id, cwyear: year, cwmonth: month).order(date: :asc)

        weeks = cweeks(month)

        monthStats = {}
        weeks.each do |wk|
          wkIncTotal = incomes.where(cweek: wk).sum(:amount)
          wkExpTotal = expenses.where(cweek: wk, bill: false).sum(:amount)
          wkWkhrTotal = work_hours.where(cweek: wk).sum(:amount)
          temp = {}
          temp['net'] = wkIncTotal - wkExpTotal
          temp['expense'] = wkExpTotal
          temp['income'] = wkIncTotal
          temp['work_hours'] = wkWkhrTotal
          temp['wage'] = wkWkhrTotal === 0 ? 0 : wkIncTotal / wkWkhrTotal
          monthStats[wk] = temp
        end

        expTotal = expenses.sum(:amount)
        incTotal = incomes.sum(:amount)
        wkhrTotal = work_hours.sum(:amount)

        netincome = incTotal - expTotal

        render json: {
          status: 'SUCCESS',
          message: 'Loaded month data',
          monthStats: monthStats.to_json,
          netincome: netincome,
          expTotal: expTotal,
          incTotal: incTotal,
          wkhrTotal: wkhrTotal
        }, status: :ok
      end

      def bills
        week = Integer(params['week'])
        year = Integer(params['year'])
        month = cwmonth(week)
        bills = Expense.where(account_id: current_user.accounts.first.id, cwyear: year, cwmonth: month, bill: true).order(date: :asc)
        render json: {
          status: 'SUCCESS',
          message: 'Loaded month bills',
          bills: bills
        }, status: :ok
      end

      def pie_chart
        startDate = params['startDate']
        endDate = params['endDate']
        groupSums = {}

        expenses = Expense.where(account_id: current_user.accounts.first.id, date: startDate..endDate)
        groups = expenses.pluck('group').uniq

        groups.each { |group| groupSums[group] = expenses.where(group: group).sum(:amount) }

        render json: {
          status: 'SUCCESS',
          message: 'Loaded chart data',
          groupSums: groupSums
        }, status: :ok
      end
    end
  end
end
