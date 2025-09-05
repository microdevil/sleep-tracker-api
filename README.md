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




## Environment Variables

Before running the application, ensure the following environment variables are set (e.g., in a `.env` file or your deployment environment):


```env
DB_NAME=db_name
DB_USER=db_user
DB_PASSWORD=db_password
DB_HOST=db_host
DB_PORT=db_port
DEVISE_JWT_SECRET_KEY=your_devise_jwt_secret_key
REDIS_URL=redis://localhost:6379/0
```

- `DB_NAME` – Database name
- `DB_USER` – Database user
- `DB_PASSWORD` – Database password
- `DB_HOST` – Database host
- `DB_PORT` – Database port

- `DEVISE_JWT_SECRET_KEY` – Secret key for Devise JWT authentication
- `REDIS_URL` – Redis connection string

Other variables may be required depending on your configuration (see `config/database.yml`, `config/credentials.yml.enc`, and Docker setup).

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
