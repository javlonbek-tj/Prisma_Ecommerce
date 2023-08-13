import 'dotenv/config';
import { SignOptions } from 'jsonwebtoken';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import config from 'config';
import ApiError from '../utils/appError';
import { User } from '../models/user.model';
import { createUserInput } from '../models/auth.model';
import { db } from '../utils/db';

const signJwt = (
  payload: Object,
  keyName: 'accessTokenSecretKey' | 'refreshTokenSecretKey',
  options: SignOptions
) => {
  const secretKey = config.get<string>(keyName);
  return jwt.sign(payload, secretKey, {
    ...(options && options),
  });
};

export const verifyJwt = <T>(
  token: string,
  keyName: 'accessTokenSecretKey' | 'refreshTokenSecretKey'
): T | null => {
  try {
    const secretKey = config.get<string>(keyName);
    const decoded = jwt.verify(token, secretKey) as T;
    return decoded;
  } catch (err) {
    return null;
  }
};

const signTokens = async (user: Partial<User>) => {
  const accessToken = signJwt(
    { sub: user.id, email: user.email },
    'accessTokenSecretKey',
    {
      expiresIn: config.get<string>('accessTokenExpiresIn'),
    }
  );
  const refreshToken = signJwt(
    { sub: user.id, email: user.email },
    'refreshTokenSecretKey',
    {
      expiresIn: config.get<string>('refreshTokenExpiresIn'),
    }
  );
  return { ...user, accessToken, refreshToken };
};

export const register = async (input: createUserInput) => {
  const existingUser = await db.user.findUnique({
    where: { email: input.email },
  });
  if (existingUser) {
    throw ApiError.BadRequest('User is already existed');
  }
  const hashedPassword = bcrypt.hashSync(input.password, 12);
  const user = await db.user.create({
    data: {
      email: input.email,
      password: hashedPassword,
      role: 'USER',
    },
    select: {
      email: true,
      id: true,
    },
  });
  return signTokens(user);
};

export const login = async (email: string, password: string) => {
  const user = await db.user.findUnique({ where: { email } });
  if (!user) {
    throw ApiError.BadRequest('Email or Password incorrect');
  }
  const isPasswordsMatch = await bcrypt.compare(password, user.password);
  if (!isPasswordsMatch) {
    throw ApiError.BadRequest('Email or Password incorrect');
  }
  user.password = undefined;
  return await signTokens(user);
};

export const refresh = async (refreshToken: string) => {
  if (!refreshToken) {
    throw ApiError.UnauthenticatedError();
  }
  const userData = verifyJwt<Partial<User>>(
    refreshToken,
    'refreshTokenSecretKey'
  );
  if (!userData) {
    throw ApiError.UnauthenticatedError();
  }
  const user = await db.user.findUnique({
    where: { id: userData.id },
    select: { email: true, id: true },
  });
  return await signTokens(user);
};
