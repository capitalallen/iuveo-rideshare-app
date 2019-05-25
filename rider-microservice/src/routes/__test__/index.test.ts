import request from 'supertest';
import { app } from '../../app';

const createRider = () => {
  return request(app).post('/api/rider').send({
    id: 1
  });
};

it('can fetch a list of riders', async () => {
  await createRider();
  await createRider();
  await createRider();

  const response = await request(app).get('/api/rider').send().expect(200);

  expect(response.body.length).toEqual(3);
});
