import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_magbadi_mandey_clement/main.dart';

void main() {
  testWidgets('Page de connexion affichée au lancement', (WidgetTester tester) async {
    await tester.pumpWidget(const CvApp());
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Identifiant'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });
}
