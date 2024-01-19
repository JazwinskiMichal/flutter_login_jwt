import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_jwt/features/authentication.dart';
import 'package:flutter_login_jwt/widgets/templates.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const Templates());
}
