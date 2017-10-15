
class Logger
  LEVEL:
    silent:  0
    error:   1
    warn:    2
    info:    4
    log:     5
    trace:   6
    debug:   7

  LEVELS: [ 'silent', 'error', 'warn', 'info', 'log', 'trace', 'debug' ]

  constructor: (@name, {@prefix,@parent,level}={}) ->
    @prefix = @prefix ? @name
    @children = {}
    @setLevel(level or 'error')

  setLevel: (level) ->
    return this unless level?

    if level isnt @level
      @level = level

      if level of @LEVEL
        _level = @LEVEL[level]
      else
        _level = level

      for logLevel in @LEVELS
        if @LEVEL[logLevel] <= _level
          if console[logLevel]
            @[logLevel] = console[logLevel].bind console, logLevel.toUpperCase(), @prefix
          else
            @[logLevel] = console.log.bind console, logLevel.toUpperCase(), @prefix
        else
          @[logLevel] = ->

    for name,child of @children
      child.setLevel level

    this

  setSpecLevel: (level) ->
    if atom?.inSpecMode()
      @setLevel level
    else
      this

  getLogger: (name, {level}={}) ->
    unless name?
      return this

    if typeof name is 'string'
      name = name.split('.')

    part = name.shift()
    if part not of @children
      @children[part] = new Logger(part, parent: this, level: level ? @level )

    logger = @children[part]
    logger = if name.length then logger.getLogger(name) else logger

    logger.setLevel level


module.exports = new Logger('', parent: null, level: 'error')
