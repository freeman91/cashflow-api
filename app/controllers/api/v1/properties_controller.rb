# frozen_string_literal: true

module Api
  module V1
    class PropertiesController < ApiController
      skip_before_action :auth_with_token!, only: %i[create destroy update month]

      def create
        property = Property.new
        date = params["params"]["date"]
        property.account_id = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first.id
        property.amount = params["params"]["amount"]
        property.source = params["params"]["source"]
        property.description = params["params"]["description"]
        property.date = date[0..9]

        if property.save
          render json: property, status: :created
        else
          render_error(property.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        date = params["params"]["date"]
        property = Property.find(Integer(params["params"]["id"]))
        amount = Float(params["params"]["amount"])
        source = params["params"]["source"]
        description = params["params"]["description"]
        date = date[0..9]

        property.update(amount: amount, source: source, description: description, date: date)

        if property.save
          render json: {
            status: "Accepted",
            message: "property updated",
          }, status: :accepted
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      def destroy
        property = Property.destroy(params["id"])

        if property
          render json: {
            status: "Accepted",
            message: "Property record deleted",
          }, status: :accepted
        else
          render json: {
            status: "ERROR",
            message: "Invalid id",
          }, status: 400
        end
      end

      def month
        account = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first
        year = params["params"]["year"]
        month = params["params"]["month"]

        properties = Property.where(account_id: account.id, date: Date.new(year, month, 1)..Date.new(year, month, -1))

        render json: {
          status: "SUCCESS",
          message: "Properties Loaded",
          properties: properties,
        }, status: :ok
      end
    end
  end
end
