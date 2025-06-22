require "rails_helper"

RSpec.describe "POST /v1/users/:user_id/contacts" do
  subject { post "/v1/users/#{owner.id}/contacts", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {
      associated_id: user.id
    }
  end

  let!(:owner) { create(:user, email: "someone@mail.com") }
  let!(:user) { create(:user) }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(owner) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to be_present
      expect(response.json[:owner_id]).to eq(owner.id)
      expect(response.json[:user][:id]).to eq(user.id)
      expect(response.json[:created_at]).to be_present
      expect(response.json[:updated_at]).to be_present
    end

    context "when contact already created" do
      let!(:contact) { create(:contact, owner: owner, user: user) }

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)
        expect(Contact.count).to eq(1)
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
