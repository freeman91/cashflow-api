# frozen_string_literal: true

module Api
  module V1
    class PropertySourcesController < ApiController
      skip_before_action :auth_with_token!, only: %i[create data all update destroy]

      def data
        sources = PropertySource.where(account_id: current_user.accounts.first.id).order("name ASC").pluck(:name)

        render json: {
          status: "SUCCESS",
          message: "Loaded user property sources",
          sources: sources,
        }, status: :ok
      end

      def all
        sources = PropertySource.where(account_id: current_user.accounts.first.id).order("name ASC")

        render json: {
          status: "SUCCESS",
          message: "Loaded user property sources",
          sources: sources,
        }, status: :ok
      end

      def create
        new_source = PropertySource.new
        new_source.account_id = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first.id
        new_source.name = params["params"]["name"]
        new_source.description = params["params"]["description"]

        if new_source.save
          render json: new_source, status: :created
        else
          render_error(new_source.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        source = PropertySource.find(Integer(params["params"]["id"]))
        name = params["params"]["name"]
        description = params["params"]["description"]

        source.update(name: name, description: description)

        if source.save
          render json: {
            status: "SUCCESS",
            message: "Income Source updated",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      def destroy
        source = PropertySource.destroy(params["id"])

        if source
          render json: {
            status: "SUCCESS",
            message: "Income Source deleted",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "Invalid id",
          }, status: 400
        end
      end
    end
  end
end
