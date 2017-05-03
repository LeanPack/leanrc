# 1. Некоторая миграция должна создать очередь, чтобы ей потом можно было пользоваться, например Resque.create(<queueName>, <concurrency>)
# адаптер для аранги реализованный в виде миксина для Resque класса спроецирует запрос с использованием @arango/queue
# адаптер для nodejs просто сохранит эти данные в какую нибудь базу данных (чтобы в нужный момент к ним обратиться и заиспользовать)
# 2. В аранго ничего делать в этом пункте не надо, движок базы данных сам будет заниматься менеджментом очередей и будет плодить потоки выполнения. Для nodejs при старте сервера надо проинициализировать Agenda сервис - взять из базы данных сохраненные <queueName> и <concurrency> и задефайнить хендлеры - внутри хендлера из принимаемых данных надо вычленить имя запускаемого скрипта, сделать require(<scriptName>) и заэкзекютить этот скрипт передав в него все данные поступившие в хендлер. (Agenda - должен покрывать функционал аранги по менеджменту очердей.)
# 3. класс DelayedQueue будет работать аналогично Record классу - проксировать вызовы методов к Resque классу (чтобы срабатывала нужная платформозависимая логика из миксина)
# 4. для job объектов не будет отдельного класса, потому что у них не будет никаких спец-методов - т.е. они будут чистыми структурами (обычный json объект)


###
```coffee
module.exports = (Module)->
  class ApplicationResque extends Module::Resque
    @inheritProtected()
    @include Module::ArangoResqueMixin # в этом миксине должны быть реализованы платформозависимые методы, которые будут посылать нативные запросы к реальной базе данных

    @module Module

  return ApplicationResque.initialize()
```

```coffee
module.exports = (Module)->
  {RESQUE} = Module::

  class PrepareModelCommand extends Module::SimpleCommand
    @inheritProtected()

    @module Module

    @public execute: Function,
      default: ->
        #...
        @facade.registerProxy Module::ApplicationResque.new RESQUE,
          <config key>: <config value>
        #...

  PrepareModelCommand.initialize()
```
###

module.exports = (Module)->
  {ANY, NILL} = Module::

  class DelayedQueue extends Module::CoreObject
    @inheritProtected()
    @module Module
    @implements Module::DelayedQueueInterface

    # конструктор принимает второй аргумент, ссылку на resque proxy.
    @public resque: Module::ResqueInterface
    @public name: String
    @public concurrency: Number

    @public @async push: Function,
      default: (scriptName, data, delayUntil)->
        yield return @resque.pushJob @name, scriptName, data, delayUntil

    @public @async get: Function,
      default: (jobId)->
        yield return @resque.getJob @name, jobId

    @public @async delete: Function,
      default: (jobId)->
        yield return @resque.deleteJob @name, jobId

    @public @async abort: Function,
      default: (jobId)->
        yield return @resque.abortJob @name, jobId

    @public @async all: Function,
      default: (scriptName)->
        yield return @resque.allJobs @name, scriptName

    @public @async pending: Function,
      default: (scriptName)->
        yield return @resque.pendingJobs @name, scriptName

    @public @async progress: Function,
      default: (scriptName)->
        yield return @resque.progressJobs @name, scriptName

    @public @async completed: Function,
      default: (scriptName)->
        yield return @resque.completedJobs @name, scriptName

    @public @async failed: Function,
      default: (scriptName)->
        yield return @resque.failedJobs @name, scriptName

    @public init: Function,
      default: (aoProperties, aoResque) ->
        @super arguments...
        @resque = aoResque

        for own vsAttrName, voAttrValue of aoProperties
          @[vsAttrName] = voAttrValue
        return


  DelayedQueue.initialize()
