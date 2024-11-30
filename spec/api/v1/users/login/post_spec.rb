require "rails_helper"

RSpec.describe "POST /v1/users/login" do
  subject { post "/v1/users/login", headers: default_headers, params: payload.to_json }

  let(:payload) do
    {
      email: "someone@mail.com"
    }
  end

  let!(:user) { create(:user, email: "someone@mail.com") }

  it "responds with 200" do
    subject

    expect(response.status).to eq(200)

    expect(response.json[:id]).to be_present
    expect(response.json[:step]).to eq("password")
  end

  context "when rider with such email does not exist" do
    let(:payload) do
      {
        email: "someone@else.com"
      }
    end

    it "responds with 200" do
      subject

      expect(response.status).to eq(422)
    end
  end
end
