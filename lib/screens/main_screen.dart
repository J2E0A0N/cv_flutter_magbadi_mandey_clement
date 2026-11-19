import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'cv_screen.dart';
import 'family_screen.dart';
import 'contact_screen.dart';
import 'login_screen.dart';

/// Écran conteneur principal après connexion.
///
/// Gère la navigation entre :
/// - Onglet 0 : Mon CV Complet
/// - Onglet 1 : Ma Famille
/// - Onglet 2 : Mes Coordonnées / Contact
///
/// Intègre une NavigationBar en bas et un Navigation Drawer latéral complet.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    CvScreen(),
    FamilyScreen(),
    ContactScreen(),
  ];

  final List<String> _titles = const [
    'Mon CV Complet',
    'Ma Famille',
    'Mes Coordonnées',
  ];

  /// Affiche une boîte de dialogue de confirmation avant la déconnexion
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Déconnexion'),
          ],
        ),
        content: const Text('Souhaitez-vous vraiment vous déconnecter de votre session ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              Navigator.pop(context); // Fermer le dialogue
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // En-tête personnalisé avec photo réelle de Clément
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.secondaryColor,
                        child: const Center(
                          child: Text(
                            'MC',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              accountName: const Text(
                'MAGBADI MANDEY CLEMENT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('ETUDIANT • Licence Télécoms & Réseaux'),
                  SizedBox(height: 2),
                  Text(
                    'clementmandey611@gmail.com',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Navigation items du Drawer
            ListTile(
              leading: Icon(
                Icons.person_rounded,
                color: _currentIndex == 0 ? AppTheme.primaryColor : AppTheme.textMuted,
              ),
              title: const Text('Mon CV Complet'),
              selected: _currentIndex == 0,
              selectedTileColor: AppTheme.primaryColor.withAlpha(20),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.people_alt_rounded,
                color: _currentIndex == 1 ? AppTheme.primaryColor : AppTheme.textMuted,
              ),
              title: const Text('Ma Famille'),
              selected: _currentIndex == 1,
              selectedTileColor: AppTheme.primaryColor.withAlpha(20),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.contact_phone_rounded,
                color: _currentIndex == 2 ? AppTheme.primaryColor : AppTheme.textMuted,
              ),
              title: const Text('Mes Coordonnées & Contact'),
              selected: _currentIndex == 2,
              selectedTileColor: AppTheme.primaryColor.withAlpha(20),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),

            const Divider(),

            const Spacer(),

            // Option Déconnexion en pied de Drawer
            ListTile(
              leading: const Icon(Icons.exit_to_app_rounded, color: Colors.redAccent),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmLogout();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primaryColor.withAlpha(35),
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryColor),
            label: 'Mon CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_alt_rounded, color: AppTheme.primaryColor),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone_rounded, color: AppTheme.primaryColor),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}
