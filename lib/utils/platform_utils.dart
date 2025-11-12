import 'package:flutter/foundation.dart';

bool isWindowsPlatform() => !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

bool isMobilePlatform() => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);