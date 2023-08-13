import { Router } from 'express';
import authRouter from './auth.routes';

const api = Router();

api.use(authRouter);

export default api;
