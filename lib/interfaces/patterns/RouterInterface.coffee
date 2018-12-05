# здесь нужно определить интерфейс класса Router
# ApplicationRouter будет наследоваться от Command класса, и в него будет подмешиваться миксин RouterMixin
# на основе декларативно объявленной карты роутов, он будет оркестрировать медиаторы, которые будут отвечать за принятие сигналов от Express или Foxx


module.exports = (Module)->
  {
    NilT
    FuncG, MaybeG, InterfaceG, EnumG, ListG, UnionG
    ProxyInterface
  } = Module::

  class RouterInterface extends ProxyInterface
    @inheritProtected()
    @module Module

    @virtual path: MaybeG String

    @virtual name: MaybeG String

    @virtual above: MaybeG Object

    @virtual tag: MaybeG String

    @virtual templates: MaybeG String

    @virtual param: MaybeG String

    @virtual defaultEntityName: FuncG [], String

    @virtual @static map: FuncG [MaybeG Function], NilT

    @virtual map: Function

    @virtual root: FuncG [InterfaceG {
      to: MaybeG String
      at: MaybeG EnumG 'collection', 'member'
      resource: MaybeG String
      action: MaybeG String
    }], NilT

    @virtual defineMethod: FuncG [
      MaybeG ListG InterfaceG {
        method: String
        path: String
        resource: String
        action: String
        tag: String
        template: String
        keyName: MaybeG String
        entityName: String
        recordName: MaybeG String
      }
      String
      String
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual get: FuncG [
      String,
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual post: FuncG [
      String,
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual put: FuncG [
      String,
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual delete: FuncG [
      String,
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual head: FuncG [
      String,
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual options: FuncG [
      String,
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual patch: FuncG [
      String,
      MaybeG InterfaceG {
        to: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        action: MaybeG String
        tag: MaybeG String
        template: MaybeG String
        keyName: MaybeG String
        entityName: MaybeG String
        recordName: MaybeG String
      }
    ], NilT

    @virtual resource: FuncG [
      String
      MaybeG UnionG(InterfaceG({
        path: MaybeG String
        module: MaybeG String
        only: MaybeG UnionG String, ListG String
        via: MaybeG UnionG String, ListG String
        except: MaybeG UnionG String, ListG String
        tag: MaybeG String
        templates: MaybeG String
        param: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        resource: MaybeG String
        above: MaybeG Object
      }), Function)
      MaybeG Function
    ], NilT

    @virtual namespace: FuncG [
      MaybeG String
      UnionG(InterfaceG({
        module: MaybeG String
        prefix: MaybeG String
        tag: MaybeG String
        templates: MaybeG String
        at: MaybeG EnumG 'collection', 'member'
        above: MaybeG Object
      }), Function)
      MaybeG Function
    ], NilT

    @virtual member: FuncG Function, NilT

    @virtual collection: FuncG Function, NilT

    @virtual routes: ListG InterfaceG {
      method: String
      path: String
      resource: String
      action: String
      tag: String
      template: String
      keyName: MaybeG String
      entityName: String
      recordName: MaybeG String
    }


    @initialize()
