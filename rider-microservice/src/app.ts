import express from 'express';
import {json} from 'body-parser';
// import routers 
import {indexRiderRouter} from './routes/index';
import { createRiderRotuer } from './routes/new';
import { showRiderRouter } from './routes/show';
import { updateRiderRouter } from './routes/update';
import { errorRiderRouter } from './routes/error';
import { errorHandler } from '@cygnetops/common';
// init app with express 
const app = express(); 

// set middleware 
app.use(json());
//add router 
app.use(indexRiderRouter);
app.use(createRiderRotuer);
app.use(showRiderRouter);
app.use(updateRiderRouter);

// any routes not recognized throw an erro 
app.use(errorRiderRouter);
// add errorhandler 
app.use(errorHandler);
//export app 
export {app};



