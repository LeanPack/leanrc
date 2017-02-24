RC = require 'RC'

module.exports = (LeanRC)->
  class LeanRC::Notifier extends RC::CoreObject
    @implements LeanRC::NotifierInterface

    @private @static MULTITON_MSG: String,
      default: "multitonKey for this Notifier not yet initialized!"

    @public sendNotification: Function,
      default: (name, body, type)->
        if @facade()
          @facade().sendNotification name, body, type
        return

    @public initializeNotifier: Function,
      default: (key)->
        @multitonKey = key
        return


    @private multitonKey: String
    @private facade: Function,
      args: []
      return: LeanRC::FacadeInterface
      default: ->
        unless @multitonKey?
          throw new Error Notifier.MULTITON_MSG
        LeanRC::Facade.getInstance @multitonKey



  return LeanRC::Notifier.initialize()
