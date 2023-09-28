import User from './user';

export default class Room {
  name: string;
  users: User[];
  id: string;

  constructor(name: string, users: User[], id: string) {
    this.name = name;
    this.users = users;
    this.id = id;
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
