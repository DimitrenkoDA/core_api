require "rails_helper"

RSpec.describe "POST /v1/users/:user_id/categories/search" do
  subject { post "/v1/users/#{user.id}/categories/search", headers: default_headers.merge(headers), params: payload.to_json }

  let(:headers) do
    {
      "X-Access-Token" => access_token
    }
  end

  let(:payload) do
    {}
  end

  let!(:user) { create(:user, email: "someone@mail.com") }

  let!(:category_a) do
    create(
      :user_category,
      user: user,
      name: "Taxi",
      kind: :payment,
      created_at: 1.day.ago
    )
  end

  let!(:category_b) do
    create(
      :user_category,
      user: user,
      name: "Gym",
      kind: :payment,
      created_at: 1.hour.ago
    )
  end

  let!(:category_c) do
    create(
      :user_category,
      user: user,
      name: "Tax refunds",
      kind: :income,
      created_at: 10.minutes.ago
    )
  end

  context "when current session owner is user" do
    let!(:access_token) { System::Session.token(user) }

    context "when payload is empty" do
      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:categories].size).to eq(3)
        expect(response.json[:categories][0][:id]).to eq(category_c.id)
        expect(response.json[:categories][1][:id]).to eq(category_b.id)
        expect(response.json[:categories][2][:id]).to eq(category_a.id)
      end
    end

    context "when payload contains category id" do
      let(:payload) do
        {
          query: category_c.id.to_s
        }
      end

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:categories].size).to eq(1)
        expect(response.json[:categories][0][:id]).to eq(category_c.id)
      end
    end

    context "when payload contains part of name" do
      let(:payload) do
        {
          query: "T"
        }
      end

      it "responds with 200" do
        subject

        expect(response.status).to eq(200)

        expect(response.json[:categories].size).to eq(2)
        expect(response.json[:categories][0][:id]).to eq(category_c.id)
        expect(response.json[:categories][1][:id]).to eq(category_a.id)
      end

      context "when payload contains kinds for filtering" do
        before { payload[:kinds] = ["income"] }

        it "responds with 200" do
          subject

          expect(response.status).to eq(200)

          expect(response.json[:categories].size).to eq(1)
          expect(response.json[:categories][0][:id]).to eq(category_c.id)
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
