'use strict';

const assert = require('assert');
const app = require('../../../src/app');

describe('conversation service', () => {
  it('registered the conversations service', () => {
    assert.ok(app.service('conversations'));
  });
});
