import { Server } from 'socket.io';
import { roomList } from '.';

export const socketService = (io: Server) => {
  io.on('connection', (socket) => {
    console.log('User connected');

    socket.on('join_room', (room) => {
      socket.join(room);
      console.log(`User joined room ${room}`);

      if (roomList.has(room)) {
        roomList.set(room, roomList.get(room) + 1);
      } else {
        roomList.set(room, 1);
      }
    });

    socket.on('send_message', (data) => {
      const { room, message } = data;
      console.log(`User sent message to room ${room}: ${message}`);
      io.to(room).emit('receive_message', message);
    });

    socket.on('disconnect', () => {
      console.log('User disconnected');
    });

    socket.on('leave_room', (room) => {
      socket.leave(room);

      // 방 목록 업데이트
      if (roomList.has(room)) {
        const count = roomList.get(room) - 1;

        if (count === 0) {
          roomList.delete(room);
        } else {
          roomList.set(room, count);
        }
      }
    });
  });
};
