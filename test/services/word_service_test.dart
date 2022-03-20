import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wordle/services/word_service.dart';

void main() {
  testWidgets('WordService returns a different word each time', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var wordService = WordService();
      await wordService.init();

      var firstWord = wordService.randomWord();
      var secondWord = wordService.randomWord();

      expect(firstWord != secondWord, true);
    });
  });
}
