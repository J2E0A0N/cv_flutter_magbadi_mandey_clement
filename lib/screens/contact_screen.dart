import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String emailAddress = 'clementmandey611@gmail.com';
  static const String phoneNumber = '0837378179';
  static const String internationalPhone = '+243837378179';
  static const String whatsAppNumber = '243837378179';
  static const String githubUrl = 'https://github.com/clementmandey';
  static const String linkedinUrl = 'https://www.linkedin.com/in/clement-mandey';

  Future<void> _launch(BuildContext context, String urlString, {String? copyFallback}) async {
    final Uri uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Impossible d\'ouvrir l\'application associée';
      }
    } catch (e) {
      if (context.mounted) {
        if (copyFallback != null) {
          Clipboard.setData(ClipboardData(text: copyFallback));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Impossible d\'ouvrir directement. "$copyFallback" a été copié dans le presse-papier.'),
              backgroundColor: Colors.orange.shade800,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur : $e'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copié dans le presse-papier !'),
        backgroundColor: AppTheme.secondaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte principale de présentation
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.contact_mail_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Restons en Contact',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Toujours disponible pour des opportunités professionnelles, collaborations ou échanges techniques.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withAlpha(220),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              child: Text(
                'Coordonnées Directes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ),

            // 1. E-mail
            _buildContactCard(
              context: context,
              icon: Icons.email_rounded,
              iconColor: const Color(0xFFEA4335),
              title: 'Adresse E-mail',
              subtitle: emailAddress,
              badgeText: 'Envoyer un mail',
              onTap: () => _launch(
                context,
                'mailto:$emailAddress?subject=Contact%20depuis%20l\'application%20CV',
                copyFallback: emailAddress,
              ),
              onCopy: () => _copyToClipboard(context, emailAddress, 'E-mail'),
            ),

            const SizedBox(height: 12),

            // 2. Appel Téléphonique
            _buildContactCard(
              context: context,
              icon: Icons.phone_forwarded_rounded,
              iconColor: const Color(0xFF16A34A),
              title: 'Appel Téléphonique',
              subtitle: phoneNumber,
              badgeText: 'Composer l\'appel',
              onTap: () => _launch(
                context,
                'tel:$phoneNumber',
                copyFallback: phoneNumber,
              ),
              onCopy: () => _copyToClipboard(context, phoneNumber, 'Numéro'),
            ),

            const SizedBox(height: 12),

            // 3. WhatsApp
            _buildContactCard(
              context: context,
              customIcon: const FaIcon(
                FontAwesomeIcons.whatsapp,
                color: Color(0xFF25D366),
                size: 26,
              ),
              icon: Icons.chat_rounded,
              iconColor: const Color(0xFF25D366),
              title: 'WhatsApp Direct',
              subtitle: '$phoneNumber (Discuter en direct)',
              badgeText: 'Ouvrir WhatsApp',
              onTap: () => _launch(
                context,
                'https://wa.me/$whatsAppNumber?text=Bonjour%20Magbadi%20Clement%2C%20je%20vous%20contacte%20suite%20%C3%A0%20votre%20CV.',
                copyFallback: phoneNumber,
              ),
              onCopy: () => _copyToClipboard(context, phoneNumber, 'WhatsApp'),
            ),

            const SizedBox(height: 12),

            // 4. GitHub
            _buildContactCard(
              context: context,
              customIcon: const FaIcon(
                FontAwesomeIcons.github,
                color: Color(0xFF24292F),
                size: 26,
              ),
              icon: Icons.code_rounded,
              iconColor: const Color(0xFF24292F),
              title: 'GitHub Profil',
              subtitle: 'github.com/clementmandey',
              badgeText: 'Voir les dépôts',
              onTap: () => _launch(
                context,
                githubUrl,
                copyFallback: githubUrl,
              ),
              onCopy: () => _copyToClipboard(context, githubUrl, 'Lien GitHub'),
            ),

            const SizedBox(height: 12),

            // 5. LinkedIn
            _buildContactCard(
              context: context,
              customIcon: const FaIcon(
                FontAwesomeIcons.linkedin,
                color: Color(0xFF0A66C2),
                size: 26,
              ),
              icon: Icons.link_rounded,
              iconColor: const Color(0xFF0A66C2),
              title: 'LinkedIn',
              subtitle: 'linkedin.com/in/clement-mandey',
              badgeText: 'Réseau pro',
              onTap: () => _launch(
                context,
                linkedinUrl,
                copyFallback: linkedinUrl,
              ),
              onCopy: () => _copyToClipboard(context, linkedinUrl, 'Lien LinkedIn'),
            ),

            const SizedBox(height: 25),

            // Localisation & disponibilité
            Card(
              color: Colors.blueGrey.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blueGrey.shade100),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.blueGrey, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Localisation',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Kinshasa, République Démocratique du Congo (RDC)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
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
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    IconData? icon,
    Widget? customIcon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badgeText,
    required VoidCallback onTap,
    required VoidCallback onCopy,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: customIcon ?? Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copier',
                icon: const Icon(Icons.copy_rounded, size: 18, color: AppTheme.textMuted),
                onPressed: onCopy,
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
