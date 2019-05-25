import express, {Request,Response} from 'express';
import { Rider } from '../models/rider';
import { NotFoundError } from '@cygnetops/common';

const router = express.Router();

router.get('/api/v1/rider/:id',async(req:Request,res:Response)=>{
  const rider = await Rider.findById(req.params.id);
  if (!rider) {
    throw new NotFoundError();
  }

  res.send(rider);
})


export {router as showRiderRouter}