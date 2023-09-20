// import express from 'express';
// import http from 'http';
// import { Server } from 'socket.io';

// const app = express();
// const server = http.createServer(app);
// const io = new Server(server);

// io.on('connection', (socket) => {
//   console.log('User connected');

//   socket.on('set_username', (username) => {
//     io.emit('set_username', `${username} has joined the chat`);
//     console.log(`${username} has connected`);
//   });

//   socket.on('send_message', (message: string) => {
//     io.emit('receive_message', message);
//     console.log(message);
//   });

//   socket.on('disconnect', () => {
//     console.log('User disconnected');
//   });
// });

// server.listen(3000, () => {
//   console.log('Server is running on port 3000');
// });
import express from 'express';
import http from 'http';
import { Server } from 'socket.io';

const app = express();
const server = http.createServer(app);
const io = new Server(server);

app.get('/:room', (req, res) => {
  res.send(`This is room ${req.params.room}`);
});

io.on('connection', (socket) => {
  console.log('User connected');

  socket.on('join_room', (room) => {
    socket.join(room);
    console.log(`User joined room ${room}`);
  });

  socket.on('send_message', (data) => {
    const { room, message } = data;
    io.to(room).emit('receive_message', message); // Send message only to users in the same room
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

server.listen(3000, () => {
  console.log('Server is running on port 3000');
});
