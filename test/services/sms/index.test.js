'use strict';

const assert = require('assert');
const app = require('../../../src/app');

describe('sms service', () => {
  it('registered the sms service', () => {
    assert.ok(app.service('sms'));
  });
});
