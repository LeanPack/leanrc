

module.exports = (Module)->
  {
    PointerT
    FuncG, MaybeG
    PipeFittingInterface, PipeMessageInterface
    CoreObject
  } = Module::

  class Pipe extends CoreObject
    @inheritProtected()
    @implements PipeFittingInterface
    @module Module

    ipoOutput = PointerT @protected output: MaybeG PipeFittingInterface

    @public connect: FuncG(PipeFittingInterface, Boolean),
      default: (aoOutput)->
        vbSuccess = no
        unless @[ipoOutput]?
          @[ipoOutput] = aoOutput
          vbSuccess = yes
        vbSuccess

    @public disconnect: FuncG([], MaybeG PipeFittingInterface),
      default: ->
        disconnectedFitting = @[ipoOutput]
        @[ipoOutput] = null
        disconnectedFitting

    @public write: FuncG(PipeMessageInterface, Boolean),
      default: (aoMessage)->
        return @[ipoOutput]?.write(aoMessage) ? yes

    @public @static @async restoreObject: Function,
      default: ->
        throw new Error "restoreObject method not supported for #{@name}"
        yield return

    @public @static @async replicateObject: Function,
      default: ->
        throw new Error "replicateObject method not supported for #{@name}"
        yield return

    @public init: FuncG([MaybeG PipeFittingInterface]),
      default: (aoOutput)->
        @super arguments...
        if aoOutput?
          @connect aoOutput
        return


    @initialize()
