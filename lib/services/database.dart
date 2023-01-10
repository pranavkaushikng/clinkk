import 'package:chumma/models/status.dart';
import 'package:chumma/models/Status2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chumma/models/notification.dart';
class DatabaseService
{
  final String? uid;
  DatabaseService({ this.uid});

  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference status2Collection =   FirebaseFirestore.instance.collection('Status');
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('Notification');
  final CollectionReference notificationReference = FirebaseFirestore.instance.collection('Notification');





  Future updateUserStatus(String description,String location,String typeOfMeet, String time,String uid) async
  {
    return await status2Collection.doc(uid).set({
      'name' : user?.displayName,
      'description' : description,
      'location' : location,
      'typeOfMeet': typeOfMeet,
      'time': time,
      'photoUrl': user?.photoURL,
      'uid': uid
    });
  }

  Future notifyStatusOwner(String Suid) async
  {
    return await notificationCollection.doc(Suid).collection('notifications').doc().set({
      'Name': user?.displayName
    });
  }




  //status list from snapshot
  List<Status2> _status2ListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Status2(
          name: doc.get('name') ?? 'user',
          location: doc.get('location') ?? 'bms',
          description: doc.get('description') ?? 'nothing',
          typeOfMeet: doc.get('typeOfMeet') ?? 'normal',
          time: doc.get('time') ?? '',
          photoUrl: doc.get('photoUrl') ?? '',
          uid: doc.get('uid')
      );
    }).toList();
  }

  //List<Notification> _notificationListFromSnapShot(){
    // notificationCollection.doc(user?.uid).collection('notifications').get();




  Stream<List<Status2>> get status2
  {
    return status2Collection.snapshots().map(_status2ListFromSnapShot);
  }



}

