import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  String _userFormFirebase(FirebaseUser user) {
    return user != null ? user.uid : null;
  }

  Stream<String> get user {
    return _auth
        .onAuthStateChanged 
        .map((FirebaseUser user) => _userFormFirebase(user));
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    }
    catch (e){
      throw e;
    }

  }

  Future signOUt() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return e;
    }
  }
}
