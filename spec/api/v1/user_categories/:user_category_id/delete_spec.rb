require "rails_helper"

RSpec.describe "DELETE /v1/user_categories/:user_category_id" do
  subject { delete "/v1/user_categories/#{category.id}", headers: default_headers.merge(headers), params: {}.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let!(:user) { create(:user, email: "someone@mail.com") }
  let!(:category) { create(:user_category, user: user) }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)
      expect(UserCategory.exists?(category.id)).to be_falsy
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
