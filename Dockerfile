FROM ubuntu:16.04

MAINTAINER <lguitarras0594@gmail.com>
RUN apt-get update && apt-get install -y nodejs && apt-get install -y curl && apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y npm
COPY app/ /app/app/
COPY internals/ /app/internals/
COPY server/ /app/server/
COPY appveyor.yml /app/
COPY package.json /app/
WORKDIR /app/
# Upgrade node and npm to latest version
RUN npm cache clean
RUN npm install -g n
RUN n stable
RUN curl -L https://npmjs.org/install.sh | sh
RUN npm run setup 
RUN npm -v && node -v
RUN npm rb
RUN ls -ln .
EXPOSE 3000
EXPOSE 80
EXPOSE 443
RUN npm run build:dll
RUN apt-get install -y nginx
COPY nginx.conf /etc/nginx/sites-available/react
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/react /etc/nginx/sites-enabled/react
COPY start.sh /app/
WORKDIR /app/
RUN chmod a+x start.sh
CMD ["/app/start.sh"]
