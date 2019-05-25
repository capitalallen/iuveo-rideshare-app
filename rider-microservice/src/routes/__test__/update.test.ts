import request from 'supertest';
import { app } from '../../app';
import mongoose from 'mongoose';
import { Rider } from '../../models/rider';

it('returns a 404 if the provided id does not exist', async () => {
  const id = new mongoose.Types.ObjectId().toHexString();
  await request(app)
    .put(`/api/riders/${id}`)
    .set('Cookie', global.signin())
    .send({
      title: 'aslkdfj',
      price: 20,
    })
    .expect(404);
});

it('returns a 401 if the user is not authenticated', async () => {
  const id = new mongoose.Types.ObjectId().toHexString();
  await request(app)
    .put(`/api/riders/${id}`)
    .send({
      title: 'aslkdfj',
      price: 20,
    })
    .expect(401);
});

it('returns a 401 if the user does not own the rider', async () => {
  const response = await request(app)
    .post('/api/riders')
    .set('Cookie', global.signin())
    .send({
      title: 'asldkfj',
      price: 20,
    });

  await request(app)
    .put(`/api/riders/${response.body.id}`)
    .set('Cookie', global.signin())
    .send({
      title: 'alskdjflskjdf',
      price: 1000,
    })
    .expect(401);
});

it('returns a 400 if the user provides an invalid title or price', async () => {
  const cookie = global.signin();

  const response = await request(app)
    .post('/api/riders')
    .set('Cookie', cookie)
    .send({
      title: 'asldkfj',
      price: 20,
    });

  await request(app)
    .put(`/api/riders/${response.body.id}`)
    .set('Cookie', cookie)
    .send({
      title: '',
      price: 20,
    })
    .expect(400);

  await request(app)
    .put(`/api/riders/${response.body.id}`)
    .set('Cookie', cookie)
    .send({
      title: 'alskdfjj',
      price: -10,
    })
    .expect(400);
});

it('updates the rider provided valid inputs', async () => {
  const cookie = global.signin();

  const response = await request(app)
    .post('/api/riders')
    .set('Cookie', cookie)
    .send({
      title: 'asldkfj',
      price: 20,
    });

  await request(app)
    .put(`/api/riders/${response.body.id}`)
    .set('Cookie', cookie)
    .send({
      title: 'new title',
      price: 100,
    })
    .expect(200);

  const riderResponse = await request(app)
    .get(`/api/riders/${response.body.id}`)
    .send();

  expect(riderResponse.body.title).toEqual('new title');
  expect(riderResponse.body.price).toEqual(100);
});


it('rejects updates if the rider is reserved', async () => {
  const cookie = global.signin();

  const response = await request(app)
    .post('/api/riders')
    .set('Cookie', cookie)
    .send({
      title: 'asldkfj',
      price: 20,
    });

  const rider = await Rider.findById(response.body.id);
  rider!.set({ orderId: mongoose.Types.ObjectId().toHexString() });
  await rider!.save();

  await request(app)
    .put(`/api/riders/${response.body.id}`)
    .set('Cookie', cookie)
    .send({
      title: 'new title',
      price: 100,
    })
    .expect(400);
});
