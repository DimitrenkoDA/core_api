require "rails_helper"

RSpec.describe "GET /v1/users/:user_id/transactions" do
  subject { get "/v1/users/#{user.id}/transactions", headers: default_headers.merge(headers), params: params }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:params) do
    {}
  end

  let(:user) { create(:user) }

  let!(:transaction_a) do
    create(
      :transaction,
      user: user,
      polarity: :debit,
      amount: Money.from_amount(100, "EUR"),
      created_at: 3.days.ago
    )
  end

  let!(:transaction_b) do
    create(
      :transaction,
      user: user,
      polarity: :credit,
      amount: Money.from_amount(80, "EUR"),
      created_at: 2.days.ago
    )
  end

  let!(:transaction_c) do
    create(
      :transaction,
      user: user,
      polarity: :debit,
      amount: Money.from_amount(50, "EUR"),
      created_at: 1.days.ago
    )
  end


  context "when user is admin" do
    let!(:access_token) { System::Session.token(user) }

    it "responds with 200" do
      subject

      expect(response.status).to eq(200)

      expect(response.json[:transactions].size).to eq(3)
      expect(response.json[:transactions][0][:id]).to eq(transaction_c.id)
      expect(response.json[:transactions][1][:id]).to eq(transaction_b.id)
      expect(response.json[:transactions][2][:id]).to eq(transaction_a.id)

      expect(response.json[:params]).to be_present
    end

    context "when polarity is specified" do
      let(:params) do
        {
          polarity: :credit
        }
      end

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:transactions].size).to eq(1)
        expect(response.json[:transactions][0][:id]).to eq(transaction_b.id)

        expect(response.json[:params]).to be_present
      end
    end

    context "when time borders are specified" do
      let(:params) do
        {
          from: 4.days.ago,
          till: 2.days.ago
        }
      end

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:transactions].size).to eq(1)
        expect(response.json[:transactions][0][:id]).to eq(transaction_a.id)

        expect(response.json[:params]).to be_present
      end
    end

    context "when amount borders are specified" do
      let(:params) do
        {
          less: 9000,
          more: 6000
        }
      end

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:transactions].size).to eq(1)
        expect(response.json[:transactions][0][:id]).to eq(transaction_b.id)

        expect(response.json[:params]).to be_present
      end
    end

    context "when limit and offset are specified" do
      let(:params) do
        {
          limit: 1,
          offset: 2
        }
      end

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:transactions].size).to eq(1)
        expect(response.json[:transactions][0][:id]).to eq(transaction_a.id)

        expect(response.json[:params][:limit]).to eq(1)
        expect(response.json[:params][:offset]).to eq(2)
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
