
Tomatos = require '../lib'

class TomatosMain extends Tomatos
  @inheritProtected()

  @root __dirname

  require.main.require('lib/patterns/command/DelayedJobScript') @Module
  require('./mediators/MainJunctionMediator') @Module
  require('./mediators/MainSwitch') @Module
  require('./mediators/ApplicationMediator') @Module

  require('./proxies/MainCollection') @Module
  require('./proxies/MainResque') @Module
  require('./proxies/ThinHttpCollection') @Module

  require('./commands/PrepareControllerCommand') @Module
  require('./commands/PrepareViewCommand') @Module
  require('./commands/PrepareModelCommand') @Module
  require('./commands/StartupCommand') @Module

  require('./ApplicationFacade') @Module

  require('./MainApplication') @Module


module.exports = TomatosMain.initialize().freeze()
