import express, { Request, Response } from 'express';
import { Rider } from '../models/rider';


const router = express.Router();

router.get('/api/v1/rider', async (req: Request, res: Response) => {
  const rider = await Rider.find({});

  res.send(rider);
});

export { router as indexRiderRouter };
