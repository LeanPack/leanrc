{ expect, assert } = require 'chai'
sinon = require 'sinon'
# request = require 'request'
LeanRC = require.main.require 'lib'
CucumbersApp = require './integration/piped-cores/CucumbersModule/shell'
TomatosApp = require './integration/piped-cores/TomatosModule/shell'
{ co, request } = LeanRC::Utils


describe 'PipedCores', ->
  describe 'Create CucumbersSchema app and ...', ->
    it 'должно выполнить все миграции в прямом направлении', ->
      throw new Error 'not implemented'
  describe 'Create CucumbersSchema app and ...', ->
    it 'должно выполнить все миграции в обратном направлении', ->
      throw new Error 'not implemented'
  describe 'Create TomatosSchema app and ...', ->
    it 'должно выполнить все миграции в прямом направлении', ->
      throw new Error 'not implemented'
  describe 'Create TomatosSchema app and ...', ->
    it 'должно выполнить все миграции в обратном направлении', ->
      throw new Error 'not implemented'
  describe 'Create Cucumbers app instance', ->
    it 'should create new CucumbersApp', ->
      expect ->
        app = CucumbersApp::ShellApplication.new()
        app.finish()
      .to.not.throw Error
  describe 'Create Tomatos app instance', ->
    it 'should create new TomatosApp', ->
      expect ->
        app = TomatosApp::ShellApplication.new()
        app.finish()
      .to.not.throw Error
  describe 'Create Cucumbers app and test pipes', ->
    it 'should create new CucumbersApp and test pipes from shell to logger', ->
      expect ->
        { CHANGE, DEBUG } = CucumbersApp::Pipes::LogMessage
        { NAME } = CucumbersApp::ShellApplication
        { NORMAL } = CucumbersApp::Pipes::PipeMessage
        TEST_LOG_MESSAGE = 'TEST log message'
        app = CucumbersApp::ShellApplication.new()
        app.facade.sendNotification(CucumbersApp::LogMessage.SEND_TO_LOG, TEST_LOG_MESSAGE, CucumbersApp::LogMessage.LEVELS[CucumbersApp::LogMessage.DEBUG])

        facade = CucumbersApp::Facade.getInstance 'CucumbersLogger'

        logs = facade.retrieveProxy CucumbersApp::Application::LOGGER_PROXY
        assert.equal logs.messages[0].getHeader().logLevel, CHANGE
        assert.equal logs.messages[0].getHeader().sender, NAME
        assert.doesNotThrow -> Date.parse logs.messages[0].getHeader().time
        assert.equal logs.messages[0].getBody(), 'Changed Log Level to: DEBUG'
        assert.equal logs.messages[0].getType(), NORMAL
        assert.equal logs.messages[1].getHeader().logLevel, DEBUG
        assert.equal logs.messages[1].getHeader().sender, NAME
        assert.doesNotThrow -> Date.parse logs.messages[1].getHeader().time
        assert.equal logs.messages[1].getBody(), TEST_LOG_MESSAGE
        assert.equal logs.messages[1].getType(), NORMAL
        app.finish()
      .to.not.throw Error
  describe 'Create Tomatos app and test pipes', ->
    it 'should create new TomatosApp and test pipes from shell to logger', ->
      expect ->
        { CHANGE, DEBUG } = TomatosApp::Pipes::LogMessage
        { NAME } = TomatosApp::ShellApplication
        { NORMAL } = TomatosApp::Pipes::PipeMessage
        TEST_LOG_MESSAGE = 'TEST log message'
        app = TomatosApp::ShellApplication.new()
        app.facade.sendNotification(TomatosApp::LogMessage.SEND_TO_LOG, TEST_LOG_MESSAGE, TomatosApp::LogMessage.LEVELS[TomatosApp::LogMessage.DEBUG])

        facade = TomatosApp::Facade.getInstance 'TomatosLogger'

        logs = facade.retrieveProxy TomatosApp::Application::LOGGER_PROXY
        assert.equal logs.messages[0].getHeader().logLevel, CHANGE
        assert.equal logs.messages[0].getHeader().sender, NAME
        assert.doesNotThrow -> Date.parse logs.messages[0].getHeader().time
        assert.equal logs.messages[0].getBody(), 'Changed Log Level to: DEBUG'
        assert.equal logs.messages[0].getType(), NORMAL
        assert.equal logs.messages[1].getHeader().logLevel, DEBUG
        assert.equal logs.messages[1].getHeader().sender, NAME
        assert.doesNotThrow -> Date.parse logs.messages[1].getHeader().time
        assert.equal logs.messages[1].getBody(), TEST_LOG_MESSAGE
        assert.equal logs.messages[1].getType(), NORMAL
        app.finish()
      .to.not.throw Error
  describe 'Create Cucumbers app instance and send request', ->
    it 'should create new CucumbersApp and respond on request', ->
      co ->
        cucumbers = CucumbersApp::ShellApplication.new()
        res = yield request.get 'http://localhost:3002/0.1/cucumbers'
        console.log '?????', res
        # здесь можно проверить сколько объектов вернулось в {cucumbers} = res
        cucumbers.finish()
  describe 'Create Tomatos app instance and send request', ->
    it 'should create new TomatosApp and respond on request', ->
      co ->
        tomatos = TomatosApp::ShellApplication.new()
        res = yield request.get 'http://localhost:3001/0.1/tomatos'
        console.log '?????', res
        # здесь можно проверить сколько объектов вернулось в {tomatos} = res
        tomatos.finish()
  describe 'Create Cucumbers app and test CRUD', ->
    it 'should create new CucumbersApp and send CRUD requests', ->
      co ->
        cucumbers = CucumbersApp::ShellApplication.new()
        res1 = yield request.post 'http://localhost:3002/0.1/cucumbers',
          body:
            cucumber:
              name: 'cucumber1'
              description: 'cucumber1 description'
        console.log '?????res1 after POST', res1
        res2 = yield request.post 'http://localhost:3002/0.1/cucumbers',
          body:
            cucumber:
              name: 'cucumber2'
              description: 'cucumber2 description'
        console.log '?????res2 after POST', res2
        res3 = yield request.post 'http://localhost:3002/0.1/cucumbers',
          body:
            cucumber:
              name: 'cucumber3'
              description: 'cucumber3 description'
        console.log '?????res3 after POST', res3
        res4 = yield request.get 'http://localhost:3002/0.1/cucumbers'
        console.log '?????res4 after GET all', res4
        {cucumber:{id:cucumber2Id}} = JSON.parse res2.body
        res5 = yield request.put "http://localhost:3002/0.1/cucumbers/#{cucumber2Id}",
          body:
            cucumber:
              name: 'cucumber2'
              description: 'cucumber2 long description'
        console.log '?????res5 after PUT with res2.body.cucumber.id', res5
        cucumbers.finish()
  describe 'Create Tomatos app and test CRUD', ->
    it 'should create new TomatosApp and send CRUD requests', ->
      co ->
        tomatos = TomatosApp::ShellApplication.new()
        res1 = yield request.post 'http://localhost:3001/0.1/tomatos',
          body:
            tomato:
              name: 'tomato1'
              description: 'tomato1 description'
        console.log '?????res1 after POST', res1
        res2 = yield request.post 'http://localhost:3001/0.1/tomatos',
          body:
            tomato:
              name: 'tomato2'
              description: 'tomato2 description'
        console.log '?????res2 after POST', res2
        res3 = yield request.post 'http://localhost:3001/0.1/tomatos',
          body:
            tomato:
              name: 'tomato3'
              description: 'tomato3 description'
        console.log '?????res3 after POST', res3
        res4 = yield request.get 'http://localhost:3001/0.1/tomatos'
        console.log '?????res4 after GET all', res4
        {tomato:{id:tomato2Id}} = JSON.parse res2.body
        res5 = yield request.put "http://localhost:3001/0.1/tomatos/#{tomato2Id}",
          body:
            tomato:
              name: 'tomato2'
              description: 'tomato2 long description'
        console.log '?????res5 after PUT with res2.body.tomato.id', res5
        tomatos.finish()
  describe 'Create Cucumbers app and Tomatos app and ...', ->
    it 'после прихождения реквеста на томатос, он должен запросить через CucumbersResource огурец (который пошлет запрос через HttpCollectionMixin), полученный огурец он должен отправить в ответе', ->
      throw new Error 'not implemented'
