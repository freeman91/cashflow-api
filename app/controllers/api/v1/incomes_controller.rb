# frozen_string_literal: true

module Api
  module V1
    class IncomesController < ApiController
      skip_before_action :auth_with_token!, only: %i[create destroy update]

      def month
        month = Integer(params["month"])
        year = Integer(params["year"])
        incomes = Income.where(account_id: current_user.accounts.first.id, date: Date.new(year, month, 1)..Date.new(year, month, -1)).order(date: :asc)

        render json: {
          status: "SUCCESS",
          message: "Loaded month incomes",
          incomes: incomes,
        }, status: :ok
      end

      # POST /incomes
      def create
        income = Income.new
        date = params["params"]["date"]
        income.account_id = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first.id
        income.amount = params["params"]["amount"]
        income.source = params["params"]["source"]
        income.description = params["params"]["description"]
        income.date = date[0..9]

        if income.save
          render json: income, status: :created
        else
          render_error(income.errors.full_messages[0], :unprocessable_entity)
        end
      end

      # PATCH/PUT /incomes/
      def update
        date = params["params"]["date"]
        income = Income.find(Integer(params["params"]["id"]))
        amount = Float(params["params"]["amount"])
        source = params["params"]["source"]
        description = params["params"]["description"]
        date = date[0..9]

        income.update(amount: amount, source: source, description: description, date: date)

        if income.save
          render json: {
            status: "SUCCESS",
            message: "income updated",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      # DELETE /incomes/1
      # DELETE /incomes/1.json
      def destroy
        income = Income.destroy(params["id"])

        if income
          render json: {
            status: "SUCCESS",
            message: "Income deleted",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "Invalid id",
          }, status: 400
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_income
        @income = income.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def income_params
        params.require(:income).permit(:account_id, :amount, :source, :vendor, :description, :date)
      end
    end
  end
end
