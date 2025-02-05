require "rails_helper"

RSpec.describe "PATCH /v1/user_categories/:user_category_id" do
  subject { patch "/v1/user_categories/#{category.id}", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {
      kind: "payment",
      name: "Taxi",
      colour_code: "#FFF000",
      description: "Taxi services like Uber, Yandex, etc"
    }
  end

  let!(:user) { create(:user, email: "someone@mail.com") }
  let!(:category) { create(:user_category, user: user) }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)
      expect(response.json[:id]).to eq(category.id)
      expect(response.json[:kind]).to eq(payload[:kind])
      expect(response.json[:name]).to eq(payload[:name])
      expect(response.json[:colour_code]).to eq(payload[:colour_code])
      expect(response.json[:description]).to eq(payload[:description])
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
