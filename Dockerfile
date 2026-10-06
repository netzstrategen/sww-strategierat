# Stufe 1: statische Seite bauen
FROM node:22-alpine AS build
WORKDIR /app
ENV ASTRO_TELEMETRY_DISABLED=1
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stufe 2: mit nginx ausliefern, ohne Zugriffsprotokolle (siehe Datenschutzerklärung)
FROM nginx:1.27-alpine
# htpasswd für den optionalen Zugangsschutz (siehe docker/40-basic-auth.sh)
RUN apk add --no-cache apache2-utils
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY docker/40-basic-auth.sh /docker-entrypoint.d/40-basic-auth.sh
RUN chmod 755 /docker-entrypoint.d/40-basic-auth.sh
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
