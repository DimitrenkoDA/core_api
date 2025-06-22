require "rails_helper"

RSpec.describe "POST /v1/users/:user_id/contacts/search" do
  subject { post "/v1/users/#{session_owner.id}/contacts/search", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {}
  end

  let!(:session_owner) do
    create(
      :user,
      email: "someone@mail.com"
    )
  end

  let!(:user_a) do
    create(
      :user,
      first_name: "Albert",
      last_name: "Einstein",
      email: "albert.einstein@gmail.com"
    )
  end

  let!(:user_b) do
    create(
      :user,
      first_name: "Boris",
      last_name: "Razor",
      email: "boris.razor@gmail.com"
    )
  end

  let!(:user_c) do
    create(
      :user,
      first_name: "Chris",
      last_name: "Hemsworth",
      email: "chris.hemsworth@gmail.com"
    )
  end

  let!(:user_d) do
    create(
      :user,
      first_name: "David",
      last_name: "Beckham",
      email: "david.beckham@gmail.com"
    )
  end

  let!(:contact_a) { create(:contact, owner: session_owner, user: user_a) }
  let!(:contact_b) { create(:contact, owner: session_owner, user: user_b) }
  let!(:contact_c) { create(:contact, owner: session_owner, user: user_c) }
  let!(:contact_d) { create(:contact, owner: session_owner, user: user_d) }

  let(:now) { Time.parse("2025-01-01T00:00:00+02:00") }

  around do |example|
    Timecop.freeze(now) { example.run }
  end

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(session_owner) }

    context "when payload is empty" do
      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:contacts].size).to eq(4)
        expect(response.json[:contacts][0][:id]).to eq(contact_a.id)
        expect(response.json[:contacts][1][:id]).to eq(contact_b.id)
        expect(response.json[:contacts][2][:id]).to eq(contact_c.id)
        expect(response.json[:contacts][3][:id]).to eq(contact_d.id)
      end
    end

    context "when payload is not empty" do
      context "when query contains part of the email" do
        let(:payload) do
          {
            query: "albert."
          }
        end

        it "responds with 200" do
          subject

          expect(response.status).to eq(200)

          expect(response.json[:contacts].size).to eq(1)
          expect(response.json[:contacts][0][:id]).to eq(contact_a.id)
        end
      end

      context "when query contains part of the first name" do
        let(:payload) do
          {
            query: "Chri"
          }
        end

        it "responds with 200" do
          subject

          expect(response.status).to eq(200)

          expect(response.json[:contacts].size).to eq(1)
          expect(response.json[:contacts][0][:id]).to eq(contact_c.id)
        end
      end

      context "when query contains part of the last name" do
        let(:payload) do
          {
            query: "Raz"
          }
        end

        it "responds with 200" do
          subject

          expect(response.status).to eq(200)

          expect(response.json[:contacts].size).to eq(1)
          expect(response.json[:contacts][0][:id]).to eq(contact_b.id)
        end
      end
    end

    context "when payload contains some filters" do
      context "when limit and offset specified" do
        let(:payload) do
          {
            limit: 1,
            offset: 2
          }
        end

        it "responds with 200" do
          subject

          expect(response.status).to eq(200)

          expect(response.json[:contacts].size).to eq(1)
          expect(response.json[:contacts][0][:id]).to eq(contact_c.id)
        end
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
