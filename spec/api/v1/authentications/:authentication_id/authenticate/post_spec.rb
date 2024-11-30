require "rails_helper"

RSpec.describe "POST /v1/authentications/:authentication_id/authenticate" do
  subject { post "/v1/authentications/#{authentication.id}/authenticate", headers: default_headers, params: payload.to_json }

  let(:payload) do
    {
      step: "password",
      data: {
        password: "qwerty"
      }
    }
  end

  let!(:user) { create(:user, email: "someone@mail.com", password: "qwerty") }

  let!(:authentication) { create(:authentication, step: :password, owner: user) }

  it "responds with 200" do
    subject

    expect(response.status).to eq(200)

    expect(response.json[:id]).to be_present
    expect(response.json[:step]).to eq("complete")

    expect(response.json[:prev_authentication][:id]).to eq(authentication.id)
    expect(response.json[:prev_authentication][:step]).to eq("password")
  end

  context "when authentication is completed" do
    before { authentication.update!(step: :complete) }

    it "responds with 422" do
      subject

      expect(response.status).to eq(422)
    end
  end

  context "when authentication is expired" do
    before { authentication.update!(expires_at: Time.zone.now - 1.hour) }

    it "responds with 422" do
      subject

      expect(response.status).to eq(422)
    end
  end

  context "when there is no authentication" do
    before { authentication.destroy! }

    it "responds with 422" do
      subject

      expect(response.status).to eq(422)
    end
  end

  context "when password is invalid" do
    let(:payload) do
      {
        step: "password",
        data: {
          password: "wrong"
        }
      }
    end

    it "responds with 422" do
      subject

      expect(response.status).to eq(422)
    end
  end
end
