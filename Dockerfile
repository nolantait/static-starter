# Use an official Ruby runtime based on Alpine as a parent image
FROM ruby:3.3-alpine AS builder

ENV RACK_ENV=production
ENV NODE_ENV=production

# Install necessary packages including Node.js and Yarn
RUN apk add --no-cache build-base nodejs npm git && \
    npm install -g yarn

# Set the working directory
WORKDIR /app

# Copy Gemfile and other necessary files
COPY Gemfile Gemfile.lock .ruby-version package.json yarn.lock ./

# Install dependencies
RUN bundle install --without development test && \
    yarn install --frozen-lockfile && \
    rm -rf /root/.bundle/cache /usr/local/bundle/cache /var/cache/apk/*

# Copy the rest of the application code
COPY . .

# Build the static site (e.g., using Jekyll)
RUN bin/rake site:build

# Use an official Nginx image based on Alpine to serve the static site
FROM nginx:stable-alpine

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the static site files to the Nginx HTML directory
COPY --from=builder /app/build /usr/share/nginx/html/

# Expose port 80 to the Docker host
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
