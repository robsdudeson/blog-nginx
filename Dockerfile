FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY sites-available/robsdudeson.com.conf /etc/nginx/sites-available/robsdudeson.com.conf
RUN mkdir /etc/nginx/sites-enabled
RUN ln -sf /etc/nginx/sites-available/robsdudeson.com.conf /etc/nginx/sites-enabled/robsdudeson.com.conf

EXPOSE 80
