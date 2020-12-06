# Build Image
FROM node:14.15.1 AS base

# install node-prune
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# remove development dependencies
RUN npm prune --production
RUN /usr/local/bin/node-prune


FROM node:14.15.1-alpine
WORKDIR /app
USER node

# copy from base
COPY --from=base /app/dist ./dist
COPY --from=base /app/node_modules ./node_modules

ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
