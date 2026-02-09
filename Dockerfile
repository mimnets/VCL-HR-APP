# -------------------
# BUILD STAGE
# -------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first → better caching
COPY package*.json ./

# Install ALL deps (devDeps included) → do NOT set NODE_ENV=production here!
RUN npm ci

# Copy the rest of your code
COPY . .

# Build the app → creates /app/dist
RUN npm run build

# -------------------
# PRODUCTION STAGE (static serving)
# -------------------
FROM nginx:alpine

# Copy built static files from builder
COPY --from=builder /app/dist /usr/share/nginx/html

    
    EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]