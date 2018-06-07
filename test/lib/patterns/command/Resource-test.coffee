EventEmitter = require 'events'
{ expect, assert } = require 'chai'
sinon = require 'sinon'
_ = require 'lodash'
httpErrors = require 'http-errors'
LeanRC = require.main.require 'lib'
Resource = LeanRC::Resource
{ co } = LeanRC::Utils

describe 'Resource', ->
  describe '.new', ->
    it 'should create new command', ->
      expect ->
        resource = Resource.new()
      .to.not.throw Error
  describe '#keyName', ->
    it 'should get key name using entity name', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        { keyName } = resource
        assert.equal keyName, 'test_entity'
        yield return
  describe '#itemEntityName', ->
    it 'should get item name using entity name', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        { itemEntityName } = resource
        assert.equal itemEntityName, 'test_entity'
        yield return
  describe '#listEntityName', ->
    it 'should get list name using entity name', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        { listEntityName } = resource
        assert.equal listEntityName, 'test_entities'
        yield return
  describe '#collectionName', ->
    it 'should get collection name using entity name', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        { collectionName } = resource
        assert.equal collectionName, 'TestEntitiesCollection'
        yield return
  describe '#collection', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should get collection', ->
      co ->
        TEST_FACADE = 'TEST_FACADE_001'
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        facade = LeanRC::Facade.getInstance TEST_FACADE
        resource = Test::TestResource.new()
        resource.initializeNotifier TEST_FACADE
        { collectionName } = resource
        boundCollection = LeanRC::Collection.new collectionName
        facade.registerProxy boundCollection
        { collection } = resource
        assert.equal collection, boundCollection
        yield return
  describe '#action', ->
    it 'should create actions', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
          @action test1: String,
            default: 'test1'
          @action test2: String,
            default: 'test2'
          @action test3: String,
            default: 'test3'
        Test::TestResource.initialize()
        assert.deepEqual Test::TestResource.metaObject.data.actions.test1,
          default: 'test1'
          attr: 'test1'
          attrType: String
          level: LeanRC::PUBLIC
          pointer: 'test1'
        assert.deepEqual Test::TestResource.metaObject.data.actions.test2,
          default: 'test2'
          attr: 'test2'
          attrType: String
          level: LeanRC::PUBLIC
          pointer: 'test2'
        assert.deepEqual Test::TestResource.metaObject.data.actions.test3,
          default: 'test3'
          attr: 'test3'
          attrType: String
          level: LeanRC::PUBLIC
          pointer: 'test3'
        yield return
  describe '#actions', ->
    it 'should get resource actions', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @include LeanRC::QueryableResourceMixin
          @module Test
          @public entityName: String,
            default: 'TestEntity'
          @action test1: String,
            default: 'test1'
          @action test2: String,
            default: 'test2'
          @action test3: String,
            default: 'test3'
        Test::TestResource.initialize()
        assert.deepEqual Test::TestResource.actions.test1,
          default: 'test1'
          attr: 'test1'
          attrType: String
          level: LeanRC::PUBLIC
          pointer: 'test1'
        assert.deepEqual Test::TestResource.actions.test2,
          default: 'test2'
          attr: 'test2'
          attrType: String
          level: LeanRC::PUBLIC
          pointer: 'test2'
        assert.deepEqual Test::TestResource.actions.test3,
          default: 'test3'
          attr: 'test3'
          attrType: String
          level: LeanRC::PUBLIC
          pointer: 'test3'
        { actions } = Test::TestResource
        assert.propertyVal actions.list, 'attr', 'list'
        assert.propertyVal actions.list, 'attrType', Function
        assert.propertyVal actions.list, 'level', LeanRC::PUBLIC
        assert.propertyVal actions.list, 'async', LeanRC::ASYNC
        assert.propertyVal actions.detail, 'attr', 'detail'
        assert.propertyVal actions.detail, 'attrType', Function
        assert.propertyVal actions.detail, 'level', LeanRC::PUBLIC
        assert.propertyVal actions.detail, 'async', LeanRC::ASYNC
        assert.propertyVal actions.create, 'attr', 'create'
        assert.propertyVal actions.create, 'attrType', Function
        assert.propertyVal actions.create, 'level', LeanRC::PUBLIC
        assert.propertyVal actions.create, 'async', LeanRC::ASYNC
        assert.propertyVal actions.update, 'attr', 'update'
        assert.propertyVal actions.update, 'attrType', Function
        assert.propertyVal actions.update, 'level', LeanRC::PUBLIC
        assert.propertyVal actions.update, 'async', LeanRC::ASYNC
        assert.propertyVal actions.delete, 'attr', 'delete'
        assert.propertyVal actions.delete, 'attrType', Function
        assert.propertyVal actions.delete, 'level', LeanRC::PUBLIC
        assert.propertyVal actions.delete, 'async', LeanRC::ASYNC
        ### Moved to -> ModellingResourceMixin
        assert.propertyVal actions.query, 'attr', 'query'
        assert.propertyVal actions.query, 'attrType', Function
        assert.propertyVal actions.query, 'level', LeanRC::PUBLIC
        assert.propertyVal actions.query, 'async', LeanRC::ASYNC
        ###
        yield return
  describe '#beforeActionHook', ->
    it 'should parse action params as arguments', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.beforeActionHook
          query: query: '{"test":"test123"}'
          pathParams: testParam: 'testParamValue'
          headers: 'test-header': 'test-header-value'
          request: body: test: 'test678'
        assert.deepPropertyVal resource, 'context.query.query', '{"test":"test123"}'
        assert.deepPropertyVal resource, 'context.pathParams.testParam', 'testParamValue'
        assert.deepPropertyVal resource, 'context.headers.test-header', 'test-header-value'
        assert.deepPropertyVal resource, 'context.request.body.test', 'test678'
        yield return
  describe '#getQuery', ->
    it 'should get resource query', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.context =
          query: query: '{"test":"test123"}'
        resource.getQuery()
        assert.deepEqual resource.listQuery, test: 'test123'
        yield return
  describe '#getRecordId', ->
    it 'should get resource record ID', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.context =
          pathParams: test_entity: 'ID123456'
        resource.getRecordId()
        assert.propertyVal resource, 'recordId', 'ID123456'
        yield return
  describe '#getRecordBody', ->
    it 'should get body', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        TestResource.initialize()
        resource = TestResource.new()
        resource.context =
          request: body: test_entity: test: 'test9'
        resource.getRecordBody()
        assert.deepEqual resource.recordBody, test: 'test9'
        yield return
  describe '#omitBody', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should clean body from unneeded properties', ->
      co ->
        TEST_FACADE = 'TEST_FACADE_002'
        facade = LeanRC::Facade.getInstance TEST_FACADE
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        TestResource.initialize()
        class TestsCollection extends LeanRC::Collection
          @inheritProtected()
          @module Test
        TestsCollection.initialize()
        class TestEntityRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestEntityRecord
          @public init: Function,
            default: ->
              @super arguments...
              @type = 'Test::TestEntityRecord'
        TestEntityRecord.initialize()
        resource = TestResource.new()
        resource.initializeNotifier TEST_FACADE
        { collectionName } = resource
        boundCollection = TestsCollection.new collectionName,
          delegate: 'TestEntityRecord'
        facade.registerProxy boundCollection
        resource.context =
          request: body: test_entity:
            _id: '123', test: 'test9', _space: 'test', type: 'TestEntityRecord'
        resource.getRecordBody()
        resource.omitBody()
        assert.deepEqual resource.recordBody, test: 'test9', type: 'Test::TestEntityRecord'
        yield return
  describe '#beforeUpdate', ->
    it 'should get body with ID', ->
      co ->
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.context =
          pathParams: test_entity: 'ID123456'
          request: body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        assert.deepEqual resource.recordBody, id: 'ID123456', test: 'test9'
        yield return
  describe '#list', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should list of resource items', ->
      co ->
        KEY = 'TEST_RESOURCE_001'
        class Test extends LeanRC
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestRecord'
        Test::TestRecord.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        class TestsCollection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::QueryableCollectionMixin
          @module Test
          @public parseQuery: Object,
            default: (aoQuery) -> aoQuery
          @public @async takeAll: Function,
            default: ->
              yield LeanRC::Cursor.new @, @getData().data
          @public @async executeQuery: Function,
            default: (aoParsedQuery) ->
              data = _.filter @getData().data, aoParsedQuery.$filter
              yield LeanRC::Cursor.new @, data
          @public @async push: Function,
            default: (aoRecord) ->
              isExist = (id) => (_.find @getData().data, {id})?
              while isExist key = LeanRC::Utils.uuid.v4() then
              aoRecord.id = key
              i = aoRecord.toJSON()
              @getData().data.push i
              yield return i
          @public @async includes: Function,
            default: (id)->
              yield return (_.find @getData().data, {id})?
        TestsCollection.initialize()
        facade = LeanRC::Facade.getInstance KEY
        COLLECTION_NAME = 'TestEntitiesCollection'
        facade.registerProxy TestsCollection.new COLLECTION_NAME,
          delegate: Test::TestRecord
          serializer: 'Serializer'
          data: []
        collection = facade.retrieveProxy COLLECTION_NAME
        yield collection.create test: 'test1'
        yield collection.create test: 'test2'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        { items, meta } = yield resource.list query: query: '{}'
        assert.deepEqual meta, pagination:
          limit: 'not defined'
          offset: 'not defined'
        assert.propertyVal items[0], 'test', 'test1'
        assert.propertyVal items[1], 'test', 'test2'
        yield return
  describe '#detail', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should get resource single item', ->
      co ->
        KEY = 'TEST_RESOURCE_002'
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestRecord'
        Test::TestRecord.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String, { default: 'TestEntity' }
        Test::TestResource.initialize()
        class Test::Collection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::QueryableCollectionMixin
          @module Test
          @public parseQuery: Object,
            default: (aoQuery) -> aoQuery
          @public @async executeQuery: Function,
            default: (aoParsedQuery) ->
              data = _.filter @getData().data, aoParsedQuery.$filter
              yield LeanRC::Cursor.new @, data
          @public @async push: Function,
            default: (aoRecord) ->
              isExist = (id) => (_.find @getData().data, {id})?
              while isExist key = LeanRC::Utils.uuid.v4() then
              aoRecord.id = key
              i = aoRecord.toJSON()
              @getData().data.push i
              yield return i
          @public @async take: Function,
            default: (id) ->
              result = []
              if (data = _.find @getData().data, {id})?
                result.push data
              cursor = LeanRC::Cursor.new @, result
              yield cursor.first()
          @public @async includes: Function,
            default: (id)->
              yield return (_.find @getData().data, {id})?
        Test::Collection.initialize()
        facade = LeanRC::Facade.getInstance KEY
        COLLECTION_NAME = 'TestEntitiesCollection'
        facade.registerProxy Test::Collection.new COLLECTION_NAME,
          delegate: Test::TestRecord
          serializer: -> LeanRC::Serializer
          data: []
        collection = facade.retrieveProxy COLLECTION_NAME
        yield collection.create test: 'test1'#, type: 'Test::TestRecord'
        record = yield collection.create test: 'test2'#, type: 'Test::TestRecord'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        context =
          pathParams: "#{resource.keyName}": record.id
        result = yield resource.detail context
        assert.propertyVal result, 'id', record.id
        assert.propertyVal result, 'test', 'test2'
        yield return
  describe '#create', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should create resource single item', ->
      co ->
        KEY = 'TEST_RESOURCE_003'
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestRecord'
        Test::TestRecord.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String, { default: 'TestEntity' }
        Test::TestResource.initialize()
        class Test::Collection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::QueryableCollectionMixin
          @module Test
          @public parseQuery: Object,
            default: (aoQuery) -> aoQuery
          @public @async executeQuery: Function,
            default: (aoParsedQuery) ->
              data = _.filter @getData().data, aoParsedQuery.$filter
              yield LeanRC::Cursor.new @, data
          @public @async push: Function,
            default: (aoRecord) ->
              isExist = (id) => (_.find @getData().data, {id})?
              while isExist key = LeanRC::Utils.uuid.v4() then
              aoRecord.id = key
              i = aoRecord.toJSON()
              @getData().data.push i
              yield return i
          @public @async take: Function,
            default: (id) ->
              result = []
              if (data = _.find @getData().data, {id})?
                result.push data
              cursor = LeanRC::Cursor.new @, result
              yield cursor.first()
          @public @async includes: Function,
            default: (id)->
              yield return (_.find @getData().data, {id})?
        Test::Collection.initialize()
        facade = LeanRC::Facade.getInstance KEY
        COLLECTION_NAME = 'TestEntitiesCollection'
        facade.registerProxy Test::Collection.new COLLECTION_NAME,
          delegate: Test::TestRecord
          serializer: LeanRC::Serializer
          data: []
        collection = facade.retrieveProxy COLLECTION_NAME
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        result = yield resource.create request: body: test_entity: test: 'test3'
        assert.propertyVal result, 'test', 'test3'
        yield return
  describe '#update', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should update resource single item', ->
      co ->
        KEY = 'TEST_RESOURCE_004'
        class Test extends LeanRC
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestRecord'
        Test::TestRecord.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String, { default: 'TestEntity' }
        Test::TestResource.initialize()
        class Test::TestCollection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::QueryableCollectionMixin
          @module Test
          @public parseQuery: Object,
            default: (aoQuery) -> aoQuery
          @public @async executeQuery: Function,
            default: (aoParsedQuery) ->
              data = _.filter @getData().data, aoParsedQuery.$filter
              yield LeanRC::Cursor.new @, data
          @public @async push: Function,
            default: (aoRecord) ->
              isExist = (id) => (_.find @getData().data, {id})?
              while isExist key = LeanRC::Utils.uuid.v4() then
              aoRecord.id = key
              i = aoRecord.toJSON()
              @getData().data.push i
              yield return i
          @public @async override: Function,
            default: (id, aoRecord) ->
              item = _.find @getData().data, {id}
              if item?
                FORBIDDEN = [ '_key', '_id', '_type', '_rev' ]
                snapshot = _.omit (aoRecord.toJSON?() ? aoRecord ? {}), FORBIDDEN
                item[key] = value  for own key, value of snapshot
              yield @take id
          @public @async take: Function,
            default: (id) ->
              result = []
              if (data = _.find @getData().data, {id})?
                result.push data
              cursor = LeanRC::Cursor.new @, result
              yield cursor.first()
          @public @async includes: Function,
            default: (id)->
              yield return (_.find @getData().data, {id})?
        Test::TestCollection.initialize()
        facade = LeanRC::Facade.getInstance KEY
        COLLECTION_NAME = 'TestEntitiesCollection'
        facade.registerProxy Test::TestCollection.new COLLECTION_NAME,
          delegate: Test::TestRecord
          serializer: LeanRC::Serializer
          data: []
        collection = facade.retrieveProxy COLLECTION_NAME
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        record = yield collection.create test: 'test3'
        result = yield resource.update
          type: 'Test::TestRecord'
          pathParams: test_entity: record.id
          request: body: test_entity: test: 'test8'
        assert.propertyVal result, 'test', 'test8'
        yield return
  describe '#delete', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should remove resource single item', ->
      co ->
        KEY = 'TEST_RESOURCE_005'
        class Test extends LeanRC::Module
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestRecord'
        Test::TestRecord.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String, { default: 'TestEntity' }
        Test::TestResource.initialize()
        class Test::Collection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::QueryableCollectionMixin
          @module Test
          @public parseQuery: Object,
            default: (aoQuery) -> aoQuery
          @public @async executeQuery: Function,
            default: (aoParsedQuery) ->
              data = _.filter @getData().data, aoParsedQuery.$filter
              yield LeanRC::Cursor.new @, data
          @public @async push: Function,
            default: (aoRecord) ->
              isExist = (id) => (_.find @getData().data, {id})?
              while isExist key = LeanRC::Utils.uuid.v4() then
              aoRecord.id = key
              i = aoRecord.toJSON()
              @getData().data.push i
              yield return i
          @public @async override: Function,
            default: (id, aoRecord) ->
              item = _.find @getData().data, {id}
              if item?
                FORBIDDEN = [ '_key', '_id', '_type', '_rev' ]
                snapshot = _.omit (aoRecord.toJSON?() ? aoRecord ? {}), FORBIDDEN
                item[key] = value  for own key, value of snapshot
              yield @take id
          @public @async take: Function,
            default: (id) ->
              result = []
              if (data = _.find @getData().data, {id})?
                result.push data
              cursor = LeanRC::Cursor.new @, result
              yield cursor.first()
          @public @async includes: Function,
            default: (id)->
              yield return (_.find @getData().data, {id})?
        Test::Collection.initialize()
        facade = LeanRC::Facade.getInstance KEY
        COLLECTION_NAME = 'TestEntitiesCollection'
        facade.registerProxy Test::Collection.new COLLECTION_NAME,
          delegate: Test::TestRecord
          serializer: LeanRC::Serializer
          data: []
        collection = facade.retrieveProxy COLLECTION_NAME
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        record = yield collection.create test: 'test3'
        result = yield resource.delete
          pathParams: test_entity: record.id
        assert.isUndefined result
        yield return
  describe '#execute', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should call execution', ->
      co ->
        KEY = 'TEST_RESOURCE_008'
        facade = LeanRC::Facade.getInstance KEY
        class Test extends LeanRC::Module
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        class TestRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @public @static findRecordByName: Function,
            default: (asType) -> TestRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestRecord'
        TestRecord.initialize()
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @include LeanRC::QueryableResourceMixin
          @module Test
          @public entityName: String, { default: 'TestEntity' }
        TestResource.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResque extends LeanRC::Resque
          @inheritProtected()
          @module Test
          @public jobs: Object, { default: {} }
          @public @async getDelayed: Function,
            default: ->
              yield return []
          @public init: Function,
            default: (args...) ->
              @super args...
              @jobs = {}
        TestResque.initialize()
        resque = TestResque.new LeanRC::RESQUE, data: []
        facade.registerProxy resque
        class Collection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::QueryableCollectionMixin
          @module Test
          @public parseQuery: Object,
            default: (aoQuery) ->
              voQuery = _.mapKeys aoQuery, (value, key) -> key.replace /^@doc\./, ''
              voQuery = _.mapValues voQuery, (value, key) ->
                if value['$eq']? then value['$eq'] else value
              $filter: voQuery
          @public @async executeQuery: Function,
            default: (aoParsedQuery) ->
              data = _.filter @getData().data, aoParsedQuery.$filter
              yield LeanRC::Cursor.new @, data
          @public @async push: Function,
            default: (aoRecord) ->
              isExist = (id) => (_.find @getData().data, {id})?
              while isExist key = LeanRC::Utils.uuid.v4() then
              aoRecord.id = key
              i = aoRecord.toJSON()
              @getData().data.push i
              yield return i
          @public @async remove: Function,
            default: (id) ->
              _.remove @getData().data, {id}
              yield return yes
          @public @async take: Function,
            default: (id) ->
              result = []
              if (data = _.find @getData().data, {id})?
                result.push data
              cursor = LeanRC::Cursor.new @, result
              yield cursor.first()
          @public @async includes: Function,
            default: (id)->
              yield return (_.find @getData().data, {id})?
        Collection.initialize()
        COLLECTION_NAME = 'TestEntitiesCollection'
        facade.registerProxy Collection.new COLLECTION_NAME,
          delegate: TestRecord
          serializer: LeanRC::Serializer
          data: []
        facade.registerMediator LeanRC::Mediator.new LeanRC::APPLICATION_MEDIATOR,
          context: {}
        collection = facade.retrieveProxy COLLECTION_NAME
        resource = TestResource.new()
        resource.initializeNotifier KEY
        yield collection.create test: 'test1'
        yield collection.create test: 'test2'
        yield collection.create test: 'test2'
        spySendNotitfication = sinon.spy resource, 'sendNotification'
        testBody =
          context:
            query: query: '{"test":{"$eq":"test2"}}'
            headers: {}
          reverse: 'TEST_REVERSE'
        notification = LeanRC::Notification.new 'TEST_NAME', testBody, 'list'
        yield resource.execute notification
        [ name, body, type ] = spySendNotitfication.lastCall.args
        assert.equal name, LeanRC::HANDLER_RESULT
        {result, resource:voResource} = body
        { meta, items } = result
        assert.deepEqual meta, pagination:
          limit: 50
          offset: 0
        assert.deepEqual voResource, resource
        assert.lengthOf items, 3
        assert.equal type, 'TEST_REVERSE'
        yield return
  describe '#checkApiVersion', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should check API version', ->
      co ->
        KEY = 'TEST_RESOURCE_001'
        facade = LeanRC::Facade.getInstance KEY
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
          @action test: Function,
            default: ->
        Test::TestResource.initialize()
        class TestRouter extends LeanRC::Router
          @inheritProtected()
          @module Test
        TestRouter.initialize()
        class MyResponse extends EventEmitter
          _headers: {}
          getHeaders: -> LeanRC::Utils.copy @_headers
          getHeader: (field) -> @_headers[field.toLowerCase()]
          setHeader: (field, value) -> @_headers[field.toLowerCase()] = value
          removeHeader: (field) -> delete @_headers[field.toLowerCase()]
          end: (data, encoding = 'utf-8', callback = ->) ->
            @finished = yes
            @emit 'finish', data?.toString? encoding
            callback()
          constructor: (args...) ->
            super args...
            { @finished, @_headers } = finished: no, _headers: {}
        req =
          method: 'GET'
          url: 'http://localhost:8888/v/v2.0/test_entity/ID123456'
          headers: 'x-forwarded-for': '192.168.0.1'
        res = new MyResponse
        facade.registerProxy TestRouter.new 'TEST_SWITCH_ROUTER'
        class TestSwitch extends LeanRC::Switch
          @inheritProtected()
          @module Test
          @public routerName: String, { default: 'TEST_SWITCH_ROUTER' }
        TestSwitch.initialize()
        facade.registerMediator TestSwitch.new 'TEST_SWITCH_MEDIATOR'
        switchMediator = facade.retrieveMediator 'TEST_SWITCH_MEDIATOR'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        resource.context = Test::Context.new req, res, switchMediator
        try
          resource.context.pathParams =
            v: 'v1.0'
            test_entity: 'ID123456'
          yield resource.checkApiVersion()
        catch e
        assert.isDefined e
        try
          resource.context.pathParams =
            v: 'v2.0'
            test_entity: 'ID123456'
          yield resource.checkApiVersion()
        catch e
          assert.isDefined e
        yield return
  describe '#setOwnerId', ->
    it 'should get owner ID for body', ->
      co ->
        class Test extends LeanRC
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.session = uid: 'ID123'
        resource.context =
          pathParams: test_entity: 'ID123456'
          request: body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        yield resource.setOwnerId()
        assert.deepEqual resource.recordBody,
          test: 'test9'
          id: 'ID123456'
          ownerId: 'ID123'
        yield return
  describe '#protectOwnerId', ->
    it 'should omit owner ID from body', ->
      co ->
        class Test extends LeanRC
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.session = uid: 'ID123'
        resource.context =
          pathParams: test_entity: 'ID123456'
          request: body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        yield resource.setOwnerId()
        assert.deepEqual resource.recordBody,
          test: 'test9'
          id: 'ID123456'
          ownerId: 'ID123'
        yield resource.protectOwnerId()
        assert.deepEqual resource.recordBody,
          test: 'test9'
          id: 'ID123456'
        yield return
  ###
  # Moved to:
  #   -> AdminingResourceMixin
  #   -> ModellingResourceMixin
  #   -> PersoningResourceMixin
  #   -> SharingResourceMixin
  describe '#setSpaces', ->
    it 'should set space ID for body', ->
      co ->
        class Test extends LeanRC
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.currentUser = id: 'ID123'
        resource.context =
          pathParams: test_entity: 'ID123456', space: 'SPACE123'
          request: body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        yield resource.setSpaces()
        assert.deepEqual resource.recordBody,
          test: 'test9'
          id: 'ID123456'
          spaces: ['SPACE123']
        yield return
  describe '#protectSpaces', ->
    it 'should omit space ID from body', ->
      co ->
        class Test extends LeanRC
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.currentUser = id: 'ID123'
        resource.context =
          pathParams: test_entity: 'ID123456', space: 'SPACE123'
          request: body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        yield resource.setSpaces()
        assert.deepEqual resource.recordBody,
          test: 'test9'
          id: 'ID123456'
          spaces: ['SPACE123']
        yield resource.protectSpaces()
        assert.deepEqual resource.recordBody,
          test: 'test9'
          id: 'ID123456'
        yield return
  ###
  describe '#filterOwnerByCurrentUser', ->
    it 'should update query if caller user is not admin', ->
      co ->
        class Test extends LeanRC
          @inheritProtected()
          @root __dirname
        Test.initialize()
        class Test::TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        Test::TestResource.initialize()
        resource = Test::TestResource.new()
        resource.session = uid: 'ID123', userIsAdmin: no
        resource.context =
          pathParams: test_entity: 'ID123456', space: 'SPACE123'
          request: body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        yield resource.filterOwnerByCurrentUser()
        assert.deepEqual resource.listQuery, $filter: '@doc.ownerId': '$eq': 'ID123'
        yield return
  describe '#checkOwner', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should check if user is resource owner', ->
      co ->
        KEY = 'TEST_RESOURCE_002'
        facade = LeanRC::Facade.getInstance KEY
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        TestResource.initialize()
        class TestRouter extends LeanRC::Router
          @inheritProtected()
          @module Test
        TestRouter.initialize()
        class MyResponse extends EventEmitter
          _headers: {}
          getHeaders: -> LeanRC::Utils.copy @_headers
          getHeader: (field) -> @_headers[field.toLowerCase()]
          setHeader: (field, value) -> @_headers[field.toLowerCase()] = value
          removeHeader: (field) -> delete @_headers[field.toLowerCase()]
          end: (data, encoding = 'utf-8', callback = ->) ->
            @finished = yes
            @emit 'finish', data?.toString? encoding
            callback()
          constructor: (args...) ->
            super args...
            { @finished, @_headers } = finished: no, _headers: {}
        req =
          method: 'GET'
          url: 'http://localhost:8888/space/SPACE123/test_entity/ID123456'
          headers: 'x-forwarded-for': '192.168.0.1'
        res = new MyResponse
        facade.registerProxy TestRouter.new 'TEST_SWITCH_ROUTER'
        class TestSwitch extends LeanRC::Switch
          @inheritProtected()
          @module Test
          @public routerName: String, { default: 'TEST_SWITCH_ROUTER' }
        TestSwitch.initialize()
        class TestEntityRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @attribute ownerId: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestEntityRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestEntityRecord'
        TestEntityRecord.initialize()
        class TestCollection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::MemoryCollectionMixin
          @include LeanRC::GenerateUuidIdMixin
          @module Test
        TestCollection.initialize()
        resource = TestResource.new()
        resource.initializeNotifier KEY
        { collectionName } = resource
        boundCollection = TestCollection.new collectionName,
          delegate: -> TestEntityRecord
        facade.registerProxy boundCollection
        yield boundCollection.create id: 'ID123456', test: 'test', ownerId: 'ID124'
        yield boundCollection.create id: 'ID123457', test: 'test', ownerId: 'ID123'
        facade.registerMediator TestSwitch.new 'TEST_SWITCH_MEDIATOR'
        switchMediator = facade.retrieveMediator 'TEST_SWITCH_MEDIATOR'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        resource.context = Test::Context.new req, res, switchMediator
        resource.context.pathParams = test_entity: 'ID123455', space: 'SPACE123'
        resource.context.request = body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        resource.session = {}
        try
          yield resource.checkOwner()
        catch e
        assert.instanceOf e, httpErrors.Unauthorized
        resource.session = uid: 'ID123', userIsAdmin: no
        resource.context.pathParams.test_entity = 'ID0123456'
        # resource.session = uid: '123456789'
        try
          yield resource.checkOwner()
        catch e
        assert.instanceOf e, httpErrors.NotFound
        resource.context.pathParams.test_entity = 'ID123456'
        try
          yield resource.checkOwner()
        catch e
        assert.instanceOf e, httpErrors.Forbidden
        resource.context.pathParams.test_entity = 'ID123457'
        yield resource.checkOwner()
        yield return
  describe '#checkExistence', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should check if entity exists', ->
      co ->
        KEY = 'TEST_RESOURCE_102'
        facade = LeanRC::Facade.getInstance KEY
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        TestResource.initialize()
        class TestRouter extends LeanRC::Router
          @inheritProtected()
          @module Test
        TestRouter.initialize()
        class MyResponse extends EventEmitter
          _headers: {}
          getHeaders: -> LeanRC::Utils.copy @_headers
          getHeader: (field) -> @_headers[field.toLowerCase()]
          setHeader: (field, value) -> @_headers[field.toLowerCase()] = value
          removeHeader: (field) -> delete @_headers[field.toLowerCase()]
          end: (data, encoding = 'utf-8', callback = ->) ->
            @finished = yes
            @emit 'finish', data?.toString? encoding
            callback()
          constructor: (args...) ->
            super args...
            { @finished, @_headers } = finished: no, _headers: {}
        req =
          method: 'GET'
          url: 'http://localhost:8888/space/SPACE123/test_entity/ID123456'
          headers: 'x-forwarded-for': '192.168.0.1'
        res = new MyResponse
        facade.registerProxy TestRouter.new 'TEST_SWITCH_ROUTER'
        class TestSwitch extends LeanRC::Switch
          @inheritProtected()
          @module Test
          @public routerName: String, { default: 'TEST_SWITCH_ROUTER' }
        TestSwitch.initialize()
        class TestEntityRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @attribute ownerId: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestEntityRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestEntityRecord'
        TestEntityRecord.initialize()
        class TestCollection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::MemoryCollectionMixin
          @include LeanRC::GenerateUuidIdMixin
          @module Test
        TestCollection.initialize()
        resource = TestResource.new()
        resource.initializeNotifier KEY
        { collectionName } = resource
        boundCollection = TestCollection.new collectionName,
          delegate: TestEntityRecord
        facade.registerProxy boundCollection
        yield boundCollection.create id: 'ID123456', test: 'test', ownerId: 'ID124'
        yield boundCollection.create id: 'ID123457', test: 'test', ownerId: 'ID123'
        facade.registerMediator TestSwitch.new 'TEST_SWITCH_MEDIATOR'
        switchMediator = facade.retrieveMediator 'TEST_SWITCH_MEDIATOR'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        resource.context = Test::Context.new req, res, switchMediator
        resource.context.pathParams = test_entity: 'ID123455', space: 'SPACE123'
        resource.context.request = body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.session = uid: 'ID123', userIsAdmin: no
        try
          yield resource.checkExistence()
        catch e
        assert.instanceOf e, httpErrors.NotFound
        resource.context.pathParams.test_entity = 'ID123457'
        resource.getRecordId()
        yield resource.checkExistence()
        yield return
  ### removed???
  describe '#requiredAuthorizationHeader', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should if authorization header exists and valid', ->
      co ->
        KEY = 'TEST_RESOURCE_103'
        facade = LeanRC::Facade.getInstance KEY
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
        TestResource.initialize()
        class TestRouter extends LeanRC::Router
          @inheritProtected()
          @module Test
        TestRouter.initialize()
        class MyResponse extends EventEmitter
          _headers: {}
          getHeaders: -> LeanRC::Utils.copy @_headers
          getHeader: (field) -> @_headers[field.toLowerCase()]
          setHeader: (field, value) -> @_headers[field.toLowerCase()] = value
          removeHeader: (field) -> delete @_headers[field.toLowerCase()]
          end: (data, encoding = 'utf-8', callback = ->) ->
            @finished = yes
            @emit 'finish', data?.toString? encoding
            callback()
          constructor: (args...) ->
            super args...
            { @finished, @_headers } = finished: no, _headers: {}
        req =
          method: 'GET'
          url: 'http://localhost:8888/space/SPACE123/test_entity/ID123456'
          headers: 'x-forwarded-for': '192.168.0.1'
        res = new MyResponse
        facade.registerProxy TestRouter.new 'TEST_SWITCH_ROUTER'
        class TestSwitch extends LeanRC::Switch
          @inheritProtected()
          @module Test
          @public routerName: String, { default: 'TEST_SWITCH_ROUTER' }
        TestSwitch.initialize()
        resource = TestResource.new()
        resource.initializeNotifier KEY
        facade.registerMediator TestSwitch.new 'TEST_SWITCH_MEDIATOR'
        switchMediator = facade.retrieveMediator 'TEST_SWITCH_MEDIATOR'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        resource.context = Test::Context.new req, res, switchMediator
        try
          yield resource.requiredAuthorizationHeader()
        catch err1
        assert.instanceOf err1, httpErrors.Unauthorized
        resource.context.request.headers.authorization = "Auth"
        try
          yield resource.requiredAuthorizationHeader()
        catch err2
        assert.instanceOf err2, httpErrors.Unauthorized
        resource.context.request.headers.authorization = 'Bearer QWERTYUIOPLKJHGFDSA'
        try
          yield resource.requiredAuthorizationHeader()
        catch err3
        assert.instanceOf err3, httpErrors.Unauthorized
        resource.context.request.headers.authorization = "Bearer #{configs.apiKey}"
        try
          yield resource.requiredAuthorizationHeader()
        catch err4
        assert.isUndefined err4
        yield return
  ###
  describe '#adminOnly', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should check if user is administrator', ->
      co ->
        KEY = 'TEST_RESOURCE_003'
        facade = LeanRC::Facade.getInstance KEY
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @public entityName: String,
            default: 'TestEntity'
        TestResource.initialize()
        class TestRouter extends LeanRC::Router
          @inheritProtected()
          @module Test
        TestRouter.initialize()
        class MyResponse extends EventEmitter
          _headers: {}
          getHeaders: -> LeanRC::Utils.copy @_headers
          getHeader: (field) -> @_headers[field.toLowerCase()]
          setHeader: (field, value) -> @_headers[field.toLowerCase()] = value
          removeHeader: (field) -> delete @_headers[field.toLowerCase()]
          end: (data, encoding = 'utf-8', callback = ->) ->
            @finished = yes
            @emit 'finish', data?.toString? encoding
            callback()
          constructor: (args...) ->
            super args...
            { @finished, @_headers } = finished: no, _headers: {}
        req =
          method: 'GET'
          url: 'http://localhost:8888/space/SPACE123/test_entity/ID123456'
          headers: 'x-forwarded-for': '192.168.0.1'
        res = new MyResponse
        facade.registerProxy TestRouter.new 'TEST_SWITCH_ROUTER'
        class TestSwitch extends LeanRC::Switch
          @inheritProtected()
          @module Test
          @public routerName: String, { default: 'TEST_SWITCH_ROUTER' }
        TestSwitch.initialize()
        class TestEntityRecord extends LeanRC::Record
          @inheritProtected()
          @module Test
          @attribute test: String
          @attribute ownerId: String
          @public @static findRecordByName: Function,
            default: (asType) -> Test::TestEntityRecord
          # @public init: Function,
          #   default: ->
          #     @super arguments...
          #     @type = 'Test::TestEntityRecord'
        TestEntityRecord.initialize()
        class TestCollection extends LeanRC::Collection
          @inheritProtected()
          @include LeanRC::MemoryCollectionMixin
          @include LeanRC::GenerateUuidIdMixin
          @module Test
        TestCollection.initialize()
        resource = TestResource.new()
        resource.initializeNotifier KEY
        { collectionName } = resource
        boundCollection = TestCollection.new collectionName,
          delegate: TestEntityRecord
        facade.registerProxy boundCollection
        yield boundCollection.create id: 'ID123456', test: 'test', ownerId: 'ID124'
        facade.registerMediator TestSwitch.new 'TEST_SWITCH_MEDIATOR'
        switchMediator = facade.retrieveMediator 'TEST_SWITCH_MEDIATOR'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        resource.context = Test::Context.new req, res, switchMediator
        resource.context.pathParams = test_entity: 'ID123456', space: 'SPACE123'
        resource.context.request = body: test_entity: test: 'test9'
        resource.getRecordId()
        resource.getRecordBody()
        resource.beforeUpdate()
        resource.session = {}
        try
          yield resource.checkOwner()
        catch e
        assert.instanceOf e, httpErrors.Unauthorized
        resource.session = uid: 'ID123'
        try
          yield resource.adminOnly()
        catch e
        assert.instanceOf e, httpErrors.Forbidden
        resource.session = uid: 'ID123', userIsAdmin: yes
        yield resource.adminOnly()
        yield return
  describe '#doAction', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should run specified action', ->
      co ->
        KEY = 'TEST_RESOURCE_104'
        facade = LeanRC::Facade.getInstance KEY
        testAction = sinon.spy -> yield return
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResque extends LeanRC::Resque
          @inheritProtected()
          @module Test
          @public jobs: Object, { default: {} }
          @public @async getDelayed: Function,
            default: ->
              yield return []
          @public init: Function,
            default: (args...) ->
              @super args...
              @jobs = {}
        TestResque.initialize()
        resque = TestResque.new LeanRC::RESQUE, data: []
        facade.registerProxy resque
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @action @async test: Function,
            default: testAction
        TestResource.initialize()
        class TestRouter extends LeanRC::Router
          @inheritProtected()
          @module Test
        TestRouter.initialize()
        class MyResponse extends EventEmitter
          _headers: {}
          getHeaders: -> LeanRC::Utils.copy @_headers
          getHeader: (field) -> @_headers[field.toLowerCase()]
          setHeader: (field, value) -> @_headers[field.toLowerCase()] = value
          removeHeader: (field) -> delete @_headers[field.toLowerCase()]
          end: (data, encoding = 'utf-8', callback = ->) ->
            @finished = yes
            @emit 'finish', data?.toString? encoding
            callback()
          constructor: (args...) ->
            super args...
            { @finished, @_headers } = finished: no, _headers: {}
        req =
          method: 'GET'
          url: 'http://localhost:8888/space/SPACE123/test_entity/ID123456'
          headers: 'x-forwarded-for': '192.168.0.1'
        res = new MyResponse
        facade.registerProxy TestRouter.new 'TEST_SWITCH_ROUTER'
        class TestSwitch extends LeanRC::Switch
          @inheritProtected()
          @module Test
          @public routerName: String, { default: 'TEST_SWITCH_ROUTER' }
        TestSwitch.initialize()
        resource = TestResource.new()
        resource.initializeNotifier KEY
        facade.registerMediator TestSwitch.new 'TEST_SWITCH_MEDIATOR'
        switchMediator = facade.retrieveMediator 'TEST_SWITCH_MEDIATOR'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        context = Test::Context.new req, res, switchMediator
        yield resource.doAction 'test', context
        assert.isTrue testAction.calledWith context
        yield return
  describe '#saveDelayeds', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should save delayed jobs from cache into queue', ->
      co ->
        MULTITON_KEY = 'TEST_RESOURCE_105|>123456765432'
        facade = LeanRC::Facade.getInstance MULTITON_KEY
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResque extends LeanRC::Resque
          @inheritProtected()
          @module Test
          @public jobs: Object, { default: {} }
          @public @async ensureQueue: Function,
            default: (asQueueName, anConcurrency) ->
              queue = _.find @getData().data, name: asQueueName
              if queue?
                queue.concurrency = anConcurrency
              else
                queue = name: asQueueName, concurrency: anConcurrency
                @getData().data.push queue
              yield return queue
          @public @async getQueue: Function,
            default: (asQueueName) ->
              yield return _.find @getData().data, name: asQueueName
          @public @async pushJob: Function,
            default: (name, scriptName, data, delayUntil) ->
              id = LeanRC::Utils.uuid.v4()
              @jobs[id] = { name, scriptName, data, delayUntil }
              yield return id
          @public init: Function,
            default: (args...) ->
              @super args...
              @jobs = {}
        TestResque.initialize()
        resque = TestResque.new LeanRC::RESQUE, data: []
        facade.registerProxy resque
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
        TestResource.initialize()
        resource = TestResource.new()
        resource.initializeNotifier MULTITON_KEY
        DELAY = Date.now() + 1000000
        yield resque.create 'TEST_QUEUE_1', 4
        yield resque.delay 'TEST_QUEUE_1', 'TestScript', { data: 'data1' }, DELAY
        yield resque.delay 'TEST_QUEUE_1', 'TestScript', { data: 'data2' }, DELAY
        yield resque.delay 'TEST_QUEUE_1', 'TestScript', { data: 'data3' }, DELAY
        yield resque.delay 'TEST_QUEUE_1', 'TestScript', { data: 'data4' }, DELAY
        yield resource.saveDelayeds { facade }
        delayeds = resque.jobs
        index = 0
        for id, delayed of delayeds
          assert.isDefined delayed
          assert.isNotNull delayed
          assert.include delayed,
            name: 'TEST_QUEUE_1'
            scriptName: 'TestScript'
            delayUntil: DELAY
          assert.deepEqual delayed.data, data: "data#{index + 1}"
          ++index
        yield return
  describe '#writeTransaction', ->
    facade = null
    afterEach ->
      facade?.remove?()
    it 'should test if transaction is needed', ->
      co ->
        KEY = 'TEST_RESOURCE_106'
        facade = LeanRC::Facade.getInstance KEY
        testAction = sinon.spy -> yield return
        class Test extends LeanRC
          @inheritProtected()
          @root "#{__dirname}/config/root"
        Test.initialize()
        configs = LeanRC::Configuration.new LeanRC::CONFIGURATION, Test::ROOT
        facade.registerProxy configs
        class TestResource extends LeanRC::Resource
          @inheritProtected()
          @module Test
          @action @async test: Function,
            default: testAction
        TestResource.initialize()
        class TestRouter extends LeanRC::Router
          @inheritProtected()
          @module Test
        TestRouter.initialize()
        class MyResponse extends EventEmitter
          _headers: {}
          getHeaders: -> LeanRC::Utils.copy @_headers
          getHeader: (field) -> @_headers[field.toLowerCase()]
          setHeader: (field, value) -> @_headers[field.toLowerCase()] = value
          removeHeader: (field) -> delete @_headers[field.toLowerCase()]
          end: (data, encoding = 'utf-8', callback = ->) ->
            @finished = yes
            @emit 'finish', data?.toString? encoding
            callback()
          constructor: (args...) ->
            super args...
            { @finished, @_headers } = finished: no, _headers: {}
        req =
          method: 'GET'
          url: 'http://localhost:8888/space/SPACE123/test_entity/ID123456'
          headers: 'x-forwarded-for': '192.168.0.1'
        res = new MyResponse
        facade.registerProxy TestRouter.new 'TEST_SWITCH_ROUTER'
        class TestSwitch extends LeanRC::Switch
          @inheritProtected()
          @module Test
          @public routerName: String, { default: 'TEST_SWITCH_ROUTER' }
        TestSwitch.initialize()
        resource = TestResource.new()
        resource.initializeNotifier KEY
        facade.registerMediator TestSwitch.new 'TEST_SWITCH_MEDIATOR'
        switchMediator = facade.retrieveMediator 'TEST_SWITCH_MEDIATOR'
        resource = Test::TestResource.new()
        resource.initializeNotifier KEY
        context = Test::Context.new req, res, switchMediator
        assert.isFalse yield resource.writeTransaction 'test', context
        context.request.method = 'POST'
        assert.isTrue yield resource.writeTransaction 'test', context
        yield return
