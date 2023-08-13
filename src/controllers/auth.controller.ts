import 'dotenv/config';
import { NextFunction, Request, Response } from 'express';
import * as authService from '../services/auth.service';
import { createUserInput } from '../models/auth.model';

const generateCookieOptions = () => {
  const isProduction = process.env.NODE_ENV === 'production';
  const cookieOptions: {
    maxAge: number;
    httpOnly: boolean;
    secure?: boolean;
  } = {
    maxAge: 1 * 24 * 60 * 60 * 1000, // 1 day
    httpOnly: true,
  };
  if (isProduction) {
    cookieOptions.secure = true;
  }
  return cookieOptions;
};

const sendResponse = (res: Response, userData: any) => {
  const cookieOptions = generateCookieOptions();
  res.cookie('refreshToken', userData.refreshToken, cookieOptions);
  return res.status(201).json({
    status: 'success',
    data: {
      userData,
    },
  });
};

export const registerUserHandler = async (
  req: Request<{}, {}, createUserInput>,
  res: Response,
  next: NextFunction
) => {
  try {
    const userData = await authService.register(req.body);
    return sendResponse(res, userData);
  } catch (err) {
    next(err);
  }
};

export const loginUserHandler = async (
  req: Request<{}, {}, createUserInput>,
  res: Response,
  next: NextFunction
) => {
  try {
    const { email, password } = req.body;
    const userData = await authService.login(email, password);
    sendResponse(res, userData);
  } catch (err) {
    next(err);
  }
};

export const refreshAccessTokenHandler = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { refreshToken } = req.cookies;
    const userData = await authService.refresh(refreshToken);
    sendResponse(res, userData);
  } catch (err) {
    next(err);
  }
};

export const logoutHandler = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    res.cookie('refreshToken', '', { maxAge: -1 });
    res.status(200).json({
      status: 'success',
      message: 'User logged out successfully',
    });
  } catch (err) {
    next(err);
  }
};
