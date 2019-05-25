import { NotFoundError } from '@cygnetops/common';
import express, { Request, Response } from 'express';
// import { Ticket } from '../models/ticket';

const router = express.Router();

router.get('*', async (req: Request, res: Response) => {
  // const tickets = await Ticket.find({});

  throw new NotFoundError();
});

export { router as errorRiderRouter };
