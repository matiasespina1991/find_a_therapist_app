import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/providers/auth_provider.dart';
import 'package:findatherapistapp/providers/locale_provider.dart';
import 'package:findatherapistapp/providers/theme_provider.dart';

import '../services/connectivity_service.dart';

final authProvider = ChangeNotifierProvider((ref) => AuthorizationProvider());
final themeProvider = ChangeNotifierProvider((ref) => ThemeProvider());
final localeProvider = ChangeNotifierProvider((ref) => LocaleProvider());
final connectivityProvider =
    ChangeNotifierProvider((ref) => ConnectivityService());

final navigationStateProvider = StateProvider<bool>((ref) => false);
