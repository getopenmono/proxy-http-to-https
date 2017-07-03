##
## Base
##
FROM node:alpine AS base
# RUN addgroup -S app && adduser -S -g app app
RUN apk add --no-cache nodejs-current tini
WORKDIR $HOME/proxy
ENTRYPOINT ["/sbin/tini", "--"]
COPY src/package.json src/package-lock.json ./

##
## Dependencies
##
FROM base AS dependencies
RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install --only=production && \
    cp -R node_modules prod_node_modules && \
	npm install

##
## Test
##
FROM dependencies AS test
COPY src/* ./
RUN npm test

##
## Release
##
FROM base AS release
COPY --from=dependencies $HOME/proxy/prod_node_modules ./node_modules
COPY src/* ./
EXPOSE 3000
CMD npm start
