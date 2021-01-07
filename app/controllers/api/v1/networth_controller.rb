# frozen_string_literal: true

module Api
  module V1
    class NetworthController < ApiController
      def data
        month = Integer(params["month"])
        year = Integer(params["year"])

        netWorthData = []
        cur_month = month
        cur_year = year
        (1..11).each do |_count|
          cur_debts_total = Debt.where(account_id: current_user.accounts.first.id, date: Date.new(cur_year, cur_month, 1)..Date.new(cur_year, cur_month, -1)).sum(:amount)
          cur_props_total = Property.where(account_id: current_user.accounts.first.id, date: Date.new(cur_year, cur_month, 1)..Date.new(cur_year, cur_month, -1)).sum(:amount)
          cur_net = cur_props_total - cur_debts_total
          netWorthData.push([cur_month, cur_year, (cur_props_total - cur_debts_total)])

          cur_month = cur_month - 1 == 0 ? 12 : cur_month - 1
          cur_year = cur_month == 12 ? cur_year - 1 : cur_year
        end

        render json: {
          status: "SUCCESS",
          message: "Loaded net worth data",
          netWorthData: netWorthData,
        }, status: :ok
      end

      def properties
        month = Integer(params["month"])
        year = Integer(params["year"])
        properties = Property.where(account_id: current_user.accounts.first.id, date: Date.new(year, month, 1)..Date.new(year, month, -1)).order(date: :asc)

        render json: {
          status: "SUCCESS",
          message: "Loaded properties",
          properties: properties,
        }, status: :ok
      end

      def debts
        month = Integer(params["month"])
        year = Integer(params["year"])
        debts = Debt.where(account_id: current_user.accounts.first.id, date: Date.new(year, month, 1)..Date.new(year, month, -1)).order(date: :asc)

        render json: {
          status: "SUCCESS",
          message: "Loaded debts",
          debts: debts,
        }, status: :ok
      end
    end
  end
end
