module Api
  module V1
    class UsersController < ApplicationController
      def show
        user = User.find_by(id: params[:id])

        if user
          render json: { data: user, message: 'User found' }, status: :ok
        else
          render json: { data: {}, message: 'User not found' }, status: :not_found
        end
      end

      def create
        user = User.new(user_params)

        if user.valid? && user.save
          render json: { data: user, message: 'User created successfully' }, status: :ok
        else
          render json: { data: user.errors, message: 'User not created' }, status: :unprocessable_entity
        end
      end

      def update
        user = User.find_by(id: params[:id])

        render_not_found and return unless user

        if user.update(user_update_params)
          render json: { data: user, message: 'User updated successfully' }, status: :ok
        else
          render json: { data: user.errors, message: 'User not updated' }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:first_name, :last_name, :email)
      end

      def user_update_params
        params.permit(:first_name, :last_name)
      end

      def render_not_found
        render json: { data: {}, message: 'User not found' }, status: :not_found
      end
    end
  end
end
