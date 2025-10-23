class CustomLinterRules {
  static const List<String> bannedWords = ['TODO', 'FIXME', 'HACK'];

  static bool containsBannedWord(String code) {
    for (final word in bannedWords) {
      if (code.contains(word)) return true;
    }
    return false;
  }

  static List<String> findViolations(String code) {
    final violations = <String>[];
    for (final word in bannedWords) {
      if (code.contains(word)) {
        violations.add('Found banned word: $word');
      }
    }
    return violations;
  }
}
