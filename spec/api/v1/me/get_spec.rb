require "rails_helper"

RSpec.describe "GET /v1/me" do
  subject { get "/v1/me", headers: default_headers.merge(headers) }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  context "when current session owner is user" do
    let!(:user) { create(:user) }
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:uuid]).to be_present
      expect(response.json[:kind]).to eq("user")
      expect(response.json[:token]).to eq(access_token)
      expect(response.json[:owner][:data][:id]).to eq(user.id)
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
