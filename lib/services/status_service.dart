import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class StatusService {

  static final FirebaseDatabase database = FirebaseDatabase.instance ;

  Future<StreamSubscription<Event>> getStatusStream(String directory , onData(Event event)) async {
    StreamSubscription<Event> subscription = database
        .reference()
        .child(directory)
        .onValue
        .listen((Event event) {
      onData(event);
    });

    return subscription;
  }

  Future<DataSnapshot> getStatusOnce(String directory) async {

    return database
        .reference()
        .child(directory)
        .once();

  }
 
}
