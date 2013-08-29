should = require '../index'

describe '#equalObject', ->
  xit 'should find a difference', ->
    {test:' asdad'}.should.equalObject {as:"rwerwr"}

  it 'should correctly match a hash', ->
    {test: 'yay'}.should.equalObject {test: 'yay'}

  it 'should correctly match strings', ->
    should.equalObj "blah", "blah"

  it 'should obey the negation property', ->
    {test: 'yay'}.should.not.equalObject {test: 'yay!'}

  it 'should detect differences on deeply nested properties', ->
    {test: {one: {two:'yay'}}}.should.not.equalObject {test: {one: {two:'yay!'}}}

  it 'should detect differences on strings', ->
    should.not.equalObj "blah", "not blah"

  describe 'unchained', ->
    it 'should be callable', ->
      subject = {test: 'yay'}
      should.equalObject subject, subject

    it 'should be true when both null', ->
      should.equalObject null, null

    it 'should be true when comparing null and undefined', ->
      should.equalObject null, undefined

    describe 'negated', ->
      it 'should be callable', ->
        should.not.equalObject {test: 'yay'}, {test: 'boo'}

      it 'should handle null actuals', ->
        should.not.equalObject {test: 'yay'}, null

      it 'should handle null expecteds', ->
        should.not.equalObject null, {test: 'yay'}

describe '#equalObj', ->
  it 'should be an alias for equalObject', ->
    should.equalObj.should.eql should.equalObject

describe '#equalArray', ->
  it 'should be an alias for equalObject', ->
    should.equalArray.should.eql should.equalObject

  it 'should be callable unchained', ->
    subject = [1,2,3]
    should.equalArray subject, subject

  it 'should correctly match an array', ->
    [1,2,3].should.equalArray [1,2,3]

  it 'should obey the negation property', ->
    [1,2,3].should.not.equalArray [1,2,4]

  it 'should detect differences on deeply nested properties', ->
    [{a:'a'}, {b:{c:'c'}}].should.not.equalObject [{a:'a'}, {b:{c:'d'}}]


describe '#includeObject', ->
  it 'should correctly find an object in an array', ->
    obj = {test: 'yay'}
    [1, "string", {something: 'else'}, obj].should.includeObject obj

  it 'should obey the negation property', ->
    [1, "string", {something: 'else'}].should.not.includeObject {test: 'yay'}

  describe 'unchained', ->
    it 'should be callable', ->
      subject = {test: 'yay'}
      should.includeObject subject, [subject]

    it 'should be true when both null', ->
      should.includeObject null, null

    it 'should be true when comparing null and undefined', ->
      should.includeObject null, undefined

    describe 'negated', ->
      it 'should be callable', ->
        should.not.includeObject {test: 'yay'}, [{test: 'boo'}]

      it 'should handle null actuals', ->
        should.not.includeObject {test: 'yay'}, null

      it 'should handle null expecteds', ->
        should.not.includeObject null, {test: 'yay'}