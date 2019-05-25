import express, { Request, Response } from "express";
import { body } from "express-validator";
import { Rider } from "../models/rider";

const router = express.Router();

router.post("/api/v1/rider", async (req: Request, res: Response) => {
  const {
    name,
    email,
    joined_date,
    gender,
    country,
    phone_no,
    dob,
    curr_payment_type,
  } = req.body;
  let existingRider = null;
  try{
    existingRider = await Rider.findOne({ email });
  } catch(err){
    console.log(err)
  }
  if (existingRider) {
    console.log("Rider exists");
    return res.send("Rider exists");
  }
  const rider = Rider.build({
    name,
    email,
    joined_date,
    gender,
    country,
    phone_no,
    dob,
    curr_payment_type,
  });
  await rider.save();
});

export { router as createRiderRotuer };
