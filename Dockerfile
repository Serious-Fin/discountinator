# Use base image (not sure which, so pick Node.js 18 at random)
FROM node:18
ARG PB_VERSION=0.18.6

# Set a working directory
WORKDIR /app

# Install react project dependancies
COPY package*.json ./
RUN npm install
RUN npm install typescript@latest -g
RUN npm install -g serve

# Copy and build the front-end code
COPY . .
RUN npm run build

# Copy back-end code
WORKDIR /app/server
COPY /server/package*.json ./
RUN npm install

# Copy remaining back-end code
COPY /server/* ./

# Setup pocketbase
WORKDIR /
RUN apt-get update && apt-get install -y \
    unzip \
    && rm -rf /var/lib/apt/lists/*


ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /app/pb/

# uncomment to copy the local pb_migrations dir into the container
COPY ./database/pb_migrations /app/pb/pb_migrations

WORKDIR /app

EXPOSE 3000 3001 8090

RUN apt-get update && apt-get install -y supervisor
COPY supervisord.conf /ect/supervisor/conf.d/supervisord.conf

# Start supervisord
CMD ["supervisord", "-c", "/ect/supervisor/conf.d/supervisord.conf"]