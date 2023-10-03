import { Request, Response } from 'express';
import { roomList } from '.';
import { generateRandomString } from './utils';
import Room from './model/room';

/**
 * 룸 리스트 정보 반환
 * @param req
 * @param res
 */
export const getRoomsInfo = async (req: Request, res: Response) => {
  if (roomList.length === 0) {
    res.send({ rooms: [] });
    return;
  }
  const roomsArray = roomList.map((e) => {
    return {
      id: e.id,
      name: e.name,
      count: e.users.length,
    };
  });

  res.send({ rooms: roomsArray });
};

/**
 * 룸 생성
 * @param req
 * @param res
 */
export const createRoom = async (req: Request, res: Response) => {
  const { name } = req.body;

  if (name === undefined) {
    res.send({ error: 'Room name is undefined' });
    return;
  }

  let room: string = '';

  while (true) {
    room = generateRandomString(10);

    if (!roomList.some((e) => e.name === room)) {
      break;
    }
  }
  const newRoom = new Room(room, name, []);
  roomList.push(newRoom);
  res.send({
    id: newRoom.id,
    name: newRoom.name,
    count: newRoom.users.length,
  });
};

/**
 * 룸 입장
 * @param req
 * @param res
 */
export const joinRoom = async (req: Request, res: Response) => {
  const { nickname, roomCode } = req.body;
  const targetRoom = roomList.find((e) => e.id === roomCode);

  if (!targetRoom) {
    res.send({ error: 'Room not found' });
    return;
  }

  targetRoom.users.push(nickname);
  console.log(targetRoom);
  res.send(targetRoom);
};

/**
 * 룸 퇴장
 * @param req
 * @param res
 */
export const leaveRoom = async (req: Request, res: Response) => {
  const { userName, room } = req.body;
  const targetRoom = roomList.find((e) => e.name === room);

  if (!targetRoom) {
    res.send({ error: 'Room not found' });
    return;
  }

  targetRoom.users = targetRoom.users.filter((e) => e !== userName);
  res.send(targetRoom);
};
