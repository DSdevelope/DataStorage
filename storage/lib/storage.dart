import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _getAppDocDir async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getFile async {
    final path = await _getAppDocDir;
    return File('$path/login.txt');
  }

  Future<String> readLogin() async {
    try {
      final file = await _getFile;
      final login = await file.readAsString();
      return login;

    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<File> writeToFile(String text) async {
    final file = await _getFile;
    return file.writeAsString(text);
  }
}