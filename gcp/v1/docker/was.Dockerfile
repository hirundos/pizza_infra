FROM node:22.16.0-bookworm
WORKDIR /app

COPY . .
RUN npm install -g pm2 && npm install -g npm@11.4.1 && npm install

EXPOSE 3000
CMD ["pm2-runtime", "start", "app.js"]