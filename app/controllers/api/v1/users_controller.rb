module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)

        if user.valid? && user.save
          render json: { data: user, message: 'User created successfully' }, status: :ok
        else
          render json: { data: user.errors, message: 'User not created' }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:first_name, :last_name, :email)
      end
    end
  end
end
