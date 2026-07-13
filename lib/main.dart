import 'package:flutter/material.dart';
import 'package:dosador_concreto/routes.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:dosador_concreto/my_classes.dart';
import 'package:dosador_concreto/lists.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter('dosador_concreto');

  Hive.registerAdapter(MixAdapter());
  Hive.registerAdapter(CimAdapter());
  Hive.registerAdapter(MixsAdapter());
  Hive.registerAdapter(DataAdapter());
  Hive.registerAdapter(UnitAdapter());
  Hive.registerAdapter(UnitsAdapter());

  await Hive.openBox('boxDados');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('boxDados');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, box, child) {
        final myConfigs = List<String?>.from(
          box.get('settings', defaultValue: mySettings),
        );

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Dosador Concreto',
          theme: ThemeData(
            useMaterial3: true,
            menuTheme: MenuThemeData(
              style: MenuStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                ),
              ),
            ),
            menuButtonTheme: MenuButtonThemeData(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            listTileTheme: ListTileThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: switch (myConfigs[0]) {
                'azul' => const Color(0xFF00639B),
                'roxo' => const Color(0xFF6750A4),
                'laranja' => const Color(0xFFB35C00),
                'verde' => const Color(0xFF006A6A),
                _ => const Color(0xFF00639B),
              },
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            menuTheme: MenuThemeData(
              style: MenuStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                ),
              ),
            ),
            menuButtonTheme: MenuButtonThemeData(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            listTileTheme: ListTileThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: switch (myConfigs[0]) {
                'azul' => const Color(0xFF00639B),
                'roxo' => const Color(0xFF6750A4),
                'laranja' => const Color(0xFFB35C00),
                'verde' => const Color(0xFF006A6A),
                _ => const Color(0xFF00639B),
              },
              brightness: Brightness.dark,
            ),
          ),
          themeMode: switch (myConfigs[1]) {
            'dark' => ThemeMode.dark,
            'light' => ThemeMode.light,
            _ => ThemeMode.system,
          },
          routerDelegate: routes.routerDelegate,
          routeInformationParser: routes.routeInformationParser,
          routeInformationProvider: routes.routeInformationProvider,
        );
      },
    );
  }
}
