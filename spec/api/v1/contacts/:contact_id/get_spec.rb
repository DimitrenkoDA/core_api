require "rails_helper"

RSpec.describe "GET /v1/contacts/:contact_id" do
  subject { get "/v1/contacts/#{contact.id}", headers: default_headers.merge(headers) }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let!(:owner) { create(:user) }
  let!(:user) { create(:user) }
  let!(:contact) { create(:contact, owner: owner, user: user) }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(owner) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to eq(contact.id)
    end
  end

  context "when someone else trying to get user's transaction" do
    let!(:access_token) { System::Session.token(user) }

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
