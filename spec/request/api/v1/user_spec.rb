require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe '#create' do
    subject(:make_request) do
      post api_v1_users_path, params: { first_name: 'Daniel', last_name: 'Murta', email: 'danielmurta@email.com' }
    end

    it 'creates a new user' do
      expect { make_request }.to change(User, :count).by(1)
    end

    it 'return the correct status' do
      make_request
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user created' do
      make_request
      json_response = JSON.parse(response.body)

      expect(json_response['data']).to include(
        'first_name' => 'Daniel', 'last_name' => 'Murta', 'email' => 'danielmurta@email.com'
      )
    end

    it 'return the correct message' do
      make_request
      json_response = JSON.parse(response.body)

      expect(json_response['message']).to eq('User created successfully')
    end

    context 'when the user is not created' do
      subject(:make_request) do
        post api_v1_users_path, params: { first_name: 'Daniel', last_name: 'Murta' }
      end

      it 'does not create a new user' do
        expect { make_request }.not_to change(User, :count)
      end

      it 'return the correct status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return the correct message' do
        make_request
        json_response = JSON.parse(response.body)

        expect(json_response['message']).to eq('User not created')
      end

      it 'returns the errors' do
        make_request
        json_response = JSON.parse(response.body)

        expect(json_response['data']).to include('email' => ["can't be blank"])
      end
    end
  end

  describe '#show' do
    subject(:make_request) do
      get api_v1_user_path(user)
    end

    let(:user) { create(:user) }

    it 'return the correct status' do
      make_request
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user' do
      make_request
      json_response = JSON.parse(response.body)

      expect(json_response['data']).to include(
        'first_name' => user.first_name, 'last_name' => user.last_name, 'email' => user.email
      )
    end

    context 'when the user does not exist' do
      subject(:make_request) do
        get api_v1_user_path(id: 'non-existent-id')
      end

      it 'return the correct status' do
        make_request
        expect(response).to have_http_status(:not_found)
      end

      it 'return the correct message' do
        make_request
        json_response = JSON.parse(response.body)

        expect(json_response['message']).to eq('User not found')
      end

      it 'returns an empty data' do
        make_request
        json_response = JSON.parse(response.body)

        expect(json_response['data']).to be_empty
      end
    end
  end
end
