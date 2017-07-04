'use strict'

const http = require('http')
const https = require('https')
const httpProxy = require('http-proxy')

const proxy = httpProxy.createProxyServer({
  agent: https.globalAgent
})

const server = http.createServer((req, res) => {
  const targetHost = req.headers['x-host-target']
  console.log(`Target host: ${targetHost}`)
  // TODO: sanity check targetHost.
  proxy.web(req, res, {
    target: `https://${targetHost}`,
    headers: {
      host: targetHost
    }
  })
})

server.listen(3000)
