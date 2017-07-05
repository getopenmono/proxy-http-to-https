'use strict'

const http = require('http')
const https = require('https')
const httpProxy = require('http-proxy')

const proxy = httpProxy.createProxyServer({
  agent: https.globalAgent
})

const targetHostWhitelist = [
  'www.random.org',
  'api.twitter.com',
  'api.pushover.net'
]

const server = http.createServer((req, res) => {
  const targetHost = req.headers['x-host-target']
  if (targetHost && targetHostWhitelist.includes(targetHost)) {
    return proxy.web(req, res, {
      target: `https://${targetHost}`,
      headers: {
        host: targetHost
      }
    })
  }
  res.statusCode = 200
  res.setHeader('Content-Type', 'application/json')
  res.end(JSON.stringify(targetHostWhitelist))
})

server.listen(3000)
