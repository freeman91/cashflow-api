require 'spec_helper'
require 'date'

describe Api::V1::VersionsController, type: :controller do
  let(:user) { create :user }
  before(:each) do
    request.headers['Accept'] = "application/vnd.railsapibase.v1"
    sign_in_user user
  end

  it "routes correctly" do
    expect(get: "/versions/expiration").to route_to("api/v1/versions#expiration", format: :json)
  end

  describe "GET /versions/:id #show" do
    context "when expiration date exists" do
      before(:each) { signed_get :expiration, nil }

      it "returns expiration message" do
        expect(json_response['errors'][0]['message']).to eq I18n.t('version.expiration',
                                          { expiration_date: 1.month.from_now.strftime('%x') })
      end

      it { expect(response.status).to eq 200 }
    end
  end
end
