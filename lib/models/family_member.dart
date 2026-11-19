/// Modèle représentant un membre de la famille de Clément.
///
/// Contient le nom, le lien de parenté, la profession,
/// une courte présentation et le chemin vers la photo locale.
class FamilyMember {
  final String name;
  final String relationship;
  final String profession;
  final String description;
  final String imagePath;

  const FamilyMember({
    required this.name,
    required this.relationship,
    required this.profession,
    required this.description,
    required this.imagePath,
  });
}

/// Liste des membres de la famille avec photos locales embarquées
final List<FamilyMember> sampleFamilyMembers = [
  const FamilyMember(
    name: 'Joseph Mandey',
    relationship: 'Père',
    profession: 'Ingénieur en Télécommunications',
    description: 'Passionné de technologie et mentor dévoué pour toute la famille.',
    imagePath: 'assets/images/family/father.jpg',
  ),
  const FamilyMember(
    name: 'Marie Magbadi',
    relationship: 'Mère',
    profession: 'Professeure & Entrepreneure',
    description: 'Pilier du foyer, toujours encourageante, bienveillante et inspirante.',
    imagePath: 'assets/images/family/mother.jpg',
  ),
  const FamilyMember(
    name: 'Patrick Mandey',
    relationship: 'Grand Frère',
    profession: 'Administrateur Système & Cloud',
    description: 'Partage la même passion pour l\'informatique et les réseaux télécoms.',
    imagePath: 'assets/images/family/brother.jpg',
  ),
  const FamilyMember(
    name: 'Grâce Mandey',
    relationship: 'Petite Sœur',
    profession: 'Étudiante en Médecine',
    description: 'Brillante et travailleuse, toujours souriante et prête à aider.',
    imagePath: 'assets/images/family/sister.jpg',
  ),
  const FamilyMember(
    name: 'David Magbadi',
    relationship: 'Cadet',
    profession: 'Élève au Collège',
    description: 'Amateur de football et de jeux vidéo, débordant d\'énergie et de curiosité.',
    imagePath: 'assets/images/family/younger_brother.jpg',
  ),
];
