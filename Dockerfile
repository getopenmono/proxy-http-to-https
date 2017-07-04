##
## Base (89.4MB)
##
FROM node:alpine AS base
RUN apk add --no-cache nodejs-current tini
WORKDIR $HOME/proxy
ENTRYPOINT ["/sbin/tini", "--"]

##
## Production dependencies (93.3MB)
##
FROM base AS production-dependencies
COPY src/package.json ./
RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install --only=production

##
## Test packages (?MB)
##
FROM production-dependencies AS test-base
RUN apk add --no-cache python make g++

##
## Test dependencies (303MB)
##
FROM test-base AS test-dependencies
RUN npm set progress=false && \
    npm config set depth 0 && \
	npm install

##
## Test (303MB)
##
FROM test-dependencies AS test
COPY src/* ./
RUN npm test

##
## Production (93.3MB)
##
FROM production-dependencies AS production
COPY src/* ./
EXPOSE 3000
CMD ["npm", "start"]
