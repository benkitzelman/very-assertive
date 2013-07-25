should = require '../index'

describe '#equalObject', ->
  it 'should correctly match a hash', ->
    {test: 'yay'}.should.equalObject {test: 'yay'}

  it 'should be callable unchained', ->
    subject = {test: 'yay'}
    should.equalObject subject, subject

  it 'should obey the negation property', ->
    {test: 'yay'}.should.not.equalObject {test: 'yay!'}

  it 'should detect differences on deeply nested properties', ->
    {test: {one: {two:'yay'}}}.should.not.equalObject {test: {one: {two:'yay!'}}}

describe '#equalArray', ->
  it 'should be callable unchained', ->
    subject = [1,2,3]
    should.equalArray subject, subject

  it 'should correctly match an array', ->
    [1,2,3].should.equalArray [1,2,3]

  it 'should obey the negation property', ->
    [1,2,3].should.not.equalArray [1,2,4]

  it 'should detect differences on deeply nested properties', ->
    [{a:'a'}, {b:{c:'c'}}].should.not.equalObject [{a:'a'}, {b:{c:'d'}}]
