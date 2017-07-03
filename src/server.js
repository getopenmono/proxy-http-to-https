'use strict'

const https = require('https')
const httpProxy = require('http-proxy')

httpProxy.createProxyServer({
  target: 'https://www.random.org',
  agent: https.globalAgent,
  headers: {
    host: 'www.random.org'
  }
}).listen(3000)
