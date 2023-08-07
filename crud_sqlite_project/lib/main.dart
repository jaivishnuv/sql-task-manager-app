import 'package:crud_sqlite_project/screens/addUser.dart';
import 'package:crud_sqlite_project/screens/editUser.dart';
import 'package:crud_sqlite_project/screens/viewUser.dart';
import 'package:crud_sqlite_project/services/userServices.dart';
import 'package:flutter/material.dart';

import 'model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _userService = UserService();

  Future<List<User>> getAllUserDetails() async {
    var users = await _userService.readAllUsers();
    return users
        .map((map) => User.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _deleteFormDialog(BuildContext context, int? userId) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Are You Sure to Delete",
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var result = await _userService.deleteUser(userId);
                if (result != null) {
                  Navigator.pop(context);
                  setState(() {
                    // Refresh the user list after deletion
                  });
                  _showSuccessSnackBar('User Detail Deleted Successfully');
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("SQLite CRUD"),
      ),
      body: FutureBuilder<List<User>>(
        future: getAllUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userList = snapshot.data ?? [];
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewUser(user: userList[index]),
                        ),
                      );
                    },
                    leading: const Icon(Icons.person),
                    title: Text(userList[index].name ?? ''),
                    subtitle: Text(userList[index].contact ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditUser(user: userList[index]),
                              ),
                            ).then((data) {
                              if (data != null) {
                                setState(() {
                                  // Refresh the user list after editing
                                });
                                _showSuccessSnackBar(
                                    'User Detail Updated Successfully');
                              }
                            });
                          },
                          icon: const Icon(Icons.edit, color: Colors.teal),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteFormDialog(context, userList[index].id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddUser()))
              .then((data) {
            if (data != null) {
              setState(() {
                // Refresh the user list after adding
              });
              _showSuccessSnackBar('User Detail Added Successfully');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
