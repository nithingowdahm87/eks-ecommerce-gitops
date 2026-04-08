FROM nginx:alpine
LABEL maintainer="NITHIN <nithin@nithin-shop.dev>"
LABEL project="nithin-shop"
COPY chart/ /usr/share/nginx/html/chart/
RUN echo '<!DOCTYPE html><html><head><title>nithin-shop</title></head><body><h1>nithin-shop Microservices Platform</h1><p>Umbrella Helm chart service for nithin-shop-k8s-ecommerce</p></body></html>' > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
