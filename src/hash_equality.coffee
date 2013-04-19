difflet = require 'difflet'
charm   = require 'charm'
should  = require 'should'

should.Assertion.prototype.equalHash = (expected) ->
  actual = @obj
  differenceMap =
    inserted:
      color: 'green'
      count: 0
    updated:  
      color: 'blue'
      count: 0
    deleted: 
      color: 'red'
      count: 0
    comment:
      color: 'cyan'
      count: 0

  colorForDifference = (type, stream, incrementCounter = true) =>
    @c ?= charm(stream)
    differenceMap[type].count += 1 if incrementCounter
    @c.foreground differenceMap[type].color
    @c.display 'bright'

  resetColor = (type, stream) =>
    @c.display 'reset'

  differenceFound = ->
    diff = difflet(comment: true, indent: 2, start: colorForDifference, stop: resetColor)
    diffStr = diff.compare actual, expected
    for type, val of differenceMap
      return diffStr if val.count > 0
    false

  constructStream = ->
    Stream = require('stream').Stream
    stream = new Stream
    stream.readable = true
    stream.writable = true

    stream.write = (buf) -> @emit('data', buf)
    stream.end = -> @emit('end')
    stream

  differenceSummary = =>
    str = 'Total differences: '
    stream = constructStream()
    stream.on 'data', (data) -> str += data
    
    delete @c
    for type, val of differenceMap
      colorForDifference type, stream, false
      stream.emit 'data', "\t#{type}: #{val.count}\t"
      resetColor type, stream
    str

  differences = differenceFound()
  should.equal !!differences, false, "\n#{differences}\n\n#{differenceSummary()}\n\n"