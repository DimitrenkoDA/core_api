require "rails_helper"

RSpec.describe "POST /v1/users/:user_id/categories" do
  subject { post "/v1/users/#{user.id}/categories", headers: default_headers.merge(headers), params: payload.to_json }

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
      description: "Taxi services like Uber, Yandex, etc",
    }
  end

  let!(:user) { create(:user, email: "someone@mail.com") }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to be_present
      expect(response.json[:kind]).to eq(payload[:kind])
      expect(response.json[:name]).to eq(payload[:name])
      expect(response.json[:colour_code]).to eq(payload[:colour_code])
      expect(response.json[:description]).to eq(payload[:description])
    end

    context "when colour code format is invalid" do
      before { payload[:colour_code] = "invalid" }

      it "responds with 422" do
        subject

        expect(response.status).to eq(422)
      end
    end

    context "when name is not uniq" do
      let(:category) { create(:user_category, user: user) }

      before { payload[:name] = category.name }

      it "responds with 422" do
        subject

        expect(response.status).to eq(422)
      end
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
