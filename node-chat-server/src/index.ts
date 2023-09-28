import express, { Router } from 'express';
import http from 'http';
import * as controller from './apis';
import { Server } from 'socket.io';
import { socketService } from './socket';
import Room from './model/room';

const app = express();
export const server = http.createServer(app);
export const roomList: Room[] = [];
export const io = new Server(server);

const routes: Router = Router({ mergeParams: true });

app.use(routes);

routes.get('/rooms', controller.getRoomsInfo);
routes.post('/room', controller.createRoom);
routes.post('/join', controller.joinRoom);
routes.post('/leave', controller.leaveRoom);

socketService(io);

server.listen(3000, () => {
  console.log('Server is running on port 3000');
});
