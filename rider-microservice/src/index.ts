import {app} from './app';
import mongoose, { mongo } from 'mongoose';

const start = async()=>{
    // try to connect to mongodb server 
    try {
        await mongoose.connect("mongodb://riders-mongo-srv:27017/rider",{
            useNewUrlParser: true,
            useUnifiedTopology: true,
            useCreateIndex: true 
        });
        console.log("connected to mongodb");
    } catch (error) {
        console.log(error)
    }
    // start the server 
    app.listen(3000,()=>{
        console.log("Listening on port 3000!");
    })
}
start(); 


