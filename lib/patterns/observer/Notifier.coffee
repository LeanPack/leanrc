RC = require 'RC'

module.exports = (LeanRC)->
  class LeanRC::Notifier extends RC::CoreObject
    @implements LeanRC::NotifierInterface

    @Module: LeanRC

    @public @static MULTITON_MSG: String,
      default: "multitonKey for this Notifier not yet initialized!"

    ipsMultitonKey = @protected multitonKey: String
    ipmFacade = @private facade: LeanRC::FacadeInterface,
      get: ->
        unless @[ipsMultitonKey]?
          throw new Error Notifier.MULTITON_MSG
        LeanRC::Facade.getInstance @[ipsMultitonKey]

    @public sendNotification: Function,
      default: (asName, aoBody, asType)->
        if @[ipmFacade]
          @[ipmFacade].sendNotification asName, aoBody, asType
        return

    @public initializeNotifier: Function,
      default: (asKey)->
        @[ipsMultitonKey] = asKey
        return






  return LeanRC::Notifier.initialize()