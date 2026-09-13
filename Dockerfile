# Since app is already compiled pulling light image to run the app
FROM nginx:alpine

# Copy pre-built static files directly to Nginx web root
COPY dist /usr/share/nginx/html

# Expose default Nginx port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
