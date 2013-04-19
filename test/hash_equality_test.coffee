should = require 'should'
require '../index'

describe '#equalsHash', ->
  it 'should correctly match a hash', ->
    {test: 'yay'}.should.equalHash {test: 'yay'}

  it 'should not correctly match divergent hashes', ->
    {test: 'yay'}.should.not.equalHash {test: 'yay!'}