
# Base image with Ruby 3.2.6 (matches .ruby-version)
FROM ruby:3.2.6

# Install Node.js (for Rails asset pipeline), PostgreSQL client, and Redis client
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client redis-tools

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock, then install dependencies
COPY Gemfile Gemfile.lock /app/
RUN bundle install

# Copy application code
COPY . /app

# Expose Rails server port
EXPOSE 3000

# Start Rails server (Rails 8)
CMD ["rails", "server", "-b", "0.0.0.0"]
