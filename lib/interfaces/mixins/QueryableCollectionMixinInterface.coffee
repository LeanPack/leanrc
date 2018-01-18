

# методы `parseQuery` и `executeQuery` должны быть реализованы в миксинах в отдельных подлючаемых npm-модулях т.к. будут содержать некоторый платформозависимый код.


module.exports = (Module)->
  {ANY, NILL} = Module::

  Module.defineInterface 'QueryableCollectionMixinInterface', (BaseClass) ->
    class extends BaseClass
      @inheritProtected()

      @public @async @virtual deleteBy: Function,
        args: [Object]
        return: NILL

      @public @async @virtual destroyBy: Function,
        args: [Object]
        return: NILL
      @public @async @virtual removeBy: Function, # обращается к БД
        args: [Object]
        return: NILL

      @public @async @virtual findBy: Function,
        args: [Object]
        return: Module::CursorInterface
      @public @async @virtual takeBy: Function, # обращается к БД
        args: [Object, [Object, NILL]]
        return: Module::CursorInterface

      @public @async @virtual updateBy: Function,
        args: [Object, Object]
        return: NILL
      @public @async @virtual patchBy: Function, # обращается к БД
        args: [Object, Module::RecordInterface]
        return: NILL

      @public @async @virtual exists: Function,
        args: [Object]
        return: Boolean



      @public @async @virtual query: Function,
        args: [[Object, Module::QueryInterface]]
        return: ANY
      @public @async @virtual parseQuery: Function, # описание того как стандартный (query object) преобразовать в конкретный запрос к конкретной базе данных
        args: [[Object, Module::QueryInterface]]
        return: [Object, String, Module::QueryInterface]
      @public @async @virtual executeQuery: Function,
        args: [[Object, String, Module::QueryInterface], Object] # query, options
        return: ANY


      @initializeInterface()
