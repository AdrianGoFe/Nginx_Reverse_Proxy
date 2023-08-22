# Steps to run the Reverse Proxy

<p align="center">
  <img width="460" height="300" src="pic/icon_docker.webp">
</p>


~~~
1. sudo -i

2. cd [path_where_you_want_to_save]

3. git clone https://github.com/AdrianGoFe/Nginx_Reverse_Proxy.git

4. cd Nginx_Reverse_Proxy

5. nano docker-compose.yml
~~~

Now we must change the parameters called **YOUR_MAIL, YOUR_DOMAIN, AND_SUBDOMAINS** with our information:

~~~
version: '3.3'

services:

  nginx_proxy:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: nginx_proxy
    restart: always
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - letsencrypt-certs:/etc/nginx/certs
      - letsencrypt-vhost-d:/etc/nginx/vhost.d
      - letsencrypt-html:/usr/share/nginx/html
      - conf-nginx:/etc/nginx
      - pers-app:/app
      - pers-opt:/opt
      - pers-usr-local:/usr/local
    networks:
      - web

  letsencrypt-proxy:
    image: jrcs/letsencrypt-nginx-proxy-companion
    container_name: letsencrypt-proxy
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - letsencrypt-certs:/etc/nginx/certs
      - letsencrypt-vhost-d:/etc/nginx/vhost.d
      - letsencrypt-html:/usr/share/nginx/html
    environment:
       DEFAULT_EMAIL: <span style="color:red">YOUR_EMAIL</span>
       NGINX_PROXY_CONTAINER: nginx_proxy
    networks:
      - web

  wordpress:
    container_name: wordpress
    image: wordpress:5.9.2
    restart: always
    expose:
      - 443
    secrets:
      - db_user
      - db_password
      - db_name
    environment:
      WORDPRESS_DB_HOST: mysql_db
      WORDPRESS_DB_USER_FILE: /run/secrets/db_user
      WORDPRESS_DB_PASSWORD_FILE: /run/secrets/db_password
      WORDPRESS_DB_NAME_FILE: /run/secrets/db_name
      VIRTUAL_HOST: YOUR_DOMAIN, AND_SUBDOMAINS
      LETSENCRYPT_HOST: YOUR_DOMAIN, AND_SUBDOMAINS
      LETSENCRIPT_EMAIL: YOUR_MAIL
    volumes:
      - wordpress:/var/www/html
    depends_on:
      - mysql_db
    networks:
      - web
      
  mysql_db:
    container_name: mysql
    image: mysql:5.7.17
    restart: always
    secrets:
      - db_user
      - db_password
      - db_name
      - db_password_root
    environment:
      MYSQL_DATABASE_FILE: /run/secrets/db_name
      MYSQL_USER_FILE: /run/secrets/db_user
      MYSQL_PASSWORD_FILE: /run/secrets/db_password
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_password_root
    volumes:
      - mysql_db:/var/lib/mysql
    networks:
      - web

secrets:
  db_user:
    file: PATH_OF_YOUR_FILE_USER.TXT
  db_password:
    file: PATH_OF_YOUR_PASSWORD_USER.TXT
  db_name: 
    file: PATH_OF_YOUR_DB_NAME.TXT
  db_password_root:
    file: PATH_OF_YOUR_PASSWORD_ROOT.TXT

volumes:
  wordpress:
  mysql_db:
  letsencrypt-certs:
  letsencrypt-vhost-d:
  letsencrypt-html:
  conf-nginx:
  pers-app:
  pers-opt:
  pers-usr-local:

networks:
  web:
    external: true
~~~

When we finish editing the necessary **parameters** we must save the file with the following key combinations:

~~~
1. Control + O

2. Enter

3. Control + X
~~~

Finally, we run the script *.sh* which will be responsible for operating all the necessary services:

~~~
1. chmod +x run.sh

2. ./run.sh
~~~


