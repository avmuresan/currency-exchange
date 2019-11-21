import { camelize, underscore } from './inflection';

const each = (object, callback) => {
  for (let key in object) {
    // eslint-disable-next-line
    if (object.hasOwnProperty(key)) {
      callback(object[key], key);
    }
  }
};

const map = (object, callback) => {
  let mapped = isArray(object) ? [] : {};
  if (isArray(object)) {
    each(object, (v, k) => {
      mapped.push(callback(v, k));
    });
  }
  else {
    each(object, (v, k) => {
      mapped[k] = callback(v, k);
    });
  }
  return mapped;
};

const isArray = (object) => {
  return isObject(object) && object.constructor === Array;
};

const isObject = (object) => {
  return object !== null && typeof object === 'object';
};

const isTransformable = (object) => {
  return isObject(object);
};

const transformKeys = (object, transformKey) => {
  // Do not modify strings, numbers or booleans
  if (!isTransformable(object)) {
    return object;
  }

  // If object is an array we transform keys of all items in the array
  if (isArray(object)) {
    return map(object, (o) => {
      return transformKeys(o, transformKey);
    });
  }

  // Translate all keys and child objects
  let translated = {};
  each(object, (v, k) => {
    k = transformKey(k);
    if (isObject(v)) {
      translated[k] = transformKeys(v, transformKey);
    }
    else {
      translated[k] = v;
    }
  });
  return translated;
};

const camelizeKeys = (object) => {
  return transformKeys(object, camelize);
};

const underscoreKeys = (object) => {
  return transformKeys(object, underscore);
};

export {
  camelizeKeys,
  underscoreKeys
};
