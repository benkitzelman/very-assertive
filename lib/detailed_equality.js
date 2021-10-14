const difflet = require('difflet');
const charm   = require('charm');
const should  = require('should');

const getDifferences = function (actual, expected) {
  const differenceMap = {
    inserted: {
      color: 'green',
      count: 0
    },
    updated: {
      color: 'blue',
      count: 0
    },
    deleted: {
      color: 'red',
      count: 0
    },
    comment: {
      color: 'cyan',
      count: 0
    }
  };

  const colorForDifference = (type, stream, incrementCounter) => {
    if (incrementCounter == null) { incrementCounter = true; }
    if (!this.c) { this.c = charm(stream); }
    if (incrementCounter) { differenceMap[type].count += 1; }
    this.c.foreground(differenceMap[type].color);
    return this.c.display('bright');
  };

  const resetColor = () => {
    return this.c.display('reset');
  };

  const differenceFound = function () {
    const diff = difflet({ comment: true, indent: 2, start: colorForDifference, stop: resetColor });
    const diffStr = diff.compare(actual, expected);
    for (const type in differenceMap) {
      const val = differenceMap[type];
      if (val.count > 0) { return diffStr; }
    }
    return false;
  };

  const constructStream = function () {
    const { Stream } = require('stream');
    const stream = new Stream();
    stream.readable = true;
    stream.writable = true;

    stream.write = function (buf) { return this.emit('data', buf); };
    stream.end = function () { return this.emit('end'); };
    return stream;
  };

  const formatDifferences = (diffString) => {
    if (!diffString) { return; }

    const differenceSummary = () => {
      let str = 'Total differences: ';
      const stream = constructStream();
      stream.on('data', (data) => {
        str += data;
      });

      delete this.c;
      for (const type in differenceMap) {
        const val = differenceMap[type];
        if (type === 'comment') { continue; }

        colorForDifference(type, stream, false);
        stream.emit('data', `\t${type}: ${val.count}\t`);
        resetColor(type, stream);
      }
      return str;
    };

    return `\n\u001b[0m${diffString}\n\n${differenceSummary()}\n\n`;
  };

  return formatDifferences(differenceFound());
};

const detailedDifferenceMatcher = function (expected) {
  const differences = getDifferences(this.obj, expected);
  const isOk        = this.negate ? !!differences : !differences;
  this.assert(isOk, (() => { console.log(differences); return "The Objects differ"; }), (() => 'The Objects are identical'));
  return this;
};

const inclusionMatcher = function (expected) {
  let found = false;
  for (const val of this.obj) {
    const differences = getDifferences(val, expected);
    found       = this.negate ? !!differences : !differences;
    if (found) { break; }
  }

  this.assert(found, (() => "The Object was not found"), (() => 'The Objects was included'));
};

const unchainedTester = function (equalityTest, negated) {
  return (expected, actual) => {
    if (negated) {
      if ((actual != null) && (expected == null)) { return true; }
      if ((expected != null) && (actual == null)) { return true; }
      actual.should.not[equalityTest](expected);
    } else {
      if (!expected) { return should.not.exist(actual); }
      should.exist(expected);
      should.exist(actual);
      actual.should[equalityTest](expected);
    }
  };
};

const unchainedDetailedDifferenceMatcher = function (negated) {
  if (negated == null) { negated = false; }
  return unchainedTester('equalObject', negated);
};

const unchainedInclusionMatcher = function (negated) {
  if (negated == null) { negated = false; }
  return unchainedTester('includeObject', negated);
};

// chained
should.Assertion.prototype.equalArray = should.Assertion.prototype.equalObject = should.Assertion.prototype.equalObj = detailedDifferenceMatcher;
should.Assertion.prototype.includeArray = should.Assertion.prototype.includeObject = should.Assertion.prototype.includeObj = inclusionMatcher;

// unchained
should.equalArray = should.equalObj = should.equalObject = unchainedDetailedDifferenceMatcher();
should.includeArray = should.includeObj = should.includeObject = unchainedInclusionMatcher();

// unchained negated
should.not.equalArray = should.not.equalObj = should.not.equalObject = unchainedDetailedDifferenceMatcher(true);
should.not.includeArray = should.not.includeObj = should.not.includeObject = unchainedInclusionMatcher(true);

module.exports = should;
