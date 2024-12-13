require "rails_helper"

RSpec.describe "PATCH /v1/users/:user_id" do
  subject { patch "/v1/users/#{user.id}", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {
      first_name: "Dmitry",
      last_name: "Dimitrenko",
      birth_date: "28.08.1990",
    }
  end

  let!(:user) { create(:user, first_name: "Mariia", last_name: "Sokolova", birth_date: "31.07.1999") }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to eq(user.id)
      expect(response.json[:email]).to eq(user.email)
      expect(response.json[:first_name]).to eq(payload[:first_name])
      expect(response.json[:last_name]).to eq(payload[:last_name])
      expect(response.json[:birth_date]).to eq(payload[:birth_date])
    end
  end

  context "when someone else is trying to update user's details" do
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
