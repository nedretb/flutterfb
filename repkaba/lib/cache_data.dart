import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheData extends FlutterSecureStorage {

  final storage = new FlutterSecureStorage();
  late final email;
  late final pw;

  Future readData() async {
    var link = await storage.read(key: 'link');
    // print(email);
    // print(pw);
    return ';o;o';
  }

  void writeData(link) async {
    await storage.write(key: 'link', value: link);
  }

  Future<void> deleteData() async {
    await storage.deleteAll();
  }

}