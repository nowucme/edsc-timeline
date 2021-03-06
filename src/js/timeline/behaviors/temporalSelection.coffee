Draggable = require('../draggable')

module.exports = class
  addTo: (@tl) ->
    el = @tl._findScopedEl('.display-top')
    $(el).on 'click', @clear

    @draggable = new Draggable(el, false)
      .on 'dragstart', @dragstart, this
      .on 'dragmove', @dragmove, this
      .on 'dragend', @dragend, this

  removeFrom: (tl) ->
    tl._findScoped('.display-top').off 'click', @clear
    @draggable.dispose()
    @_left?.dispose()
    @_right?.dispose()
    @_left = @_right = @draggable = @tl = null

  clear: (e) =>
    @tl.clearTemporal(true) unless @_dragging

  dragstart: (e) ->
    @_dragging = true
    tl = @tl
    overlay = tl.selectionOverlay
    tl._empty(overlay)
    indexes = (i for i in [0...tl._rows.length])
    x = e.cursor.x - e.offset.x
    [@_left, @_right] = tl._createSelectionRegion(overlay, x, x, indexes)

  dragmove: (e) ->
    @_right._onUpdate(e)

  dragend: (e) ->
    @tl.root.trigger("createdtemporal.#{@tl.namespace}")
    @_right._onEnd(e)
    @_dragging = false
