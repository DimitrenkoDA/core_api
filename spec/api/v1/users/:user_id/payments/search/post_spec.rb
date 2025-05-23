require "rails_helper"

RSpec.describe "POST /v1/users/:user_id/payments/search" do
  subject { post "/v1/users/#{user.id}/payments/search", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {}
  end

  let!(:user) { create(:user, email: "someone@mail.com") }

  let!(:payment_a) do
    create(
      :payment,
      user: user,
      amount: Money.from_amount(100.0, "RSD"),
      categories: [category_a],
      created_at: 2.month.ago
    )
  end

  let!(:payment_b) do
    create(
      :payment,
      user: user,
      amount: Money.from_amount(200.0, "EUR"),
      categories: [category_b, category_d],
      created_at: 1.month.ago
    )
  end

  let!(:payment_c) do
    create(
      :payment,
      user: user,
      amount: Money.from_amount(60.0, "RSD"),
      categories: [category_c],
      created_at: 1.week.ago
    )
  end

  let!(:payment_d) do
    create(
      :payment,
      user: user,
      amount: Money.from_amount(160.0, "EUR"),
      categories: [category_a],
      created_at: 1.day.ago
    )
  end

  let!(:category_a) do
    create(
      :user_category,
      user: user,
      name: "Gym",
      kind: :payment
    )
  end

  let!(:category_b) do
    create(
      :user_category,
      user: user,
      name: "Sport",
      kind: :payment
    )
  end

  let!(:category_c) do
    create(
      :user_category,
      user: user,
      name: "Cloth",
      kind: :payment
    )
  end

  let!(:category_d) do
    create(
      :user_category,
      user: user,
      name: "Shops",
      kind: :payment
    )
  end

  let(:now) { Time.parse("2025-01-01T00:00:00+02:00") }

  around do |example|
    Timecop.freeze(now) { example.run }
  end

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    context "when payload is empty" do
      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:payments].size).to eq(4)
        expect(response.json[:payments][0][:id]).to eq(payment_d.id)
        expect(response.json[:payments][1][:id]).to eq(payment_c.id)
        expect(response.json[:payments][2][:id]).to eq(payment_b.id)
        expect(response.json[:payments][3][:id]).to eq(payment_a.id)
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

          expect(response.json[:payments].size).to eq(1)
          expect(response.json[:payments][0][:id]).to eq(payment_b.id)
        end
      end

      context "when payload contains time frames" do
        let(:payload) do
          {
            from: "2024-12-20T00:00:00.000Z",
            till: "2024-12-30T00:00:00.000Z"
          }
        end

        it "responds with 200" do
          subject

          expect(response.status).to eq(200)

          expect(response.json[:payments].size).to eq(1)
          expect(response.json[:payments][0][:id]).to eq(payment_c.id)
        end
      end

      context "when payload contains amount" do
        let(:payload) do
          {
            amount: {}
          }
        end

        context "when payload contains currency" do
          before { payload[:amount][:currency] = "EUR" }

          it "responds with 200" do
            subject

            expect(response.status).to eq(200)

            expect(response.json[:payments].size).to eq(2)
            expect(response.json[:payments][0][:id]).to eq(payment_d.id)
            expect(response.json[:payments][1][:id]).to eq(payment_b.id)
          end

          context "when payload contains amount borders" do
            before do
              payload[:amount][:more] = 100.0
              payload[:amount][:less] = 200.0
            end

            it "responds with 200" do
              subject

              expect(response.status).to eq(200)

              expect(response.json[:payments].size).to eq(1)
              expect(response.json[:payments][0][:id]).to eq(payment_d.id)
            end
          end
        end
      end

      context "when payload contains categories" do
        let(:payload) do
          {
            category_ids: [category_a.id],
          }
        end

        it "responds with 200" do
          subject

          expect(response.status).to eq(200)

          expect(response.json[:payments].size).to eq(2)
          expect(response.json[:payments][0][:id]).to eq(payment_d.id)
          expect(response.json[:payments][1][:id]).to eq(payment_a.id)
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
