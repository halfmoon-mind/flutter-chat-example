import { Request, Response } from 'express';
import { roomList } from '.';
import { generateRandomString } from './utils';

/**
 * 룸 리스트 정보 반환
 * @param req
 * @param res
 */
export const getRoomsInfo = async (req: Request, res: Response) => {
  if (roomList.size === 0) {
    res.send({ rooms: [] });
    return;
  }
  const roomsArray = Array.from(roomList.entries()).map(
    ([roomCode, memberCount]) => {
      return { roomCode, memberCount };
    },
  );
  res.send({ rooms: roomsArray });
};

/**
 * 룸 생성
 * @param req
 * @param res
 */
export const createRoom = async (req: Request, res: Response) => {
  let room: string = '';

  while (true) {
    room = generateRandomString(10);
    if (!roomList.has(room)) break;
  }

  roomList.set(room, 1);
  res.send(room);
};
