require "rails_helper"

RSpec.describe "DELETE /v1/contacts/:contact_id" do
  subject { delete "/v1/contacts/#{contact.id}", headers: default_headers.merge(headers), params: {}.to_json }

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
      expect(Contact.exists?(contact.id)).to be_falsy
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
