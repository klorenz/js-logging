logging = require '../src/logging.coffee'

describe "transparent console logger", ->
  logs = null
  debugs = null
  infos = null
  warns = null
  errors = null
  traces = null
  logger = null

  beforeEach ->
    logs = []
    debugs = []
    infos = []
    warns = []
    errors = []
    traces = []

    spyOn(console, 'log').andCallFake (args...) ->
      logs.push args

    spyOn(console, 'debug').andCallFake (args...) ->
      debugs.push args

    spyOn(console, 'info').andCallFake (args...) ->
      infos.push args

    spyOn(console, 'warn').andCallFake (args...) ->
      warns.push args

    spyOn(console, 'trace').andCallFake (args...) ->
      traces.push args

    spyOn(console, 'error').andCallFake (args...) ->
      errors.push args

  testLog = (logger) ->
    logger.error "error"
    logger.warn "warning"
    logger.info "info"
    logger.log "log"
    logger.trace "trace"
    logger.debug "bar"

  it "can log a line", ->
    logger = logging.getLogger('test', level: 'info')
    logger.info "info"
    expect(infos.length).toBe 1
    expect(infos[0]).toEqual(['INFO', 'test', 'info'])

  it "can control the logging with levels", ->
    logger = logging.getLogger 'test', level: 'info'
    testLog(logger)
    expect(errors.length).toBe 1
    expect(warns.length).toBe 1
    expect(infos.length).toBe 1
    expect(debugs.length).toBe 0
    expect(traces.length).toBe 0
    expect(logs.length).toBe 0

  it "can have a log hierarchy", ->
    debugger
    foo = logging.getLogger 'foo'
    fooBar = logging.getLogger 'foo.bar', level: 'info'

    testLog(foo)
    testLog(fooBar)

    expect(infos.length).toBe 1
    expect(errors.length).toBe 2

    foo.setLevel 'debug'

    testLog(foo)
    testLog(fooBar)

    expect(debugs.length).toBe 2
