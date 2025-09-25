# Use nginx to serve static site on internal port 8080
FROM nginx:alpine

# Configure nginx to listen on 8080
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf \
    && sed -i 's@root   /usr/share/nginx/html;@root   /usr/share/nginx/html;@' /etc/nginx/conf.d/default.conf

# Copy site content
COPY . /usr/share/nginx/html

# Adjust file permissions
RUN chmod -R 755 /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"] 