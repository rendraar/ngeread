import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Create User
  Future<void> createUser() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Optionally, you can add the user to Firestore for additional data storage
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text,
        'password': passwordController.text,
        // You can add more fields here if needed, like name, etc.
      });

      // Show success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User Created Successfully')),
      );
    } catch (e) {
      // Show error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Update User
  Future<void> updateUser() async {
    try {
      User? user = _auth.currentUser;
      await user!.updateEmail(emailController.text);
      await user.updatePassword(passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User Updated Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Delete User
  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      await user!.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User Deleted Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Get Current User
  Future<void> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User: ${user.email}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email and Password input fields only
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Buttons to create, update, and delete users
            ElevatedButton(
              onPressed: createUser,
              child: Text('Create User'),
            ),
            ElevatedButton(
              onPressed: updateUser,
              child: Text('Update User'),
            ),
            ElevatedButton(
              onPressed: deleteUser,
              child: Text('Delete User'),
            ),
            ElevatedButton(
              onPressed: getCurrentUser,
              child: Text('Get Current User'),
            ),
            SizedBox(height: 20),
            // Display the list of users in real-time using StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(), // Listen to Firestore changes
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found.'));
                  }

                  // Fetch users from Firestore
                  var usersList = snapshot.data!.docs.map((doc) {
                    return {
                      'uid': doc.id,
                      'email': doc['email'],
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      final user = usersList[index];
                      return ListTile(
                        title: Text(user['email']),
                        subtitle: Text(user['uid']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
