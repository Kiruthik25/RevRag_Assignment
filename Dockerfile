
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm ci && npm cache clean --force

COPY . .

RUN npm run build

# ---------- Stage 2  ----------
FROM node:20-alpine

WORKDIR /app

COPY  package.json package-lock.json* ./

# Install ONLY production dependencies
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

RUN apk add --no-cache curl

USER node

EXPOSE 3000

CMD ["node", "dist/server.js"]
