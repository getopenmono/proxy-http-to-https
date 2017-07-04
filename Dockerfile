##
## Base
##
FROM node:alpine AS base
RUN apk add --no-cache nodejs-current tini
WORKDIR $HOME/proxy
ENTRYPOINT ["/sbin/tini", "--"]

##
##
##
FROM base AS production-dependencies
COPY src/package.json ./
RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install --only=production

##
## Dependencies
##
FROM production-dependencies AS test-dependencies
RUN apk add --no-cache python make g++
RUN npm set progress=false && \
    npm config set depth 0 && \
	npm install

##
## Test
##
FROM test-dependencies AS test
COPY src/* ./
RUN npm test

##
## Release
##
FROM production-dependencies AS release
COPY src/* ./
EXPOSE 3000
CMD ["npm", "start"]
