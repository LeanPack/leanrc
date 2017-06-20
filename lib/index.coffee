# _         = require 'lodash'
# fs        = require 'fs'
RC = require 'RC'


class LeanRC extends RC
  @inheritProtected()

  @root __dirname

  Utils: RC::Utils.extend {}, RC::Utils

  @const HANDLER_RESULT:  0
  @const RECORD_CHANGED:  1
  @const CONFIGURATION:  Symbol 'ConfigurationProxy'
  @const STARTUP: Symbol 'startup' # для сигнала
  @const MIGRATE: Symbol 'migrate' # для сигнала
  @const ROLLBACK: Symbol 'rollback' # для сигнала
  @const STOPPED_MIGRATE: Symbol 'stopped_migrate' # для сигнала
  @const STOPPED_ROLLBACK: Symbol 'stopped_rollback' # для сигнала
  @const MIGRATIONS: Symbol 'MigrationsCollection'
  @const SESSIONS: Symbol 'SessionsCollection'
  @const USERS: Symbol 'UsersCollection'
  @const SPACES: Symbol 'SpacesCollection'
  @const ROLES: Symbol 'RolesCollection'
  @const RESQUE: Symbol 'ResqueProxy'
  @const START_RESQUE: Symbol 'start_resque'
  @const DELAYED_JOBS_QUEUE: 'delayed_jobs'
  @const DELAYED_JOBS_SCRIPT: 'DelayedJobScript'
  @const DEFAULT_QUEUE: 'default'
  @const JOB_RESULT:  Symbol 'JOB_RESULT'
  @const SHELL:  Symbol 'ShellApplication'
  @const APPLICATION_MEDIATOR:  Symbol 'ApplicationMediator'
  @const APPLICATION_ROUTER:  Symbol 'ApplicationRouter'
  @const APPLICATION_RENDERER:  Symbol 'ApplicationRenderer'
  @const MEM_RESQUE_EXEC:  Symbol 'MemoryResqueExecutor'
  @const LOG_MSG: Symbol 'logMessage'

  require('./interfaces/patterns/ApplicationInterface') LeanRC
  require('./interfaces/patterns/TransformInterface') LeanRC
  require('./interfaces/patterns/NotificationInterface') LeanRC
  require('./interfaces/patterns/NotifierInterface') LeanRC
  require('./interfaces/patterns/ObserverInterface') LeanRC
  require('./interfaces/patterns/CommandInterface') LeanRC
  require('./interfaces/patterns/MediatorInterface') LeanRC
  require('./interfaces/patterns/ProxyInterface') LeanRC
  require('./interfaces/patterns/SerializerInterface') LeanRC
  require('./interfaces/patterns/FacadeInterface') LeanRC
  require('./interfaces/patterns/RecordInterface') LeanRC
  require('./interfaces/patterns/CollectionInterface') LeanRC
  require('./interfaces/patterns/QueryInterface') LeanRC
  require('./interfaces/patterns/CursorInterface') LeanRC
  require('./interfaces/patterns/EndpointInterface') LeanRC
  require('./interfaces/patterns/GatewayInterface') LeanRC
  require('./interfaces/patterns/RendererInterface') LeanRC
  require('./interfaces/patterns/RequestInterface') LeanRC
  require('./interfaces/patterns/ResponseInterface') LeanRC
  require('./interfaces/patterns/CookiesInterface') LeanRC
  require('./interfaces/patterns/ContextInterface') LeanRC
  require('./interfaces/patterns/ResourceInterface') LeanRC
  require('./interfaces/patterns/RouterInterface') LeanRC
  require('./interfaces/patterns/SwitchInterface') LeanRC

  require('./interfaces/mixins/CrudGatewayMixinInterface') LeanRC
  require('./interfaces/mixins/IterableMixinInterface') LeanRC
  require('./interfaces/mixins/QueryableMixinInterface') LeanRC
  require('./interfaces/mixins/RelationsMixinInterface') LeanRC
  require('./interfaces/patterns/MigrationInterface') LeanRC
  require('./interfaces/patterns/DelayedQueueInterface') LeanRC
  require('./interfaces/patterns/ResqueInterface') LeanRC
  require('./interfaces/mixins/DelayableMixinInterface') LeanRC
  require('./interfaces/patterns/ScriptInterface') LeanRC

  require('./interfaces/core/ControllerInterface') LeanRC
  require('./interfaces/core/ModelInterface') LeanRC
  require('./interfaces/core/ViewInterface') LeanRC

  require('./utils/jwt') LeanRC
  require('./utils/crypto') LeanRC

  require('./mixins/ConfigurableMixin') LeanRC
  require('./mixins/RecordMixin') LeanRC
  require('./mixins/RelationsMixin') LeanRC
  require('./mixins/DelayableMixin') LeanRC

  require('./patterns/data_mapper/Transform') LeanRC
  require('./patterns/data_mapper/StringTransform') LeanRC
  require('./patterns/data_mapper/NumberTransform') LeanRC
  require('./patterns/data_mapper/DateTransform') LeanRC
  require('./patterns/data_mapper/BooleanTransform') LeanRC
  require('./patterns/data_mapper/Serializer') LeanRC
  require('./patterns/data_mapper/Record') LeanRC
  require('./patterns/data_mapper/DelayedQueue') LeanRC

  require('./patterns/query_object/Query') LeanRC

  require('./patterns/observer/Notification') LeanRC
  require('./patterns/observer/Notifier') LeanRC
  require('./patterns/observer/Observer') LeanRC

  require('./patterns/gateway/Endpoint') LeanRC

  require('./patterns/proxy/Proxy') LeanRC
  require('./patterns/proxy/Collection') LeanRC
  require('./patterns/proxy/Configuration') LeanRC
  require('./patterns/proxy/Gateway') LeanRC
  require('./patterns/proxy/Renderer') LeanRC
  require('./patterns/proxy/Router') LeanRC
  require('./patterns/proxy/Resque') LeanRC

  require('./mixins/CrudGatewayMixin') LeanRC
  require('./mixins/CrudEndpointMixin') LeanRC
  require('./mixins/HttpCollectionMixin') LeanRC
  require('./mixins/MemoryCollectionMixin') LeanRC
  require('./mixins/GenerateAutoincrementIdMixin') LeanRC # needs test
  require('./mixins/GenerateUuidIdMixin') LeanRC # needs test
  require('./mixins/MemoryResqueMixin') LeanRC
  require('./mixins/MemoryConfigurationMixin') LeanRC
  require('./mixins/IterableMixin') LeanRC
  require('./mixins/QueryableMixin') LeanRC
  require('./mixins/ThinHttpCollectionMixin') LeanRC
  require('./mixins/SchemaModuleMixin') LeanRC

  require('./patterns/switch/Request') LeanRC
  require('./patterns/switch/Response') LeanRC
  require('./patterns/switch/Cookies') LeanRC
  require('./patterns/switch/Context') LeanRC

  require('./patterns/mediator/Mediator') LeanRC
  require('./patterns/mediator/Switch') LeanRC
  require('./patterns/mediator/MemoryResqueExecutor') LeanRC

  require('./patterns/command/SimpleCommand') LeanRC
  require('./patterns/command/MacroCommand') LeanRC
  require('./patterns/command/Resource') LeanRC
  require('./patterns/command/MigrateCommand') LeanRC
  require('./patterns/command/RollbackCommand') LeanRC
  require('./patterns/command/Script') LeanRC
  require('./patterns/command/DelayedJobScript') LeanRC

  require('./mixins/BulkActionsResourceMixin') LeanRC
  require('./mixins/BodyParseMixin') LeanRC
  require('./mixins/CheckSessionsMixin') LeanRC
  require('./mixins/CheckPermissionsMixin') LeanRC
  require('./mixins/CheckSchemaVersionMixin') LeanRC # needs test

  require('./patterns/migration/Migration') LeanRC
  require('./mixins/MemoryMigrationMixin') LeanRC

  require('./patterns/iterator/Cursor') LeanRC

  require('./patterns/facade/Facade') LeanRC

  require('./core/View') LeanRC
  require('./core/Model') LeanRC
  require('./core/Controller') LeanRC


LeanRC.initialize()

class Pipes extends LeanRC
  @inheritProtected()

  @root __dirname

  require('./interfaces/patterns/PipeAwareInterface') Pipes
  require('./interfaces/patterns/PipeFittingInterface') Pipes
  require('./interfaces/patterns/PipeMessageInterface') Pipes

  require('./patterns/pipes/Pipe') Pipes
  require('./patterns/pipes/PipeMessage') Pipes
  require('./patterns/pipes/PipeListener') Pipes
  require('./patterns/pipes/FilterControlMessage') Pipes
  require('./patterns/pipes/Filter') Pipes
  require('./patterns/pipes/Junction') Pipes
  require('./patterns/pipes/JunctionMediator') Pipes
  require('./patterns/pipes/PipeAwareModule') Pipes
  require('./patterns/pipes/QueueControlMessage') Pipes
  require('./patterns/pipes/Queue') Pipes
  require('./patterns/pipes/TeeMerge') Pipes
  require('./patterns/pipes/TeeSplit') Pipes

Pipes.initialize()

LeanRC.const Pipes: Pipes.freeze()

require('./patterns/facade/Application') LeanRC
require('./patterns/command/LogMessageCommand') LeanRC
require('./patterns/data_mapper/LogMessage') LeanRC
require('./patterns/data_mapper/LogFilterMessage') LeanRC
require('./mixins/LoggingJunctionMixin') LeanRC

module.exports = LeanRC.freeze()
