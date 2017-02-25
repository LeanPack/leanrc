RC = require 'RC'

module.exports = (LeanRC)->
  class LeanRC::Facade extends RC::CoreObject
    @implements LeanRC::FacadeInterface

    @Module: LeanRC

    @public @static MULTITON_MSG: String,
      default: "Facade instance for this multiton key already constructed!"

    ipoModel        = @private model: LeanRC::ModelInterface
    ipoView         = @private view: LeanRC::ViewInterface
    ipoController   = @private controller: LeanRC::ControllerInterface
    ipsMultitonKey  = @protected multitonKey: String
    cphInstanceMap  = @private @static instanceMap: Object,
      default: {}

    ipmInitializeModel = @protected initializeModel: Function,
      default: ->
        unless @[ipoModel]?
          @[ipoModel] = LeanRC::Model.getInstance @[ipsMultitonKey]

    ipmInitializeController = @protected initializeController: Function,
      default: ->
        unless @[ipoController]?
          @[ipoController] = LeanRC::Controller.getInstance @[ipsMultitonKey]
        return

    ipmInitializeView = @protected initializeView: Function,
      default: ->
        unless @[ipoView]?
          @[ipoView] = LeanRC::View.getInstance @[ipsMultitonKey]
        return

    ipmInitializeFacade = @protected initializeFacade: Function,
      default: ->
        @[ipmInitializeModel]()
        @[ipmInitializeController]()
        @[ipmInitializeView]()
        return

    @public registerCommand: Function,
      default: (asNotificationName, aCommand)->
        @[ipoController].registerCommand asNotificationName, aCommand
        return

    @public removeCommand: Function,
      default: (asNotificationName)->
        @[ipoController].removeCommand asNotificationName
        return

    @public hasCommand: Function,
      default: (asNotificationName)->
        @[ipoController].hasCommand asNotificationName

    @public registerProxy: Function,
      default: (aoProxy)->
        @[ipoModel].registerProxy aoProxy
        return

    @public retrieveProxy: Function,
      default: (asProxyName)->
        @[ipoModel].retrieveProxy asProxyName

    @public removeProxy: Function,
      default: (asProxyName)->
        @[ipoModel].removeProxy asProxyName

    @public hasProxy: Function,
      default: (asProxyName)->
        @[ipoModel].hasProxy asProxyName

    @public registerMediator: Function,
      default: (aoMediator)->
        if @[ipoView]
          @[ipoView].registerMediator aoMediator
        return

    @public retrieveMediator: Function,
      default: (asMediatorName)->
        if @[ipoView]
          @[ipoView].retrieveMediator asMediatorName

    @public removeMediator: Function,
      default: (asMediatorName)->
        if @[ipoView]
          @[ipoView].removeMediator asMediatorName

    @public hasMediator: Function,
      default: (asMediatorName)->
        if @[ipoView]
          @[ipoView].hasMediator asMediatorName

    @public notifyObservers: Function,
      default: (aoNotification)->
        if @[ipoView]
          @[ipoView].notifyObservers aoNotification
        return

    @public sendNotification: Function,
      default: (asName, asBody, asType)->
        @notifyObservers LeanRC::Notification.new asName, asBody, asType
        return

    @public initializeNotifier: Function,
      default: (asKey)->
        @[ipsMultitonKey] = asKey
        return

    constructor: (asKey)->
      if Facade[cphInstanceMap][asKey]
        throw new Error Facade.MULTITON_MSG
      @initializeNotifier asKey
      Facade[cphInstanceMap][asKey] = @
      @[ipmInitializeFacade]()


  return LeanRC::Facade.initialize()