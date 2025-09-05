# Sleep Tracker API (Rails 8)

## Features
- Track user sleep (`slept_at`, `woke_up_at`, `duration`)
- Follow/unfollow users
- Feeds: see sleep trackers of following/followers
- Pagination with Kaminari
- Dockerized for easy setup

- Redis & redis-mutex (SingleflightCache)
## Tech Stack
- Ruby 3.2.6
- Rails 8
- PostgreSQL
- Docker & Docker Compose
- Kaminari (pagination)
- Devise (authentication)
- Redis & redis-mutex (SingleflightCache)
- Devise (authentication)

## Architecture
This API follows a standard Rails MVC pattern:
- **Models**: User, SleepTracker, Follow
- **Controllers**: Handles RESTful endpoints for users, follows, sleep trackers, and feeds
- **Views**: Not used (API only)
- **Jobs/Mailers**: Structure present for background jobs and mailers
- **SingleflightCache**: Custom lib in `lib/singleflight_cache.rb` to prevent duplicate expensive computations using Redis and redis-mutex
- **Docker**: Containerized for easy deployment and local development


## Setup (Docker)

```bash
docker-compose build
docker-compose up
```

## Endpoints

### Users
- `DELETE /users/:user_id/unfollow/:id` – unfollow user
## Tech Stack
- Ruby 3.2.6
- Rails 8
- PostgreSQL
- Docker & Docker Compose
- Kaminari (pagination)
- Devise (authentication)
- Redis & redis-mutex (SingleflightCache)

## Example
```bash
- `GET /users/:user_id/feeds?type=followers|following|all&sort=duration&page=1&per_page=10`
