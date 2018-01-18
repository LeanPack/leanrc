# миксин может подмешиваться в наследники класса Module


module.exports = (Module)->
  {
    Module: ModuleClass
    Utils: { _, filesListSync }
  } = Module::

  Module.defineMixin 'SchemaModuleMixin', (BaseClass = ModuleClass) ->
    class extends BaseClass
      @inheritProtected()

      @public @static defineMigrations: Function,
        default: (asRoot = @::ROOT ? '.') ->
          vsMigratonsDir = "#{asRoot}/migrations"
          files = filesListSync vsMigratonsDir
          vlMigrationNames = _.orderBy _.compact (files ? []).map (i)=>
            migrationName = i.replace /\.js|\.coffee/, ''
            if migrationName isnt 'BaseMigration' and not /^\.|\.md$/.test migrationName
              vsMigrationPath = "#{vsMigratonsDir}/#{migrationName}"
              require(vsMigrationPath) @Module
              migrationName
            else
              null
          @const MIGRATION_NAMES: vlMigrationNames
          return


      @initializeMixin()
