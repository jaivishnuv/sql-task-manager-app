import 'package:crud_sqlite_project/db_helper/repository.dart';

import '../model/user.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }
//Save user
  Future<int> saveUser(User user) async {
    return await _repository.insertData('users', user.userMap());
  }

//Read All User
  Future<List<Map<String, dynamic>>> readAllUsers() async {
    var userMaps = await _repository.readData('users');
    return userMaps; /////
  }

// Edit user
  Future<int> updateUser(User user) async {
    return await _repository.updateData('users', user.userMap());
  }

  Future<int> deleteUser(userId) async {
    return await _repository.deleteDataById('users', userId);
  }
}
