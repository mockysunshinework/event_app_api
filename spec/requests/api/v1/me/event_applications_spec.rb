require 'rails_helper'

RSpec.describe "Api::V1::Me::EventApplications", type: :request do
  let!(:user) { User.create!(name: 'test_user1', email: 'test_email1@email.com') }
  let!(:other_user) { User.create!(name: 'test_user2', email: 'test_email2@email.com') }

  let!(:event_1) {
    Event.create!(
      title: 'test_ev_title1',
      starts_at: '2026-01-05 09:00',
      location: 'online',
    )
  }
  let!(:event_2) {
    Event.create!(
      title: 'test_ev_title2',
      starts_at: '2026-01-06 09:00',
      location: 'online',
    )
  }

  let!(:event_application_1) {
    EventApplication.create!(
      user: user,
      event: event_1,
      status: :pending,
      applied_at: '2026-01-03 09:00',
    )
  }

  let!(:event_application_2) {
    EventApplication.create!(
      user: user,
      event: event_2,
      status: :canceled,
      applied_at: '2026-01-04 09:00',
    )
  }

  # other_userの申し込み情報
  let!(:other_application) {
    EventApplication.create!(
      user: other_user,
      event: event_1,
      status: :pending,
      applied_at: '2026-01-05 09:00',
    )
  }

  let(:headers) {
    { 'X-User-Id' => user.id.to_s }
  }
  describe "GET /api/v1/me/event_applications" do
    it 'returns 200' do
      get '/api/v1/me/event_applications', headers: headers
      expect(response.status).to eq(200)
    end

    it 'returns 401 when unaauthorized' do
      get '/api/v1/me/event_applications'
      expect(response.status).to eq(401)
    end

    it 'returns applications with event data' do
      get '/api/v1/me/event_applications', headers: headers

      body = JSON.parse(response.body)

      expect(body.length).to eq(2)
      expect(body).to all(have_key('event'))
    end

    it 'filters applications by status=pending' do
      get '/api/v1/me/event_applications', headers: headers, params: {status: 'pending' }

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body.length).to eq(1)
      expect(body.first).to have_key('status')
      expect(body.first['status']).to eq('pending')
    end

    it "does not include other user's applications" do
      get '/api/v1/me/event_applications', headers: headers

      body = JSON.parse(response.body)
      ids = body.map { |h| h['id'] }

      expect(ids).not_to include(other_application.id)
    end

    it "return 401 when X-UserId is not existed" do
      get '/api/v1/me/event_applications', headers: { 'X-User-Id' => '99999' }
      expect(response.status).to eq(401)

      body = JSON.parse(response.body)
      expect(body['error']).to eq('Unauthorized')
    end

    it "return 401 when X-User-Id is invalid format" do
      get '/api/v1/me/event_applications', headers: { 'X-User-Id' => 'abc' }
      expect(response.status).to eq(401)

      body = JSON.parse(response.body)
      expect(body['error']).to eq('Unauthorized')
    end
  end
end