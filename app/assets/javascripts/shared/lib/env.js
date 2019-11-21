const environmentTypes = ['production', 'development', 'test'];
let environmentData = {};

let env = (key, fallback='fallback') => {
  let value = environmentData[key];
  return (value !== undefined) ? value : fallback;
};

env.set = (data) => {
  let environmentType = data.env;

  delete data.env;
  environmentData = data;

  if (typeof environmentType === 'undefined') {
    environmentType = 'development';
  }

  environmentTypes.forEach(key => {
    env[key] = environmentType === key;
  });
};

export default env;
