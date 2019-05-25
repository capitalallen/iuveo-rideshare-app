import request from 'supertest';
import { app } from '../../app';
import mongoose from 'mongoose';

it('returns a 404 if the rider is not found', async () => {
  const id = new mongoose.Types.ObjectId().toHexString();

  await request(app).get(`/api/riders/${id}`).send().expect(404);
});

it('returns the rider if the rider is found', async () => {
  const title = 'concert';
  const price = 20;

  const response = await request(app)
    .post('/api/riders')
    .set('Cookie', global.signin())
    .send({
      title,
      price,
    })
    .expect(201);

  const riderResponse = await request(app)
    .get(`/api/riders/${response.body.id}`)
    .send()
    .expect(200);

  expect(riderResponse.body.title).toEqual(title);
  expect(riderResponse.body.price).toEqual(price);
});
