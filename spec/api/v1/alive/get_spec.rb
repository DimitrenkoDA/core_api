require "rails_helper"

RSpec.describe "GET /v1/alive" do
  subject { get "/v1/alive", headers: default_headers.merge(headers) }

  let(:headers) do
    {}
  end

  it "responds with 200" do
    subject

    expect(response.status).to eq(200)

    expect(response.json[:time]).to be_present
    expect(response.json[:env]).to eq("test")
    expect(response.json[:locale]).to eq("en")
    expect(response.json[:db][:version]).to be_present
  end
end
