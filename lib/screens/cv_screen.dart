import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Écran principal présentant le Curriculum Vitae complet de Magbadi Mandey Clement.
///
/// Structuré de manière modulaire :
/// 1. En-tête profil (photo réelle, nom, statut étudiant, résumé)
/// 2. Formation académique (Licence Réseau Système & Télécom)
/// 3. Expériences (Stage chez Global Technology, Projet Application de gestion d'école)
/// 4. Compétences techniques (Flutter, Web, Python) avec jauges visuelles
/// 5. Compétences linguistiques (Français, Lingala, Anglais)
/// 6. Centres d'intérêt (Football, Réseau, Lecture)
class CvScreen extends StatelessWidget {
  const CvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // En-tête avec dégradé et photo réelle de profil
            _buildProfileHeader(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Formation Académique
                  _buildSectionHeader(
                    title: 'Formation Académique',
                    icon: Icons.school_rounded,
                    accentColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  _buildEducationSection(),

                  const SizedBox(height: 24),

                  // 2. Expériences & Projets
                  _buildSectionHeader(
                    title: 'Expériences & Réalisations',
                    icon: Icons.work_history_rounded,
                    accentColor: AppTheme.secondaryColor,
                  ),
                  const SizedBox(height: 10),
                  _buildExperienceSection(),

                  const SizedBox(height: 24),

                  // 3. Compétences Techniques
                  _buildSectionHeader(
                    title: 'Compétences Techniques',
                    icon: Icons.terminal_rounded,
                    accentColor: AppTheme.primaryLight,
                  ),
                  const SizedBox(height: 10),
                  _buildTechnicalSkillsSection(),

                  const SizedBox(height: 24),

                  // 4. Compétences Linguistiques
                  _buildSectionHeader(
                    title: 'Compétences Linguistiques',
                    icon: Icons.translate_rounded,
                    accentColor: const Color(0xFF0284C7),
                  ),
                  const SizedBox(height: 10),
                  _buildLanguageSkillsSection(),

                  const SizedBox(height: 24),

                  // 5. Centres d'intérêt
                  _buildSectionHeader(
                    title: 'Centres d’intérêt',
                    icon: Icons.favorite_rounded,
                    accentColor: const Color(0xFFE11D48),
                  ),
                  const SizedBox(height: 10),
                  _buildInterestsSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit la bannière supérieure avec dégradé et la photo de Clément
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            Color(0xFF0F172A),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        children: [
          // Photo de profil réelle avec cadre circulaire
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    // Si l'image locale venait à manquer, on assure un fallback gracieux
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        color: AppTheme.secondaryColor,
                        alignment: Alignment.center,
                        child: const Text(
                          'MC',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Badge de vérification / statut actif
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nom complet
          const Text(
            'MAGBADI MANDEY CLEMENT',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Titre / Profil : ETUDIANT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(35),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(70)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.badge_rounded, size: 16, color: Colors.amberAccent),
                SizedBox(width: 8),
                Text(
                  'ETUDIANT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Résumé professionnel
          Text(
            'Passionné par l\'ingénierie des réseaux, les architectures télécoms et le développement d\'applications mobiles modernes.',
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.white.withAlpha(220),
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// En-tête générique réutilisable pour chaque section
  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color accentColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  /// Carte présentant le diplôme et la formation académique
  Widget _buildEducationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_outlined,
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LICENCE EN RESEAU SYSTEME ET TELECOMUNICATION',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Formation approfondie couvrant le routage & commutation, la virtualisation, l\'administration système Linux/Windows, et les infrastructures réseaux modernes.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.textMuted,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section présentant le stage et le projet applicatif
  Widget _buildExperienceSection() {
    return Column(
      children: [
        // 1. Stage professionnel : Global Technology
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business_center_rounded,
                    color: AppTheme.secondaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Global Technology',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text('Stage', style: TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: AppTheme.secondaryColor,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Stagiaire en Réseau et Systèmes',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Maintenance opérationnelle des équipements réseaux, configuration des switchs & routeurs, et support technique aux utilisateurs.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 2. Projet : Application de gestion d'une école
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment_rounded,
                    color: Colors.indigo,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Application de gestion d\'une école',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text('Projet', style: TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: Colors.indigo,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Développement d\'une solution logicielle complète',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Conception et implémentation d\'un logiciel permettant la gestion des inscriptions scolaires, le suivi des présences, l\'édition des bulletins et le suivi des frais.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Barres de maîtrise pour les compétences techniques
  Widget _buildTechnicalSkillsSection() {
    final skills = [
      {
        'title': 'developer FLUTTER',
        'level': 0.88,
        'icon': Icons.phone_android_rounded,
        'color': const Color(0xFF0284C7),
      },
      {
        'title': 'Développement Web',
        'level': 0.82,
        'icon': Icons.language_rounded,
        'color': const Color(0xFFEA580C),
      },
      {
        'title': 'PYTHON',
        'level': 0.78,
        'icon': Icons.terminal_rounded,
        'color': const Color(0xFF0D9488),
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: skills.map((skill) {
            final color = skill['color'] as Color;
            final level = skill['level'] as double;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(skill['icon'] as IconData, size: 20, color: color),
                      const SizedBox(width: 10),
                      Text(
                        skill['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(level * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: level,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Liste des langues parlées avec drapeaux et niveaux
  Widget _buildLanguageSkillsSection() {
    final languages = [
      {
        'name': 'Français',
        'description': 'Langue d\'enseignement & usage professionnel courant',
        'level': 'Maîtrise complète',
        'flag': '🇫🇷',
      },
      {
        'name': 'Lingala',
        'description': 'Langue maternelle & communication quotidienne',
        'level': 'Courant (Natif)',
        'flag': '🇨🇩',
      },
      {
        'name': 'English',
        'description': 'Documentation technique, programmation & échanges',
        'level': 'Intermédiaire (B2)',
        'flag': '🇬🇧',
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: languages.map((lang) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  lang['flag']!,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              title: Text(
                lang['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppTheme.textDark,
                ),
              ),
              subtitle: Text(
                lang['description']!,
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lang['level']!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Section des centres d'intérêt
  Widget _buildInterestsSection() {
    final interests = [
      {
        'title': 'Football',
        'description': 'Esprit d\'équipe, stratégie et persévérance',
        'icon': Icons.sports_soccer_rounded,
        'color': Colors.green.shade600,
      },
      {
        'title': 'Le Réseau',
        'description': 'Veille technologique, protocoles, IoT & cybersécurité',
        'icon': Icons.hub_rounded,
        'color': AppTheme.primaryLight,
      },
      {
        'title': 'Lire',
        'description': 'Livres scientifiques, informatique & développement personnel',
        'icon': Icons.menu_book_rounded,
        'color': Colors.deepOrange.shade600,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: interests.map((item) {
            final color = item['color'] as Color;
            return Expanded(
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] as String,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppTheme.textMuted,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
