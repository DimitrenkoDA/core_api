require "rails_helper"

RSpec.describe "POST /v1/users/sign_up" do
  subject { post "/v1/users/sign_up", headers: default_headers, params: payload.to_json }

  let(:payload) do
    {
      email: "someone@mail.com",
      password: "password",
      password_confirmation: "password",
    }
  end

  it "responds with 200" do
    subject

    expect(response.status).to eq(200)

    expect(response.json[:id]).to be_present
    expect(response.json[:email]).to eq("someone@mail.com")
  end

  context "when personal information provided in payload" do
    before do
      payload[:first_name] = Faker::Name.first_name
      payload[:last_name] = Faker::Name.last_name
    end

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to be_present
      expect(response.json[:email]).to eq("someone@mail.com")
      expect(response.json[:first_name]).to eq(payload[:first_name])
      expect(response.json[:last_name]).to eq(payload[:last_name])
    end
  end

  context "when rider with such email already exists" do
    before { create(:user, email: "someone@mail.com") }

    it "responds with 422" do
      subject

      expect(response.status).to eq(422)
    end
  end

  context "when password and confirmation don't match" do
    before { payload[:password_confirmation] = "100500" }

    it "responds with 422" do
      subject

      expect(response.status).to eq(422)
    end
  end
end
