@HashUtils =
  deepUpdateCollectionItem: (object, collectionPath, item, primaryKey) ->
    collection = ObjectPath.get object, collectionPath
    return unless collection

    [old, index] = @findItem collection, item, primaryKey

    if old
      collection[index] = item
    else
      collection.push item

    @set object, collectionPath, collection

  deepSortCollectionItem: (object, collectionPath, item, position, primaryKey) ->
    collection = ObjectPath.get object, collectionPath
    [old, index] = @findItem collection, item, primaryKey

    if old
      collection.splice index, 1
      collection.splice position, 0, old

    @set object, collectionPath, collection

  deepRemoveCollectionItem: (object, collectionPath, item, primaryKey) ->
    collection = ObjectPath.get object, collectionPath
    [old, index] = @findItem collection, item, primaryKey

    if old
      collection.splice index, 1

    @set object, collectionPath, collection

  # An immutable variant of ObjectPath.set that saves the original object
  #
  set: (object, path, value) ->
    object = $.extend {}, object
    ObjectPath.set object, path, value
    object

  findItem: (collection, item, primaryKey='id', callback) ->
    return unless collection
    targetKey = if typeof item is 'object' then item[primaryKey] else item
    old = (collection.filter (i) -> i[primaryKey] == targetKey)[0]
    index = collection.indexOf(old) if old
    callback(old, index) if callback
    [old, index]

  groupBy: (items, path) ->
    final = {}

    return final unless items

    for item in items
      key = ObjectPath.get item, path
      final[key] ||= []
      final[key].push item

    final
