Codepoint = require('./codepoint')

module.exports =
class Breakpoint extends Codepoint
  atom.deserializers.add(this)
  @version: '1c'
  @breakpointId: 1
  @TYPE_LINE = 'line'
  @TYPE_EXCEPTION = 'exception'


  @getNextBreakpointId: () ->
    return @breakpointId++

  constructor: ({filepath, marker, line, @type, @exception}) ->
    super
    if !@type
      @type =  Breakpoint.TYPE_LINE
    @id = Breakpoint.getNextBreakpointId()


  serialize: -> {
    deserializer: 'Breakpoint'
    version: @constructor.version
    data: {
      filepath: @getPath()
      line: @getLine()
    }
  }

  @deserialize: ({data}) ->
    return new Breakpoint(filepath: data.filepath, line: data.line)


  getId: ->
    return @id

  getType: ->
    return @type

  getException: ->
    return @exception

  isLessThan: (other) ->
    return true if !other instanceof Breakpoint
    return true if other.getPath() < @getPath()
    return true if other.getLine() < @getLine()

  isEqual: (other) ->
    return false if !other instanceof Breakpoint
    return false if other.getPath() != @getPath()
    return false if other.getLine() != @getLine()
    return true

  isGreaterThan: (other) ->
    return !@isLessThan(other) && !@isEqual(other)

  @fromMarker: (marker) ->
