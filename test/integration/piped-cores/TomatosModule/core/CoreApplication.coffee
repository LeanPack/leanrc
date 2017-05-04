

module.exports = (Module) ->
  {
    ApplicationFacade
    Application
  } = Module::

  class CoreApplication extends Application
    @inheritProtected()
    @module Module

    @public @static NAME: String,
      default: 'TomatosCore'


  CoreApplication.initialize()
