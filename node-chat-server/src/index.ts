import express, { Router } from 'express';
import http from 'http';
import * as controller from './apis';
import { Server } from 'socket.io';
import { socketService } from './socket';

const app = express();
export const server = http.createServer(app);
export const roomList = new Map();
export const io = new Server(server);

const routes: Router = Router({ mergeParams: true });

app.use(routes);

routes.get('/rooms', controller.getRoomsInfo);

routes.post('/room', controller.createRoom);

socketService(io);

server.listen(3000, () => {
  console.log('Server is running on port 3000');
});
