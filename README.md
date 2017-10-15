# Transparent Logger

This logger binds console logging functions to produce log output with consistent code references in developer console.

It also supports log levels and a log hierarchy, such that you can control levels in the hierarchy.

A simple logger:

```coffee
  logger = require('tlogger')
  logger.setLevel('debug')
```

I developed this logger for atom packages and tests run in atom suite, so there is some specific support for this:

```coffee
  logger = require('tlogger')
  # logger starts per default in logging only errors
  logger.setSpecLevel('debug')
  log.debug 'this message appears only in atom spec test mode'
```

You have following logging functions:

```coffee
  logger = require('tlogger')
  fooLogger = logger.getLogger('foo')
  barLogger = logger.getLogger('foo.bar')
  oneMoreBarLogger = fooLogger.getLogger('bar')
  barLogger is oneMoreBarLogger # is true
  fooLogger.setLevel('info')
  barLogger.level # is also 'info' now
  barLogger.setLevel 'silent' # no logging at all

  logger.debug "debug message"
  logger.trace "stack trace at this position"
  logger.log   "a log message"
  logger.info  "information"
  logger.warn  "warning"
  logger.error "error"
```

Log levels are configured as follows:

| level  | value |
|--------|-------|
| silent | 0     |
| error  | 1     |
| warn   | 2     |
| info   | 3     |
| log    | 4     |
| trace  | 5     |
| debug  | 6     |
