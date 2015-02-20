difflet = require 'difflet'
charm   = require 'charm'
should  = require 'should'
AssertionError = require('assert').AssertionError

getDifferences = (actual, expected) ->
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

  formatDifferences = (diffString) =>
    return unless diffString

    differenceSummary = =>
      str = 'Total differences: '
      stream = constructStream()
      stream.on 'data', (data) -> str += data

      delete @c
      for type, val of differenceMap
        continue if type == 'comment'

        colorForDifference type, stream, false
        stream.emit 'data', "\t#{type}: #{val.count}\t"
        resetColor type, stream
      str

    "\n\u001b[0m#{diffString}\n\n#{differenceSummary()}\n\n"

  formatDifferences differenceFound()

detailedDifferenceMatcher = (expected) ->
  differences = getDifferences @obj, expected
  isOk        = if @negate then !!differences else !differences
  @assert isOk, (-> console.log(differences); "The Objects differ"), (-> 'The Objects are identical')
  this

inclusionMatcher = (expected) ->
  found = false
  for val in @obj
    differences = getDifferences val, expected
    found       = if @negate then !!differences else !differences
    break if found

  @assert found, (-> "The Object was not found"), (-> 'The Objects was included')


unchainedTester = (equalityTest, negated) ->
  (expected, actual) ->
    if negated
      return true if actual? and not expected?
      return true if expected? and not actual?
      actual.should.not[equalityTest] expected

    else
      return should.not.exist(actual) unless expected
      should.exist expected
      should.exist actual
      actual.should[equalityTest] expected

unchainedDetailedDifferenceMatcher = (negated = false) ->
  unchainedTester('equalObject', negated)

unchainedInclusionMatcher = (negated = false) ->
  unchainedTester('includeObject', negated)

# chained
should.Assertion.prototype.equalArray = should.Assertion.prototype.equalObject = should.Assertion.prototype.equalObj = detailedDifferenceMatcher
should.Assertion.prototype.includeArray = should.Assertion.prototype.includeObject = should.Assertion.prototype.includeObj = inclusionMatcher

# unchained
should.equalArray = should.equalObj = should.equalObject = unchainedDetailedDifferenceMatcher()
should.includeArray = should.includeObj = should.includeObject = unchainedInclusionMatcher()

#unchained negated
should.not.equalArray = should.not.equalObj = should.not.equalObject = unchainedDetailedDifferenceMatcher(true)
should.not.includeArray = should.not.includeObj = should.not.includeObject = unchainedInclusionMatcher(true)

module.exports = should