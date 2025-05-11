require "rails_helper"

RSpec.describe "POST /v1/users/:user_id/payments" do
  subject { post "/v1/users/#{user.id}/payments", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {
      amount: {
        value: 100.0,
        currency: "RSD"
      },
      note: "Something",
      category_ids: [category_a.id, category_b.id]
    }
  end

  let!(:user) { create(:user, email: "someone@mail.com") }

  let!(:category_a) { create(:user_category, user: user, name: "Salary") }
  let!(:category_b) { create(:user_category, user: user, name: "Work 1") }

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:id]).to be_present
      expect(response.json[:user_id]).to eq(user.id)
      expect(response.json[:amount][:value]).to eq(100.0)
      expect(response.json[:amount][:currency]).to eq("RSD")
      expect(response.json[:created_at]).to be_present
      expect(response.json[:updated_at]).to be_present
      expect(response.json[:categories].map { |c| c[:id] }).to contain_exactly(category_a.id, category_b.id)

      expect(user.transactions.last.amount).to eq(Money.from_amount(-100, "RSD"))
      expect(user.reload.balances).to eq({ "RSD" => -100.0 })
    end

    context "when currency in unknown" do
      before { payload[:amount][:currency] = "foo" }

      it "responds with 422" do
        subject

        expect(response.status).to eq(422)
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
