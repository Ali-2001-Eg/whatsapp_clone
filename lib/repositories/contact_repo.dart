import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/chat/chat_screen.dart';
import 'package:whatsapp_clone/shared/utils/functions.dart';

class ContactRepo {
  final FirebaseFirestore firestore;

  ContactRepo(this.firestore);

  Future<List<Contact>> get getContacts async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var doc in userCollection.docs) {
        var userData = UserModel.fromJson(doc.data());
        String selectedPhoneNum =
            '${selectedContact.phones[0].number.replaceAll(' ', '')}';
        if (kDebugMode) {
          print(selectedPhoneNum);
        }
        if (kDebugMode) {
          print(userData.phoneNumber);
        }
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'description': userData.description,
              'phoneNumber': userData.phoneNumber,
              'profilePic': userData.profilePic,
              'isOnline': userData.isOnline,
              'groupId': userData.groupId,
              'isGroupChat': false,
            },
          );
        }
        if (!isFound) {
          customSnackBar('This Number does not exist in the app.', context);
        }
      }
    } catch (e) {
      customSnackBar(e.toString(), context);
    }
  }
}

final selectContactRepoProvider = Provider(
  (ref) => ContactRepo(FirebaseFirestore.instance),
);