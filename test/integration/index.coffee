class TestApp

require('./AppConstants') TestApp

require('./controller/command/StartupCommand') TestApp
require('./controller/command/PrepareControllerCommand') TestApp
require('./controller/command/PrepareViewCommand') TestApp
require('./controller/command/PrepareModelCommand') TestApp

require('./AppFacade') TestApp

module.exports = TestApp
