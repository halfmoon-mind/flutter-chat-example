import { Server, Socket } from 'socket.io';
import { roomList } from '.';
import User from './model/user';

export const socketService = (io: Server) => {
  io.on('connection', (socket) => {
    console.log('User connected');

    socket.on('join_room', (data) => {
      const { room, nickname } = data;
      socket.join(room);

      const targetRoom = roomList.find((e) => e.id === room);
      if (targetRoom) {
        targetRoom.users.push(new User(nickname, socket.id));
      }
      socket.emit('join_room', `${nickname} joined room ${room}`);
      console.log(`User joined room ${room}`);
    });

    socket.on('send_message', (data) => {
      const { room, nickname, message } = data;
      console.log(`User sent message to room ${room}: ${message}`);
      io.to(room).emit('receive_message', { nickname, message });
    });

    socket.on('leave_room', (data) => {
      const { room } = data;
      handleUserLeaving(socket, room);
      socket.leave(room);
      console.log(`User left room ${room}`);
      socket.emit('left_room_confirm', { room: data.room });
    });

    if (socket.disconnected) {
      console.log('User disconnected');
      roomList.forEach((room) => {
        handleUserLeaving(socket, room.id);
        socket.leave(room.id);
      });
    }

    const handleUserLeaving = (socket: Socket, room: string) => {
      const targetRoomIndex = roomList.findIndex((e) => e.id === room);
      if (targetRoomIndex !== -1) {
        const targetRoom = roomList[targetRoomIndex];

        const updatedUsers = targetRoom.users.filter(
          (user) => user.id !== socket.id,
        );
        roomList[targetRoomIndex].users = updatedUsers;

        if (updatedUsers.length === 0) {
          roomList.splice(targetRoomIndex, 1);
        }
      }
    };
  });
};
