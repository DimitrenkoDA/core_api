require "rails_helper"

RSpec.describe "GET /v1/users/:user_id" do
  subject { get "/v1/users/#{user.id}", headers: default_headers.merge(headers) }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let!(:user) { create(:user) }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to eq(user.id)
      expect(response.json[:email]).to eq(user.email)
      expect(response.json[:first_name]).to eq(user.first_name)
      expect(response.json[:last_name]).to eq(user.last_name)
      expect(response.json[:birth_date]).to eq(user.birth_date.strftime("%d.%m.%Y"))
    end
  end

  context "when someone else trying to get user's details" do
    let!(:another_user) { create(:user) }
    let!(:access_token) { System::Session.token(another_user) }

    it "responds with 401" do
      subject

      expect(response.status).to eq(401)
    end
  end

  context "when token is invalid" do
    let!(:access_token) { SecureRandom.hex(64) }

    it "responds with 401" do
      subject

      expect(response.status).to eq(401)
    end
  end
end
