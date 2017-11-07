_             = require 'lodash'
statuses      = require 'statuses'

HTTP_NOT_FOUND    = statuses 'not found'
UNAUTHORIZED      = statuses 'unauthorized'
FORBIDDEN         = statuses 'forbidden'


module.exports = (Module)->
  {
    SPACES
    ROLES

    Resource
    RecordInterface
  } = Module::

  Module.defineMixin Resource, (BaseClass) ->
    class AdminingResourceMixin extends BaseClass
      @inheritProtected()

      @public spaces: Array
      @public space: RecordInterface

      @public @async limitBySpace: Function,
        default: (args...)->
          @listQuery ?= {}
          currentSpace = @context.pathParams.space
          if @listQuery.$filter?
            @listQuery.$filter = $and: [
              @listQuery.$filter
            ,
              '@doc.spaces': $all: [currentSpace]
            ]
          else
            @listQuery.$filter = '@doc.spaces': $all: [currentSpace]
          yield return args

      @public @async checkExistence: Function,
        default: (args...)->
          currentSpace = @context.pathParams.space
          unless @recordId?
            @context.throw HTTP_NOT_FOUND
          unless (yield @collection.exists
            '@doc.id': $eq: @recordId
            '@doc.spaces': $all: [currentSpace]
          )
            @context.throw HTTP_NOT_FOUND
          yield return args

      @public @async setOwnerId: Function,
        default: (args...)->
          @recordBody.ownerId = 'system'
          yield return args

      @public @async setSpaces: Function,
        default: (args...)->
          @recordBody.spaces ?= []
          unless _.includes @recordBody.spaces, '_internal'
            @recordBody.spaces.push '_internal'
          unless _.includes @recordBody.spaces, @currentUser.spaceId
            @recordBody.spaces.push @currentUser.spaceId
          currentSpace = @context.pathParams.space
          unless _.includes @recordBody.spaces, currentSpace
            @recordBody.spaces.push currentSpace
          yield return args

      @public @async protectSpaces: Function,
        default: (args...)->
          @recordBody = _.omit @recordBody, ['spaces']
          yield return args

      ipoCheckRole = @private @async checkRole: Function,
        default: (spaceId, userId, action)->
          RolesCollection = @facade.retrieveProxy ROLES
          role = yield (yield RolesCollection.findBy
            '@doc.spaces': $all: [spaceId]
            userId: userId
          ).first()
          resourceKey = "#{@Module.name}::#{@constructor.name}"
          if role?
            {rules} = role
            if not rules? and role.getRules?
              rules = yield role.getRules()
          if rules?['system']?['administrator']
            yield return yes
          else if rules?['moderator']?[resourceKey]
            yield return yes
          else if rules?[resourceKey]?[action]
            yield return yes
          else
            yield return no

      ipoCheckPermission = @private @async checkPermission: Function,
        default: (space, chainName)->
          else if yield @[ipoCheckRole] space, @currentUser?.id, chainName
            yield return yes
          else
            @context.throw FORBIDDEN, "Current user has no access"
            yield return

      @public @async checkPermission: Function,
        default: checkPermission = (args...)->
          SpacesCollection = @facade.retrieveProxy SPACES
          @space = yield SpacesCollection.find @context.pathParams['space']
          if @currentUser.isAdmin
            yield return args
          {chainName} = checkPermission.wrapper
          yield @[ipoCheckPermission] '_internal', chainName
          yield return args


    AdminingResourceMixin.initializeMixin()
