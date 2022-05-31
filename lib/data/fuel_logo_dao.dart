import 'package:firebase_database/firebase_database.dart';
import 'fuel_log.dart';

class MessageDao {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('fuel_log');

  void saveMessage(FuelLog message) {
    _messagesRef.push().set(message.toJson());
    _messagesRef.child("profile").remove();
  }

  Query getMessageQuery() {
    return _messagesRef;
  }
}
