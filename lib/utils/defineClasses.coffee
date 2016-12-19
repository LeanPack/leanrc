_                     = require 'lodash'
inflect               = require('i')()
fs                    = require 'fs'
extend                = require './extend'

folders = [
  'mixins'
  'utils'
  'models'
  'controllers'
]

defineClasses = (path, reDefine = yes)->

  manifest = require "#{path}/../manifest.json"
  {prefix} = manifest.foxxmcModule
  Prefix = inflect.classify prefix
  if reDefine or not global["#{Prefix}"]?
    global["#{Prefix}"] = eval "(
      function() {
        function #{Prefix}() {}
        return #{Prefix};
    })();"
    extend global["#{Prefix}"], _.omit manifest, ['name']
    global["#{Prefix}"].use = ->
      new @::ApplicationRouter()

  getModulesPathes = ()->
    pathToModules = fs.join "#{path}/node_modules"
    fs.listTree pathToModules
      .filter (i)->
        /^foxxmc\-/.test i
      .map (i)->
        fs.join pathToModules, i

  getClassesFor = (subfolder)->
    require(fs.join path, subfolder, 'index')()
    # console.log '??????????/ getClassesFor', fs.join(path, subfolder, 'index'), Prefix, global["#{Prefix}"]::
    # console.log '??????????/ getClassesFor 222', require '/var/lib/arangodb3-apps/_db/test_foxxmc/test/APP/dist/mixins/index'
    return

  initializeModule = (addonPath, cb)->
    module.exports addonPath
    cb()

  recursionModulesInitializing = (addonsPathes, index)->
    if addonsPathes[index]?
      addonPath = addonsPathes[index].replace '/index.js', ''
      Module = require addonsPathes[index]

      if Module.initialize? and _.isFunction Module.initialize
        Module.initialize ()->
          index += 1
          if addonsPathes[index]?
            return recursionModulesInitializing addonsPathes, index
          else
            return
      else
        initializeModule addonPath, ()->
          index += 1
          if addonsPathes[index]?
            return recursionModulesInitializing addonsPathes, index
          else
            return
    else
      return

  # здесь надо проинициализоировать все аддоны, от которых зависит это приложение/аддон
  recursionModulesInitializing getModulesPathes(), 0

  if reDefine or not global["#{Prefix}"]?
    folders.forEach (subfolder)->
      getClassesFor subfolder
    global["#{Prefix}"]::ApplicationRouter = require fs.join path, 'router'
    # console.log ">>>>>>>>>>>1111", global["#{Prefix}"]::
    global['classes'] ?= {}
    global['classes']["#{Prefix}"] = global["#{Prefix}"]
  # global['classes']["#{Prefix}"] = eval "(
  #   function() {
  #     function #{Prefix}() {}
  #     return #{Prefix};
  # })();"
  # global['classes']["#{Prefix}"] = extend global['classes']["#{Prefix}"], _.omit manifest, ['name']
  # global['classes']["#{Prefix}"].use = ->
  #   new @::ApplicationRouter()
  # for own className, classObject of global["#{Prefix}"]::
  #   global['classes']["#{Prefix}"]::[className] = classObject
  # console.log ">>>>>>>>>>>222", global["#{Prefix}"]::, global['classes']["#{Prefix}"]::
  return global["#{Prefix}"]

module.exports = defineClasses
