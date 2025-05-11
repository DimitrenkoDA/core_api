require "rails_helper"

RSpec.describe "GET /v1/payments/:payment_id" do
  subject { get "/v1/payments/#{payment.id}", headers: default_headers.merge(headers) }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let!(:user) { create(:user) }

  let!(:transaction) do
    create(
      :transaction,
      user: user,
      amount: Money.from_amount(100, "EUR")
    )
  end

  let!(:category_a) { create(:user_category, user: user, name: "Taxi") }
  let!(:category_b) { create(:user_category, user: user, name: "Yandex") }

  let!(:payment) do
    create(
      :payment,
      user: user,
      balance_transaction: transaction,
      categories: [category_a, category_b]
    )
  end

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to eq(payment.id)
      expect(response.json[:user_id]).to eq(user.id)
      expect(response.json[:amount][:value]).to eq(100.0)
      expect(response.json[:amount][:currency]).to eq("EUR")
      expect(response.json[:created_at]).to be_present
      expect(response.json[:updated_at]).to be_present
      expect(response.json[:categories]).to be_present
    end
  end

  context "when someone else trying to get payment details" do
    let!(:another_user) { create(:user) }
    let!(:access_token) { System::Session.token(another_user) }

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
