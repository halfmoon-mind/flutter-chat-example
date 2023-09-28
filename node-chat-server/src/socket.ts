import { Server } from 'socket.io';

export const socketService = (io: Server) => {
  io.on('connection', (socket) => {
    console.log('User connected');

    socket.on('join_room', (room) => {
      socket.join(room);
      console.log(`User joined room ${room}`);
    });

    socket.on('send_message', (data) => {
      const { room, message } = data;
      console.log(`User sent message to room ${room}: ${message}`);
      io.to(room).emit('receive_message', message);
    });

    socket.on('disconnect', () => {
      socket.disconnect();
      console.log('User disconnected');
    });

    socket.on('leave_room', (room) => {
      socket.leave(room);
      console.log(`User left room ${room}`);
    });
  });
};
