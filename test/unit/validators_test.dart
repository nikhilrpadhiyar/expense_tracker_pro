import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_pro/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error on empty', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('returns error on invalid email', () {
      expect(Validators.email('notvalid'), isNotNull);
    });

    test('returns null on valid email', () {
      expect(Validators.email('user@example.com'), isNull);
    });
  });

  group('Validators.amount', () {
    test('returns error on empty', () {
      expect(Validators.amount(''), isNotNull);
    });

    test('returns error on zero', () {
      expect(Validators.amount('0'), isNotNull);
    });

    test('returns error on non-numeric', () {
      expect(Validators.amount('abc'), isNotNull);
    });

    test('returns null on valid positive amount', () {
      expect(Validators.amount('99.99'), isNull);
    });
  });
}
