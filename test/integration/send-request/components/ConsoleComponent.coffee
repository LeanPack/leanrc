
EventEmitter = require 'events'

module.exports = (Module) ->
  class ConsoleComponent extends Module.NS.CoreObject
    @inheritProtected()
    @module Module

    @const MESSAGE_WRITTEN: 'messageWritten'
    @const SEND_REQUEST_EVENT: 'sendRequestEvent'

    ipoEventEmitter = @private eventEmitter: EventEmitter,
      default: null
    ipoInstance = @private instance: ConsoleComponent,
      default: null

    @public @static getInstance: Function,
      default: ->
        unless @[ipoInstance]?
          @[ipoInstance] = ConsoleComponent.new()
        @[ipoInstance]

    @public writeMessages: Function,
      default: (messages...) ->
        # Commented out to prevent terminal pollution
        # console.log messages...
        @[ipoEventEmitter].emit ConsoleComponent::MESSAGE_WRITTEN

    @public sendRequest: Function,
      default: ->
        @[ipoEventEmitter].emit ConsoleComponent::SEND_REQUEST_EVENT

    @public subscribeEvent: Function,
      default: (eventName, callback) ->
        @[ipoEventEmitter].on eventName, callback

    @public subscribeEventOnce: Function,
      default: (eventName, callback) ->
        @[ipoEventEmitter].once eventName, callback

    @public unsubscribeEvent: Function,
      default: (eventName, callback) ->
        if callback?
          @[ipoEventEmitter].removeListener eventName, callback
        else
          @[ipoEventEmitter].removeAllListeners eventName

    constructor: (args...) ->
      super args...
      @[ipoEventEmitter] = new EventEmitter


  ConsoleComponent.initialize()