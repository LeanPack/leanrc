{ expect, assert } = require 'chai'
sinon = require 'sinon'
_ = require 'lodash'
RC = require 'RC'
LeanRC = require.main.require 'lib'
{ co } = RC::Utils


describe 'Configuration', ->
  describe '.new', ->
    it 'should create configuration instance', ->
      co ->
        class Test extends RC::Module
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        class Test::Configuration extends LeanRC::Configuration
          @inheritProtected()
          @module Test
        Test::Configuration.initialize()
        configuration = Test::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        yield return
  describe '#environment', ->
    it 'should get environment name', ->
      co ->
        class Test extends RC::Module
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        class Test::Configuration extends LeanRC::Configuration
          @inheritProtected()
          @module Test
        Test::Configuration.initialize()
        configuration = Test::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        environment = configuration.environment
        assert.equal environment, LeanRC::DEVELOPMENT
        yield return
  describe '#defineConfigProperties', ->
    it 'should setup configuration instance', ->
      co ->
        class Test extends RC::Module
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        class Test::Configuration extends LeanRC::Configuration
          @inheritProtected()
          @module Test
        Test::Configuration.initialize()
        configuration = Test::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        configuration.defineConfigProperties()
        assert.propertyVal configuration, 'test1', 'default'
        assert.propertyVal configuration, 'test2', 42
        assert.propertyVal configuration, 'test3', yes
        assert.propertyVal configuration, 'test4', 'test'
        yield return
  describe '#onRegister', ->
    it 'should initiate setup configuration instance', ->
      co ->
        class Test extends RC::Module
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        class Test::Configuration extends LeanRC::Configuration
          @inheritProtected()
          @module Test
        Test::Configuration.initialize()
        configuration = Test::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        configuration.onRegister()
        assert.propertyVal configuration, 'test1', 'default'
        assert.propertyVal configuration, 'test2', 42
        assert.propertyVal configuration, 'test3', yes
        assert.propertyVal configuration, 'test4', 'test'
        yield return
