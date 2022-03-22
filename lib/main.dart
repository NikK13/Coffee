import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/appnavigator.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/ui/general/home.dart';
import 'package:coffee/ui/general/onboard.dart';
import 'package:coffee/ui/provider/prefsprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalizations.loadLanguages();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferenceProvider()),
      ],
      child: Application(),
    ),
  );
}

class Application extends StatelessWidget {
  Application({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final HeroController _heroController = HeroController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (ctx, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          onGenerateRoute: (_) => null,
          locale: provider.preferences.locale,
          localizationsDelegates: App.delegates,
          supportedLocales: App.supportedLocales,
          themeMode: App.getThemeMode(provider.currentTheme ?? "system"),
          theme: App.themeLight,
          darkTheme: App.themeDark,
          builder: (context, child){
            return provider.isFirst != null ? AppNavigator(
              navigatorKey: _navigatorKey,
              initialPages: const [
                MaterialPage(child: InitializePage())
              ],
              observers: [_heroController],
            ) : const Scaffold(
              body: Center(
                child: Text(
                  "Loading..."
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class InitializePage extends StatelessWidget {
  const InitializePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    if(provider.isFirst!){
      return OnBoard(preferences: provider.preferences);
    }
    return const HomePage();
  }
}

