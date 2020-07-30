import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class ControllerService {

  final FirebaseDatabase database = FirebaseDatabase.instance ;


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

  Future getStatusOnce(String directory) async {
    Completer completer = new Completer();

    FirebaseDatabase.instance
        .reference()
        .child(directory)
        .once()
        .then((DataSnapshot snapshot) {
      completer.complete(snapshot.value);
    });

    return completer.future;
  }


  Future<void> updateItem(String directory ,int status,double level)async{
     await database.reference().child(directory).update({
      'level': level.toInt(),
      'run': status,
    });
  }
 
}