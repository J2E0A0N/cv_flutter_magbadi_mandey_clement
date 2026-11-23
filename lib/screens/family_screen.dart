import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'api_service_screen.dart';

/// Page présentant et gérant les membres de la famille via l'API.
///
/// Conserve le design original (Cercle Familial, bascule Liste / Grille,
/// palette AppTheme) tout en permettant l'ajout, la modification
/// et la suppression des membres en base de données.
class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  // Permet de basculer dynamiquement entre la vue Liste et la vue Grille
  bool _isGridView = false;

  // Données chargées depuis l'API
  List<dynamic> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerMembres();
  }

  /// Charge la liste des membres depuis l'API
  Future<void> _chargerMembres() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getMembres();
      if (!mounted) return;
      setState(() {
        _members = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Ouvre la boîte de dialogue d'ajout ou de modification d'un membre
  void _ouvrirFormulaireMembre({Map<String, dynamic>? membreExistant}) {
    final bool estModification = membreExistant != null;

    final nomController =
        TextEditingController(text: membreExistant?['nom']?.toString() ?? '');
    final postnomController = TextEditingController(
        text: membreExistant?['postnom']?.toString() ?? '');
    final prenomController = TextEditingController(
        text: membreExistant?['prenom']?.toString() ?? '');
    final lieuController = TextEditingController(
        text: membreExistant?['lieu_naissance']?.toString() ?? '');
    final dateController = TextEditingController(
        text: membreExistant?['date_naissance']?.toString() ?? '');
    final parenteController = TextEditingController(
        text: membreExistant?['parente']?.toString() ?? '');

    final ImagePicker picker = ImagePicker();
    XFile? imageChoisie;
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                estModification ? 'Modifier un membre' : 'Ajouter un membre',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom *',
                        prefixIcon: Icon(Icons.person_outline,
                            color: AppTheme.primaryLight),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: postnomController,
                      decoration: const InputDecoration(
                        labelText: 'Postnom *',
                        prefixIcon: Icon(Icons.badge_outlined,
                            color: AppTheme.primaryLight),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: prenomController,
                      decoration: const InputDecoration(
                        labelText: 'Prénom *',
                        prefixIcon: Icon(Icons.person_pin_outlined,
                            color: AppTheme.primaryLight),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lieuController,
                      decoration: const InputDecoration(
                        labelText: 'Lieu de naissance *',
                        prefixIcon: Icon(Icons.location_on_outlined,
                            color: AppTheme.primaryLight),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance (AAAA-MM-JJ) *',
                        prefixIcon: Icon(Icons.calendar_today_outlined,
                            color: AppTheme.primaryLight),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: parenteController,
                      decoration: const InputDecoration(
                        labelText: 'Lien de parenté (ex: Père, Mère) *',
                        prefixIcon: Icon(Icons.family_restroom_outlined,
                            color: AppTheme.primaryLight),
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isSaving
                          ? null
                          : () async {
                              final XFile? picked = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  imageChoisie = picked;
                                });
                              }
                            },
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(
                        imageChoisie == null
                            ? 'Ajouter une image'
                            : 'Changer l\'image',
                      ),
                    ),
                    if (imageChoisie != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imageChoisie!.path),
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      isSaving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          setDialogState(() => isSaving = true);

                          final payload = {
                            'nom': nomController.text.trim(),
                            'postnom': postnomController.text.trim(),
                            'prenom': prenomController.text.trim(),
                            'lieu_naissance': lieuController.text.trim(),
                            'date_naissance': dateController.text.trim(),
                            'parente': parenteController.text.trim(),
                          };

                          try {
                            final int? membreId = estModification
                                ? int.tryParse(membreExistant['id'].toString())
                                : null;

                            final Map<String, dynamic> response =
                                imageChoisie != null
                                    ? await ApiService.saveMembreMultipart(
                                        id: membreId,
                                        fields: payload,
                                        imagePath: imageChoisie!.path,
                                      )
                                    : (estModification
                                        ? await ApiService.updateMembreJson(
                                            membreId!,
                                            payload,
                                          )
                                        : await ApiService.createMembreJson(
                                            payload));

                            if (!mounted) return;

                            if (response['success'] == true) {
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    response['message']?.toString() ??
                                        (estModification
                                            ? 'Membre modifié'
                                            : 'Membre ajouté'),
                                  ),
                                  backgroundColor: AppTheme.secondaryColor,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              _chargerMembres();
                            } else {
                              setDialogState(() => isSaving = false);
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    response['message']?.toString() ??
                                        'Données invalides',
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            if (!mounted) return;
                            setDialogState(() => isSaving = false);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur : $e'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(estModification ? 'Enregistrer' : 'Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Supprime un membre via l'API
  Future<void> _supprimerMembre(int id) async {
    try {
      final response = await ApiService.deleteMembre(id);
      if (!mounted) return;

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message']?.toString() ?? 'Membre supprimé',
            ),
            backgroundColor: AppTheme.secondaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _chargerMembres();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message']?.toString() ?? 'Suppression impossible',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Demande confirmation avant la suppression d'un membre
  Future<void> _confirmerSuppression(int id, String nomMembre) async {
    final bool? confirme = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirmer la suppression',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          content: Text(
            'Voulez-vous vraiment supprimer "$nomMembre" de la famille ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirme == true) {
      await _supprimerMembre(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter un membre',
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _ouvrirFormulaireMembre(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Barre supérieure avec titre, bouton actualiser et bascule d'affichage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cercle Familial',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isLoading
                            ? 'Chargement des membres...'
                            : '${_members.length} membre(s) enregistré(s)',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bouton d'actualisation depuis la base de données
                IconButton(
                  tooltip: 'Actualiser',
                  icon: const Icon(Icons.refresh_rounded,
                      color: AppTheme.primaryColor),
                  onPressed: _chargerMembres,
                ),
                const SizedBox(width: 4),

                // Sélecteur de vue (Liste / Grille)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Affichage en Liste',
                        icon: Icon(
                          Icons.view_list_rounded,
                          color:
                              !_isGridView ? AppTheme.primaryColor : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isGridView = false;
                          });
                        },
                      ),
                      IconButton(
                        tooltip: 'Affichage en Grille',
                        icon: Icon(
                          Icons.grid_view_rounded,
                          color:
                              _isGridView ? AppTheme.primaryColor : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isGridView = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contenu principal : Chargement, Erreur, Vide, Liste ou Grille
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.cloud_off_rounded,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 10),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                onPressed: _chargerMembres,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _members.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.group_off_rounded,
                                    size: 52, color: Colors.grey.shade400),
                                const SizedBox(height: 10),
                                const Text(
                                  'Aucun membre enregistré.\nAppuyez sur + pour ajouter un membre.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _chargerMembres,
                            color: AppTheme.primaryColor,
                            child: _isGridView
                                ? _buildGridView()
                                : _buildListView(),
                          ),
          ),
        ],
      ),
    );
  }

  /// Vue en Liste avec cartes détaillées et boutons Modifier / Supprimer
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> member =
            Map<String, dynamic>.from(_members[index] as Map);

        final String nomComplet =
            '${member['nom'] ?? ''} ${member['postnom'] ?? ''} ${member['prenom'] ?? ''}'
                .trim();
        final String relation = member['parente']?.toString() ?? '';
        final String lieu = member['lieu_naissance']?.toString() ?? '';
        final String dateNaissance = member['date_naissance']?.toString() ?? '';
        final String? imageUrl = member['image_url']?.toString();

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar circulaire avec photo réseau ou initiales
                _buildAvatar(imageUrl, nomComplet, size: 70),
                const SizedBox(width: 14),

                // Informations textuelles du membre
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              nomComplet.isNotEmpty ? nomComplet : 'Sans nom',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          if (relation.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withAlpha(60),
                                ),
                              ),
                              child: Text(
                                relation,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              lieu.isNotEmpty ? 'Né(e) à $lieu' : 'Lieu non renseigné',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.cake_outlined,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              dateNaissance.isNotEmpty
                                  ? dateNaissance
                                  : 'Date non renseignée',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Boutons d'action Modifier et Supprimer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () =>
                                _ouvrirFormulaireMembre(membreExistant: member),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined,
                                      size: 17, color: AppTheme.primaryColor),
                                  SizedBox(width: 4),
                                  Text(
                                    'Modifier',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              final id =
                                  int.tryParse(member['id']?.toString() ?? '');
                              if (id != null) {
                                _confirmerSuppression(id, nomComplet);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 17, color: Colors.red),
                                  SizedBox(width: 4),
                                  Text(
                                    'Supprimer',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Vue en Grille 2 colonnes avec boutons Modifier / Supprimer
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> member =
            Map<String, dynamic>.from(_members[index] as Map);

        final String nomComplet =
            '${member['nom'] ?? ''} ${member['postnom'] ?? ''} ${member['prenom'] ?? ''}'
                .trim();
        final String relation = member['parente']?.toString() ?? '';
        final String lieu = member['lieu_naissance']?.toString() ?? '';
        final String dateNaissance = member['date_naissance']?.toString() ?? '';
        final String? imageUrl = member['image_url']?.toString();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvatar(imageUrl, nomComplet, size: 68),
                const SizedBox(height: 8),
                Text(
                  nomComplet.isNotEmpty ? nomComplet : 'Sans nom',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (relation.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      relation,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  lieu,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dateNaissance,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Modifier',
                      icon: const Icon(Icons.edit_outlined,
                          size: 18, color: AppTheme.primaryColor),
                      onPressed: () =>
                          _ouvrirFormulaireMembre(membreExistant: member),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Supprimer',
                      icon: const Icon(Icons.delete_outline,
                          size: 18, color: Colors.red),
                      onPressed: () {
                        final id =
                            int.tryParse(member['id']?.toString() ?? '');
                        if (id != null) {
                          _confirmerSuppression(id, nomComplet);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construit un avatar circulaire avec image réseau et initiales en secours
  Widget _buildAvatar(String? imageUrl, String name, {required double size}) {
    final initials = name
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0].toUpperCase())
        .take(2)
        .join();

    final bool hasImageUrl = imageUrl != null && imageUrl.isNotEmpty;

    Widget fallbackAvatar() {
      return Container(
        color: AppTheme.primaryColor,
        alignment: Alignment.center,
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.35,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: AppTheme.primaryLight.withAlpha(80), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: hasImageUrl
            ? Image.network(
                imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallbackAvatar(),
              )
            : fallbackAvatar(),
      ),
    );
  }
}