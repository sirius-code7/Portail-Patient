// lib/main.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:portail_patient/screens/home_screen.dart';
import 'package:portail_patient/screens/rendezvous_screen.dart';
import 'package:portail_patient/screens/dossier_screen.dart';
import 'package:portail_patient/screens/recommendations_screen.dart';
import 'package:portail_patient/services/data_loader.dart';

// ca configure comment on navigue entre les pages de l'app
final GoRouter _router = GoRouter(
  initialLocation: '/', // on commence par la page d'accueil
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(
            navigationShell:
                navigationShell); // notre barre de navigation en bas
      },
      branches: [
        // la branche pour la page d'accueil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  const HomeScreen(), // la page d'accueil
            ),
          ],
        ),
        // la branche pour la page des rendez-vous
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/rendez-vous',
              builder: (context, state) =>
                  const RendezvousScreen(), // la page des rendez-vous
            ),
          ],
        ),
        // la branche pour la page du dossier
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dossier',
              builder: (context, state) =>
                  const DossierScreen(), // la page du dossier
            ),
          ],
        ),
        // la branche pour la page des recommendations
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recommendations',
              builder: (context, state) =>
                  const RecommendationsScreen(), // la page des recommendations
            ),
          ],
        ),
      ],
    ),
  ],
);

// le point de départ de notre application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'fr_FR', null); // pour que les dates soient bien en français

  runApp(
    MultiProvider(
      // pour partage des donnée comme le data loader dans toute l'app
      providers: [
        Provider(
            create: (_) =>
                DataLoader()), // on met notre chargeur de données à dispo
      ],
      child: const MyApp(), // on lance
    ),
  );
}

// c'est notre application principale
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, // on utilise notre configuration de navigation
      title: 'Portail Patient', // le titre de l'app
      debugShowCheckedModeBanner: false, // pour enlever le bandeau "debug"
      localizationsDelegates: const [
        // pour les traductions et les formats locaux
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // on supporte le français de france
      ],
      theme: ThemeData(
        // le thème visuel de l'app
        primaryColor: const Color(0xFF64B5F6), // notre couleur bleue principale
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: const Color(0xFF4DB6AC), // notre couleur verte d'eau
        ).copyWith(
          secondary: const Color(0xFF4DB6AC), // la couleur secondaire
          surface: Colors.grey[50], // couleur de surface
        ),
        scaffoldBackgroundColor: Colors.grey[50], // le fond des écrans
        cardTheme: CardTheme(
          // le style des cartes
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // bords arrondis
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        appBarTheme: const AppBarTheme(
          // le style de la barre du haut
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          // le style des textes
          titleLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          headlineMedium: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }
}

// ce widget gere la barre de navigation en bas de l'écran
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNavBar'));

  final StatefulNavigationShell
      navigationShell; // le controleur de la navigation

  // quand on clique sur un onglet de la barre de navigation
  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      // on change de branche (de page)
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // le contenu de la page actuelle
      bottomNavigationBar: BottomNavigationBar(
        // la barre de navigation du bas
        currentIndex:
            navigationShell.currentIndex, // l'onglet actuellement sélectionn
        onTap: (index) => _onTap(context, index), // ce qui se passe au clic
        type: BottomNavigationBarType.fixed, // les onglets ont une taille fixe
        backgroundColor: Colors.white, // fond blanc
        elevation: 10, // une petite ombre
        selectedFontSize: 12, // taille du texte de l'onglet sélectionne
        unselectedFontSize: 0, // on cache le texte des onglets non sélectionne
        selectedItemColor:
            const Color(0xFF64B5F6), // couleur de l'icône sélectionnée
        unselectedItemColor:
            Colors.grey[400], // couleur des icônes non sélectionnées

        items: [
          // les différents onglets de la barre de navigation
          _buildNavBarItem(0, Icons.home, 'Accueil'),
          _buildNavBarItem(1, Icons.calendar_today, 'Rendez-vous'),
          _buildNavBarItem(2, Icons.folder_open, 'Dossier'),
          _buildNavBarItem(3, Icons.lightbulb_outline, 'Recommandations'),
        ],
      ),
    );
  }

  // une petite fonction pour créer chaque onglet de la barre de navigation
  BottomNavigationBarItem _buildNavBarItem(
      int index, IconData iconData, String label) {
    final bool isSelected = navigationShell.currentIndex ==
        index; // on vérifie si cet onglet est sélectionné
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8), // un peu d'espace autour de l'icône
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(
                    0xFF64B5F6), // fond bleu pour l'icône sélectionnée
                borderRadius: BorderRadius.circular(12), // bords arrondis
              )
            : null, // pas de décoration si non sélectionné
        child: Icon(
          iconData, // l'icône
          color: isSelected
              ? Colors.white // icône blanche si sélectionnée
              : Colors.grey[400], // icône grise si non sélectionnée
          size: 24, // taille de l'icône
        ),
      ),
      label: isSelected
          ? label
          : '', // on affiche le texte seulement si l'onglet est sélectionné
    );
  }
}
