import { NotFoundError } from '@cygnetops/common';
import express, {Request,Response} from 'express';
import { Rider } from '../models/rider';

const router = express.Router();

router.put('/api/v1/rider/:id',async(req:Request,res:Response)=>{
  const rider = await Rider.findById(req.params.id);
  if (!rider) {
    throw new NotFoundError();
  }
  rider.set({
    name: req.body.name
  })
  await rider.save();
  res.send(rider);
});


export {router as updateRiderRouter}