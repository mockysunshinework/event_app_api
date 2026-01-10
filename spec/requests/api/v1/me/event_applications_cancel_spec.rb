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
  describe "PATCH /api/v1/me/event_applications/:id/cancel" do
    it 'returns 401' do
      patch "/api/v1/me/event_applications/#{event_application_1.id}/cancel"
      expect(response.status).to eq(401)
    end

    it "does not cancel other user's applications" do
      patch "/api/v1/me/event_applications/#{other_application.id}/cancel", headers: headers
      expect(response.status).to eq(404)
    end

    it "does not re-cancel own applications" do
      patch "/api/v1/me/event_applications/#{event_application_2.id}/cancel", headers: headers
      expect(response.status).to eq(409)
    end
  end
end
