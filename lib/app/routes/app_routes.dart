import 'package:flutter/material.dart';
import 'route_names.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/notes/notes_page.dart';
import '../../presentation/pages/notes/add_note_page.dart';
import '../../presentation/pages/search/search_page.dart';
import '../../presentation/pages/settings/settings_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      
      case RouteNames.notes:
        return MaterialPageRoute(
          builder: (_) => const NotesPage(),
          settings: settings,
        );
      
      case RouteNames.addNote:
        return MaterialPageRoute(
          builder: (_) => const AddNotePage(),
          settings: settings,
        );
      
      case RouteNames.search:
        return MaterialPageRoute(
          builder: (_) => const SearchPage(),
          settings: settings,
        );
      
      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('找不到頁面: ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  static Map<String, WidgetBuilder> get routes {
    return {
      RouteNames.login: (context) => const LoginPage(),
      RouteNames.home: (context) => const HomePage(),
      RouteNames.notes: (context) => const NotesPage(),
      RouteNames.addNote: (context) => const AddNotePage(),
      RouteNames.search: (context) => const SearchPage(),
      RouteNames.settings: (context) => const SettingsPage(),
    };
  }
}
