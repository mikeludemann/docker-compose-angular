FROM node:alpine AS development

ENV NODE_ENV development

# Add a work directory
WORKDIR /app

# Cache dependencies
COPY package*.json .

# Install dependencies
RUN npm install

# Copy app files
COPY . .

# Expose port
EXPOSE 4200

# Start the app
CMD [ "npm", "run", "start" ]

FROM node:alpine AS production

ENV NODE_ENV production

# Add a work directory
WORKDIR /app

# Cache dependencies
COPY package*.json .

# Install dependencies
RUN npm install

# Copy app files
COPY . .

# Build the application
RUN npm run build

# ------------------------------------------------

FROM httpd:alpine as server

# Server path
WORKDIR /usr/local/apache2/htdocs

# Copy
COPY --from=production /app/build .

# Start the app
CMD [ "sudo", "service", "apache2", "restart" ]
