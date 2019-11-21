// Helpers
const isString = (o) => typeof o === 'string';

// Camelize
const camelize = (subject, firstUpperCased = false) => {
  if (!isString(subject)) {
    return subject;
  }

  let transformed = subject.replace(/[^A-Za-z0-9]+/g, ' ')
    .replace(/ ([A-Za-z0-9])/g, (m) => m[1].toUpperCase())
    .replace(/^([A-Z])/g, (m) => m[0].toLowerCase());

  if (firstUpperCased) {
    transformed = transformed.split('');
    transformed[0] = transformed[0].toUpperCase();
    transformed = transformed.join('');
  }

  return transformed;
};

// Underscore
const underscore = (subject) => {
  if (!isString(subject)) {
    return subject;
  }

  return subject
    .replace(/(?:([0-9a-z])([A-Z])|([a-zA-Z])([0-9]))/g, '$1$3 $2$4')
    .replace(/[ -]+/g, '_')
    .toLowerCase();
};

// Dasherize
const dasherize = (subject) => {
  if (!isString(subject)) {
    return subject;
  }
  return underscore(subject).replace(/_/g, '-');
};

// Exports
export { camelize, underscore, dasherize };
