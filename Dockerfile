# Escogemos la imagen donde haremos todas nuestra configuración, en nuestro caso será la siguiente:
FROM jwilder/nginx-proxy

# Instalamos todas las dependencias necesarias para instalar el WAF en el contenedor "Proxy reverso Nginx" 
RUN apt-get update && apt-get install nano git bison build-essential ca-certificates curl dh-autoreconf doxygen \
  flex gawk git iputils-ping libcurl4-gnutls-dev libexpat1-dev libgeoip-dev liblmdb-dev \
  libpcre3-dev libpcre++-dev libssl-dev libtool libxml2 libxml2-dev libyajl-dev locales \
  lua5.3-dev pkg-config wget zlib1g-dev libgd-dev libxslt-dev -y
