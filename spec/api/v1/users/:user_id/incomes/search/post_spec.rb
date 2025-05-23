require "rails_helper"

RSpec.describe "POST /v1/users/:user_id/incomes/search" do
  subject { post "/v1/users/#{user.id}/incomes/search", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {}
  end

  let!(:user) { create(:user, email: "someone@mail.com") }

  let!(:income_a) do
    create(
      :income,
      user: user,
      amount: Money.from_amount(100.0, "RSD"),
      categories: [category_a],
      created_at: 2.month.ago
    )
  end

  let!(:income_b) do
    create(
      :income,
      user: user,
      amount: Money.from_amount(200.0, "EUR"),
      categories: [category_b, category_d],
      created_at: 1.month.ago
    )
  end

  let!(:income_c) do
    create(
      :income,
      user: user,
      amount: Money.from_amount(60.0, "RSD"),
      categories: [category_c],
      created_at: 1.week.ago
    )
  end

  let!(:income_d) do
    create(
      :income,
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
      name: "Salary",
      kind: :income
    )
  end

  let!(:category_b) do
    create(
      :user_category,
      user: user,
      name: "Refunds",
      kind: :income
    )
  end

  let!(:category_c) do
    create(
      :user_category,
      user: user,
      name: "Cashback",
      kind: :income
    )
  end

  let!(:category_d) do
    create(
      :user_category,
      user: user,
      name: "Something else",
      kind: :income
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

        expect(response.json[:incomes].size).to eq(4)
        expect(response.json[:incomes][0][:id]).to eq(income_d.id)
        expect(response.json[:incomes][1][:id]).to eq(income_c.id)
        expect(response.json[:incomes][2][:id]).to eq(income_b.id)
        expect(response.json[:incomes][3][:id]).to eq(income_a.id)
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

          expect(response.json[:incomes].size).to eq(1)
          expect(response.json[:incomes][0][:id]).to eq(income_b.id)
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

          expect(response.json[:incomes].size).to eq(1)
          expect(response.json[:incomes][0][:id]).to eq(income_c.id)
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

            expect(response.json[:incomes].size).to eq(2)
            expect(response.json[:incomes][0][:id]).to eq(income_d.id)
            expect(response.json[:incomes][1][:id]).to eq(income_b.id)
          end

          context "when payload contains amount borders" do
            before do
              payload[:amount][:more] = 100.0
              payload[:amount][:less] = 200.0
            end

            it "responds with 200" do
              subject

              expect(response.status).to eq(200)

              expect(response.json[:incomes].size).to eq(1)
              expect(response.json[:incomes][0][:id]).to eq(income_d.id)
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

          expect(response.json[:incomes].size).to eq(2)
          expect(response.json[:incomes][0][:id]).to eq(income_d.id)
          expect(response.json[:incomes][1][:id]).to eq(income_a.id)
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
