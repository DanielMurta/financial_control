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

    context 'when the email is not unique' do
      subject(:make_request) do
        post api_v1_users_path, params: { first_name: 'Daniel', last_name: 'Murta', email: user.email }
      end

      let(:user) { create(:user) }

      it 'does not create a new user' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the errors' do
        make_request
        json_response = JSON.parse(response.body)

        expect(json_response['data']).to include('email' => ['has already been taken'])
      end

      it 'return the correct message' do
        make_request
        json_response = JSON.parse(response.body)

        expect(json_response['message']).to eq('User not created')
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

  describe '#update' do
    subject(:make_request) do
      put api_v1_user_path(user), params: { first_name: 'New first name', last_name: 'New last name' }
    end

    let(:user) { create(:user) }

    it 'updates the user' do
      make_request
      expect(user.reload.first_name).to eq('New first name')
    end

    it 'return the correct status' do
      make_request
      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated user' do
      make_request
      json_response = JSON.parse(response.body)

      expect(json_response['data']).to include(
        'first_name' => 'New first name', 'last_name' => 'New last name', 'email' => user.email
      )
    end

    it 'return the correct message' do
      make_request
      json_response = JSON.parse(response.body)

      expect(json_response['message']).to eq('User updated successfully')
    end

    context 'when the user does not exist' do
      subject(:make_request) do
        put api_v1_user_path(id: 'non-existent-id'), params: { first_name: 'first name', last_name: 'last name' }
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

  describe '#destroy' do
    subject(:make_request) do
      delete api_v1_user_path(user)
    end

    let(:user) { create(:user) }

    it 'deletes the user' do
      make_request
      expect(User.find_by(id: user.id)).to be_nil
    end

    it 'return the correct status' do
      make_request
      expect(response).to have_http_status(:ok)
    end

    context 'when the user does not exist' do
      subject(:make_request) do
        delete api_v1_user_path(id: 'non-existent-id')
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
