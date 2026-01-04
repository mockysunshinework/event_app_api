Event.destroy_all

Event.create!(
  title: "Rails勉強会",
  starts_at: Time.zone.parse("2025-12-25 19:00"),
  location: "会議室A"
)

Event.create!(
  title: "セキュリティ研修",
  starts_at: Time.zone.parse("2026-01-10 10:00"),
  location: "オンライン"
)

User.destroy_all
EventApplication.destroy_all

u1 = User.create!(name: '田中 太郎', email: 'tanakataro@example.com')
u2 = User.create!(name: '山田 花子', email: 'yamadahanako@example.com')

e1 = Event.first
e2 = Event.second

EventApplication.create!(
  user: u1,
  event: e1,
  status: :confirmed,
  applied_at: Time.zone.now
)

EventApplication.create!(
  user: u1,
  event: e2,
  status: :pending,
  applied_at: Time.zone.now
)

EventApplication.create!(
  user: u2,
  event: e1,
  status: :pending,
  applied_at: Time.zone.now
)

EventApplication.create!(
  user: u2,
  event: e2,
  status: :pending,
  applied_at: Time.zone.now
)