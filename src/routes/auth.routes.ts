import { isAuth } from '../middleware/isAuth';
import { Router } from 'express';
import {
  loginUserHandler,
  logoutHandler,
  refreshAccessTokenHandler,
  registerUserHandler,
} from '../controllers/auth.controller';

const authRouter = Router();

//Register user
authRouter.post('/register', registerUserHandler);
authRouter.post('/login', loginUserHandler);
authRouter.get('/logout', isAuth, logoutHandler);
authRouter.get('refresh', refreshAccessTokenHandler);

export default authRouter;
