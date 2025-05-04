FROM node:22-alpine AS build

WORKDIR /build

COPY ["package.json", "package-lock.json", "./"]

RUN npm install --quiet

COPY . .

RUN npm run build

FROM node:22-alpine

LABEL org.opencontainers.image.title="Nostream"
LABEL org.opencontainers.image.source=https://github.com/cameri/nostream
LABEL org.opencontainers.image.description="nostream"
LABEL org.opencontainers.image.authors="Ricardo Arturo Cabral Mejía"
LABEL org.opencontainers.image.licenses=MIT

WORKDIR /app
RUN apk add --no-cache --update git

ADD resources /app/resources

COPY --from=build /build/dist .

RUN npm install --omit=dev --quiet

USER node:node

CMD ["node", "src/index.js"]
