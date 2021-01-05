# frozen_string_literal: true

module Api
  module V1
    class ExpensesController < ApiController
      # before_action :set_expense, only: [:show, :edit, :update, :destroy]
      skip_before_action :auth_with_token!, only: %i[create destroy update]

      def month
        month = Integer(params["month"])
        year = Integer(params["year"])
        expenses = Expense.where(account_id: current_user.accounts.first.id, date: Date.new(year, month, 1)..Date.new(year, month, -1)).order(date: :asc)

        render json: {
          status: "SUCCESS",
          message: "Loaded month expenses",
          expenses: expenses,
        }, status: :ok
      end

      # POST /expenses
      def create
        expense = Expense.new
        date = params["params"]["date"]
        expense.account_id = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first.id
        expense.amount = params["params"]["amount"]
        expense.group = params["params"]["group"]
        expense.vendor = params["params"]["vendor"]
        expense.description = params["params"]["description"]
        expense.date = date[0..9]

        if expense.save
          render json: expense, status: :created
        else
          render_error(expense.errors.full_messages[0], :unprocessable_entity)
        end
      end

      # PATCH/PUT /expenses/
      def update
        date = params["params"]["date"]
        expense = Expense.find(Integer(params["params"]["id"]))
        amount = Float(params["params"]["amount"])
        group = params["params"]["group"]
        vendor = params["params"]["vendor"]
        description = params["params"]["description"]
        date = date[0..9]

        expense.update(amount: amount, group: group, vendor: vendor, description: description, date: date)

        if expense.save
          render json: {
            status: "SUCCESS",
            message: "expense updated",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      # DELETE /expenses/1
      # DELETE /expenses/1.json
      def destroy
        expense = Expense.destroy(params["id"])

        if expense
          render json: {
            status: "SUCCESS",
            message: "Expense deleted",
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
      def set_expense
        @expense = Expense.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def expense_params
        params.require(:expense).permit(:account_id, :amount, :group, :vendor, :description, :date)
      end
    end
  end
end
