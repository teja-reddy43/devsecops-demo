# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Update Alpine packages to avoid vulnerabilities
RUN apk update && apk upgrade --no-cache

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Update Alpine packages in the production stage to fix vulnerabilities
RUN apk update && apk upgrade --no-cache

COPY --from=build /app/dist /usr/share/nginx/html

# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
