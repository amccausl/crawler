
# Load shared libraries and resources
global._ = require( 'underscore' )._
global.fs = require 'fs'
global.async = require 'async'
global.request = require 'request'

jsdom = require 'jsdom'
jquery =  fs.readFileSync('./lib/jquery-1.8.1.js').toString()
data = require 'data'

# Load config
global.config = JSON.parse(fs.readFileSync(__dirname+ '/config.json', 'utf-8'))
global.seed = JSON.parse(fs.readFileSync(__dirname+ '/db/schema.json', 'utf-8'))

class global.Agent

  ### Private var ###
  queue = null

  # Define the name for an agent
  constructor: ( @name, process ) ->
    @queue = 
        async.queue( (task, callback) ->
          request({ uri: task.uri }, (error, response, body) ->
            if ( error and ( response == undefined or response.statusCode isnt 200 ) )
              console.log( 'Error when fetching: ' + task.uri )
              callback()

            else
              jsdom.env(
                html: body
                src: [ jquery ]
                done: (errors, window) ->
                  $ = window.$

                  deals = process( task, errors, window )
                  console.log( deals )

                  # TODO: create graph, sync from remote server
                  #graph.set deal for deal in deals

                  callback()
              )
          )
        , 2)

    @queue.drain = ->
      console.log( 'empty' )
      #graph.merge( seed, dirty: true )
      #graph.sync( (err) -> console.log('Successfully synced') )

  # Define a test to determine if this agent is valid
  test: (task) ->
    false

  push: (task) ->
    @queue.push( task )

router =
  routes: []
  add: ( route ) ->
    router.routes.push route
  dispatch: ( task ) -> _.find( router.routes, (route) -> route.test )?.push( task )
    
# Load the agents into the router
router.add (require('./agents/' + agent).agent) for agent in ( fs.readdirSync './agents' ) when /coffee$/.test( agent )

router.dispatch( { uri: 'http://wagjag.com/?wagjag=43657' } )
