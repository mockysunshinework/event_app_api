# Event App API

Simple event application API built with Rails.
---

## Authentication

This API uses a simple header based authentication.

## Header

X-User-Id: <user_id>

## Rules

- Header is required for protected endpoints
- Must be numeric
- Must exist In user table
- Otherwise returns 401 Unorthorized

---

## Events

### GET	/api/v1/events

#### Response 200

```json
[
  {
    "id": 3,
    "title": "Rails勉強会",
    "starts_at": "2025-12-25T19:00:00.000Z",
    "location": "会議室A",
    "created_at": "2026-01-01T14:13:28.109Z",
    "updated_at": "2026-01-01T14:13:28.109Z"
  },
  {
    "id": 4,
    "title": "セキュリティ研修",
    "starts_at": "2026-01-10T10:00:00.000Z",
    "location": "オンライン",
    "created_at": "2026-01-01T14:13:28.112Z",
    "updated_at": "2026-01-01T14:13:28.112Z"
  },
  {
    "id": 5,
    "title": "test3",
    "starts_at": "2026-01-03T01:47:12.885Z",
    "location": "おんらいん",
    "created_at": "2026-01-03T01:47:12.886Z",
    "updated_at": "2026-01-03T01:47:12.886Z"
  }
]
```

## Create Event Application

### POST	/api/v1/events/:event_id/event_applications

#### Success

201(成功)

```json
{
  "id": 5,
  "status": "pending",
  "applied_at": "2026-01-25T11:41:12.613Z",
  "canceled_at": null,
  "event": {
    "id": 3,
    "title": "子育て研修",
    "starts_at": "2026-01-25T10:00:00.000Z",
    "location": "オンライン"
  }
}
```
#### Error

- 401 Unauthorized
- 404 Event not found
- 409 Already exists # UNIQUE(event_id, user_id) に引っかかった場合（同じイベントに二重申込）

## My EventApplication

### Success

#### GET	/api/v1/me/event_applications


200
```json
[
  {
    "id": 5,
    "status": "pending",
    "applied_at": "2026-01-25T11:41:12.613Z",
    "canceled_at": null,
    "event": {
      "id": 3,
      "title": "子育て研修",
      "starts_at": "2026-01-25T10:00:00.000Z",
      "location": "オンライン"
    }
  },
  {
    "id": 2,
    "status": "pending",
    "applied_at": "2026-01-25T11:04:45.289Z",
    "canceled_at": null,
    "event": {
      "id": 2,
      "title": "セキュリティ研修",
      "starts_at": "2026-01-10T10:00:00.000Z",
      "location": "オンライン"
    }
  },
  {
    "id": 1,
    "status": "confirmed",
    "applied_at": "2026-01-25T11:04:45.276Z",
    "canceled_at": null,
    "event": {
      "id": 1,
      "title": "Rails勉強会",
      "starts_at": "2025-12-25T19:00:00.000Z",
      "location": "会議室A"
    }
  }
]
```
Filter By Status
#### GET /api/v1/me/event_applications?status=confirmed

200

```json
[
  {
    "id": 1,
    "status": "confirmed",
    "applied_at": "2026-01-25T11:04:45.276Z",
    "canceled_at": null,
    "event": {
      "id": 1,
      "title": "Rails勉強会",
      "starts_at": "2025-12-25T19:00:00.000Z",
      "location": "会議室A"
    }
  }
]
```


#### Error
400 Invalid status 不正なstatus

```json
{
  "error": "Invalid status"
}
```


