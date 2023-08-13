import 'dotenv/config';
import express from 'express';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import config from 'config';
import validateEnv from './utils/validateEnv';
import logger from './utils/logger';
import errorMiddleware from './middleware/error.middleware';
import api from './routes';

const port = config.get<number>('port');

async function start() {
  try {
    // VALIDATE ENV
    validateEnv();

    const app = express();
    app.use(express.json());
    app.use(cookieParser());

    app.use(
      cors({
        credentials: true,
        // origin: config.get<string>('clientUrl'),
        origin: '*',
      })
    );

    app.use('/api/v1', api);

    //404 error
    app.use('*', (req, res) => {
      res.status(404).json({
        status: 'fail',
        message: `${req.originalUrl} - Route Not Found`,
      });
    });
    app.use(errorMiddleware);

    app.listen(port);
    console.log(`Server started on port: ${port}`);
  } catch (err) {
    logger.error('Error in starting server', err);
  }
}

start();
