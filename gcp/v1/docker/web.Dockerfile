FROM nginx:bookworm

COPY . /usr/share/nginx/front
COPY .docker/nginx/default /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
