# Use an official Ruby runtime as a parent image
FROM ruby:3.3

# Install Node.js
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g yarn

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the image and install ruby dependencies
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install

# Install yarn dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the static site (e.g., using Jekyll)
RUN bin/build --production

# Use an official Nginx image to serve the static site
FROM nginx:stable

# Copy the static site files to the Nginx HTML directory
COPY --from=0 /app/build /usr/share/nginx/html

# Expose port 80 to the Docker host
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
