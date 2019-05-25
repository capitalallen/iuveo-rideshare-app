import mongoose from "mongoose";
import { updateIfCurrentPlugin } from "mongoose-update-if-current";
import { string } from "yargs";

// An interface that describes the properties
// that are requried to create a new rider
interface RiderAttrs {
  name: string;
  email: string;
  joined_date: Date;
  gender: string;
  country: string;
  phone_no: number;
  dob: Date;
  curr_payment_type: string;
}

// An interface that describes the properties
// that a Rider Model has
interface RiderModel extends mongoose.Model<RiderDoc> {
  build(attrs: RiderAttrs): RiderDoc;
}

// An interface that describes the properties
// that a Rider Document has
interface RiderDoc extends mongoose.Document {
  name: string;
  email: string;
  joined_date: Date;
  gender: string;
  country: string;
  phone_no: number;
  dob: Date;
  curr_payment_type: string;
}

// Create a Schema corresponding to the document interface.
const riderSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
        type: String,
        required: true,
      },
    joined_date: {
      type: Date,
      required: true,
    },
    gender: {
      type: String,
      required: true,
    },
    country: {
      type: String,
      required: true,
    },
    phone_no: {
      type: Number,
      required: true,
    },
    dob: {
      type: Date,
      required: true,
    },
    curr_payment_type: {
      type: String,
      required: true,
    },
  },
  {
    toJSON: {
      transform(doc, ret) {
        ret.id = ret._id;
        delete ret._id;
      },
    },
  }
);

riderSchema.set('versionKey','version');
riderSchema.plugin(updateIfCurrentPlugin);
// get a custom function added to the model 
// get typescript involved in the process of creating a user
riderSchema.statics.build = (attrs: RiderAttrs)=>{
    return new Rider(attrs);
}

const Rider = mongoose.model<RiderDoc,RiderModel>("Rider",riderSchema);

export {Rider}