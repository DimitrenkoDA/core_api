require "rails_helper"

RSpec.describe "PATCH /v1/incomes/:income_id" do
  subject { patch "/v1/incomes/#{income.id}", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {
      amount: {
        value: 70.0,
        currency: "USD"
      },
      note: "Other note"
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

  let!(:category_a) { create(:user_category, user: user, name: "Salary") }
  let!(:category_b) { create(:user_category, user: user, name: "Work 1") }

  let!(:income) do
    create(
      :income,
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

      expect(response.json[:id]).to eq(income.id)
      expect(response.json[:user_id]).to eq(user.id)
      expect(response.json[:amount][:value]).to eq(70.0)
      expect(response.json[:amount][:currency]).to eq("USD")
      expect(response.json[:note]).to eq(payload[:note])
      expect(response.json[:created_at]).to be_present
      expect(response.json[:updated_at]).to be_present
      expect(response.json[:categories]).to be_present

      expect(transaction.reload.amount).to eq(Money.from_amount(70, "USD"))
      expect(user.reload.balances).to eq({ "USD" => 70.0 })
    end

    context "when need to nullify categories" do
      before { payload[:category_ids] = [] }

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(income.reload.categories).to be_empty
      end
    end

    context "when needs to update categories" do
      let!(:category_c) { create(:user_category, user: user) }
      let!(:category_d) { create(:user_category, user: user) }

      before { payload[:category_ids] = [category_c.id, category_d.id] }

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)
        expect(response.json[:categories].map { |c| c[:id] }).to contain_exactly(category_c.id, category_d.id)
      end
    end

    context "when currency in unknown" do
      before { payload[:amount][:currency] = "foo" }

      it "responds with 422" do
        subject

        expect(response.status).to eq(422)
      end
    end
  end

  context "when someone else trying to update income details" do
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
