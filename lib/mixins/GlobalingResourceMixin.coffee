_             = require 'lodash'
statuses      = require 'statuses'

HTTP_NOT_FOUND    = statuses 'not found'


module.exports = (Module)->
  {
    Resource
  } = Module::

  Module.defineMixin Resource, (BaseClass) ->
    class GlobalingResourceMixin extends BaseClass
      @inheritProtected()

      @beforeHook 'limitByDefaultSpace', only: ['list']

      @public @async limitByDefaultSpace: Function,
        default: (args...)->
          @listQuery ?= {}
          if @listQuery.$filter?
            @listQuery.$filter = $and: [
              @listQuery.$filter
            ,
              '@doc.spaces': $all: ['_default']
            ]
          else
            @listQuery.$filter = '@doc.spaces': $all: ['_default']
          yield return args

      @public @async checkExistence: Function,
        default: (args...)->
          unless @recordId?
            @context.throw HTTP_NOT_FOUND
          unless (yield @collection.exists
            '@doc.id': $eq: @recordId
            '@doc.spaces': $all: ['_default']
          )
            @context.throw HTTP_NOT_FOUND
          yield return args


    GlobalingResourceMixin.initializeMixin()
