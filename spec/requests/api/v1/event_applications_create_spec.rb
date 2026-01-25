require 'rails_helper'

RSpec.describe "Api::V1::EventApplications", type: :request do
  let!(:user) { User.create!(name: 'test_user1', email: 'test_email1@email.com') }
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
  let(:headers) {
    { 'X-User-Id' => user.id.to_s }
  }

  describe "POST /api/v1/events/:event_id/event_applications" do
    context '異常系' do
      it "return 401 when unauthorized" do
        post "/api/v1/events/#{event_1.id}/event_applications"
        expect(response.status).to eq(401)
      end

      it "return 404 when Event not found" do
        post "/api/v1/events/99999/event_applications", headers: headers
        expect(response.status).to eq(404)

        body = JSON.parse(response.body)

        expect(body['error']).to eq('Event not found')
      end
      it "return 409 when duplicate application" do
        post "/api/v1/events/#{event_1.id}/event_applications", headers: headers
        post "/api/v1/events/#{event_1.id}/event_applications", headers: headers

        expect(response.status).to eq(409)
        body = JSON.parse(response.body)

        expect(body['error']).to eq("Already exists")
      end

      it "return 401 when X-User-Id is not exited" do
        post "/api/v1/events/#{event_1.id}/event_applications", headers: { 'X-User-Id' => '99999' }
        expect(response.status).to eq(401)
      end
    end

    context '正常系' do
      it "return 201 and create new application" do
        post "/api/v1/events/#{event_1.id}/event_applications", headers: headers
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)

        expect(body).to have_key('id')
        expect(body['status']).to eq('pending')
        expect(body['applied_at']).to be_present
        expect(body['canceled_at']).to be_nil
        expect(body).to have_key('event')
        expect(body['event']['id']).to eq(event_1.id)
      end

      it "creates a new EventApplication record" do
        expect {
          post "/api/v1/events/#{event_1.id}/event_applications", headers: headers
        }.to change { EventApplication.count }.by(1)
      end
    end
  end
end