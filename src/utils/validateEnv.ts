import { cleanEnv, port, str } from 'envalid';

const validateEnv = () => {
  cleanEnv(process.env, {
    PORT: port(),
    ACCESS_TOKEN_SECRET_KEY: str(),
    REFRESH_TOKEN_SECRET_KEY: str(),
    ACCESS_TOKEN_EXPIRESIN: str(),
    REFRESH_TOKEN_EXPIRESIN: str(),
  });
};

export default validateEnv;
