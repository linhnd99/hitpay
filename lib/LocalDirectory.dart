import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDirectory {

  static Future<String> CreateFolder (String nameFolder) async {
    try
    {
      Directory directory = await getApplicationDocumentsDirectory() ;
      directory = new Directory(directory.path+"/"+nameFolder);
      bool isExists = await directory.exists();
      if (isExists)
      {
        return "exists";
      }
      directory.create(recursive: true);
      return "create";
    }
    catch (e)
    {
      print(e);
    }
  }

  static Future<bool> CheckExistsPath(String nameFolder) async
  {
    Directory directory = await getApplicationDocumentsDirectory() ;
    directory = new Directory(directory.path+"/"+nameFolder);
    return await directory.exists();
  }

  static Future<String> GetPath (String path) async{
    Directory directory = await getApplicationDocumentsDirectory() ;
    directory = new Directory(directory.path+"/"+path);
    return directory.path;
  }

  static Future<String> ReadFile(String nameFile) async
  {
    try{
      Directory directory  = await getApplicationDocumentsDirectory();
      directory = new Directory(directory.path+"/"+nameFile);
      bool isExists = await directory.exists();
      if (!isExists) return null;
      File file = new File(directory.path);
      return file.readAsString();
    }
    catch (e)
    {
      return null;
    }
  }

  static Future<bool> WriteFile(String nameFile, String content) async {
    try{
      Directory directory  = await getApplicationDocumentsDirectory();
      directory = new Directory(directory.path+"/"+nameFile);
      File file = new File(directory.path);
      file.writeAsString(content);
      return true;
    }
    catch (e)
    {
      return false;
    }
  }
}