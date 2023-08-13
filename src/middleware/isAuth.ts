import { NextFunction, Request, Response } from 'express';
import ApiError from '../utils/appError';
import { verifyJwt } from '../services/auth.service';
import { db } from '../utils/db';

export const isAuth = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    let accessToken: string;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      accessToken = req.headers.authorization.split(' ')[1];
    } else if (req.cookies.accessToken) {
      accessToken = req.cookies.accessToken;
    }
    if (!accessToken) {
      return next(ApiError.UnauthenticatedError());
    }
    const decoded = verifyJwt<{ sub: string; email: string; iat: number }>(
      accessToken,
      'accessTokenSecretKey'
    );
    if (!decoded) {
      return next(ApiError.UnauthenticatedError());
    }

    const currentUser = await db.user.findUnique({
      where: { id: decoded.sub },
    });
    if (!currentUser) {
      return next(ApiError.UnauthenticatedError());
    }
    res.locals.user = currentUser;
    next();
  } catch (err) {
    next(err);
  }
};
