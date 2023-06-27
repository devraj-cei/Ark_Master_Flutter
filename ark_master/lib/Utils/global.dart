import 'package:ark_master/Utils/storage_service.dart';
import 'package:flutter/material.dart';

class Global {
  static late StorageServices services;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    services = await StorageServices().init();
  }
}
