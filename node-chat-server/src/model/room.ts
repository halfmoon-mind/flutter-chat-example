import User from './user';

export default class Room {
  id: string;
  name: string;
  users: User[];

  constructor(id: string, name: string, users: User[]) {
    this.id = id;
    this.name = name;
    this.users = users;
  }

  addUser(user: User) {
    this.users.push(user);
  }

  removeUser(user: User) {
    const index = this.users.findIndex((e) => e.id === user.id);
    if (index !== -1) {
      this.users.splice(index, 1);
    }
  }
}
