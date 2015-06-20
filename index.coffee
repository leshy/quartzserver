net = require "net"
events = require "events"
_ = require "underscore"

exports.server = class Server extends events.EventEmitter
    constructor: (@port=31337) ->
        console.log "Listening on", @port

        @clients = []

        @server = net.createServer (client) =>
          console.log 'client connected'
          @clients.push client

          client.on 'end', =>
            console.log 'client disconnected'
            @clients = _.without @clients, client

          client.on "data", (data) =>
            data = String data
            @emit "msg", data
            #console.log ">>>", data

        @server.listen @port, =>
          console.log('server bound', @port)
    send: (msg) ->
        msg = String JSON.stringify msg
        #console.log "<<<", msg
        _.map @clients, (client) -> client.write msg + "\n"
