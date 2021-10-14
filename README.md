very-assertive
==============

[![Build Status](https://travis-ci.org/benkitzelman/very-assertive.png)](https://travis-ci.org/benkitzelman/very-assertive)

A collection of node.js should library assertions

using
=====

very-assertive mixes in with other should assertions, therefore all you need to do is require it...

`npm install very-assertive`

```js

require('very-assertive')

```

equalObject
===========

print detailed info on differences between JS objects... handy for large object comparisons.

```js
const one = {nice: 'one'};
const two = {nice: 'two'};

one.should.equalObject(one);
one.should.not.equalObject(two);
```

equalArray
===========

print detailed info on differences between JS arrays.

```js
const one = [1,2,3];
const two = [4,5,6];

one.should.equalArray(one);
one.should.not.equalArray(two);
```

example output
==============

This failing test:

```js
{missing:'content', stable: 'unchanged'}.should.equalObject({newProperty: 'added', stable: 'unchanged'});
```

will output hash differences like:

![Example](https://raw.github.com/benkitzelman/very-assertive/master/diffs.png)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/benkitzelman/very-assertive/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

