# должен имплементировать интерфейс CursorInterface
# является оберткой над обычным массивом

_  = require 'lodash'


module.exports = (Module)->
  class Cursor extends Module::CoreObject
    @inheritProtected()
    @module Module
    @implements Module::CursorInterface

    ipnCurrentIndex = @private currentIndex: Number,
      default: 0
    iplArray = @private array: Array

    ipoCollection = @private collection: Module::Collection

    @public setRecord: Function,
      default: (acRecord)->
        @[ipoCollection] = acRecord
        return @

    @public @async toArray: Function,
      default: (acRecord = null)->
        while yield @hasNext()
          yield @next acRecord

    @public @async next: Function,
      default: (acRecord = null)->
        acRecord ?= @[ipoCollection].delegate
        data = @[iplArray][@[ipnCurrentIndex]]
        @[ipnCurrentIndex]++
        yield Module::Promise.resolve if acRecord?
          if _.isObject data
            acRecord.new data, @[ipoCollection]
          else
            data
        else
          data

    @public @async hasNext: Function,
      default: ->
        yield Module::Promise.resolve not _.isNil @[iplArray][@[ipnCurrentIndex]]

    @public @async close: Function,
      default: ->
        for item, i in @[iplArray]
          delete @[iplArray][i]
        delete @[iplArray]
        yield return

    @public @async count: Function,
      default: ->
        array = @[iplArray] ? []
        yield Module::Promise.resolve array.length?() ? array.length

    @public @async forEach: Function,
      default: (lambda, acRecord = null)->
        index = 0
        try
          while yield @hasNext()
            yield lambda (yield @next acRecord), index++
          return
        catch err
          yield @close()
          throw err

    @public @async map: Function,
      default: (lambda, acRecord = null)->
        index = 0
        try
          while yield @hasNext()
            yield lambda (yield @next acRecord), index++
        catch err
          yield @close()
          throw err

    @public @async filter: Function,
      default: (lambda, acRecord = null)->
        index = 0
        records = []
        try
          while yield @hasNext()
            record = yield @next acRecord
            if yield lambda record, index++
              records.push record
          records
        catch err
          yield @close()
          throw err

    @public @async find: Function,
      default: (lambda, acRecord = null)->
        index = 0
        _record = null
        try
          while yield @hasNext()
            record = yield @next acRecord
            if yield lambda record, index++
              _record = record
              break
          _record
        catch err
          yield @close()
          throw err

    @public @async compact: Function,
      default: (acRecord = null)->
        acRecord ?= @[ipoCollection].delegate
        records = []
        try
          while @[ipnCurrentIndex] < yield @count()
            rawRecord = @[iplArray][@[ipnCurrentIndex]]
            ++@[ipnCurrentIndex]
            unless _.isNil rawRecord
              if _.isNumber rawRecord
                record = rawRecord
              else
                record = acRecord.new rawRecord
              records.push record
          records
        catch err
          yield @close()
          throw err

    @public @async reduce: Function,
      default: (lambda, initialValue, acRecord = null)->
        try
          index = 0
          _initialValue = initialValue
          while yield @hasNext()
            _initialValue = yield lambda _initialValue, (yield @next acRecord), index++
          _initialValue
        catch err
          yield @close()
          throw err

    @public @async first: Function,
      default: (acRecord = null)->
        try
          if yield @hasNext()
            yield @next acRecord
          else
            null
        catch err
          yield @close()
          throw err

    @public init: Function,
      default: (aoCollection, alArray = null)->
        @super arguments...
        @[ipoCollection] = aoCollection
        @[iplArray] = alArray


  Cursor.initialize()
