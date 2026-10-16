import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/controller/functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';

/// Single source of truth for "is this question visible?".
/// Static so both widgets (inside Obx) and the controller can call it.
class ConditionEvaluator {
  ConditionEvaluator._();

  /// Visible only if its own conditions match AND every parent
  /// it depends on is itself visible (handles chains A -> B -> C).
  static bool isVisible(
    FunctionalQuestion question,
    FunctionalController controller, {
    int depth = 0,
  }) {
    if (depth > 10) return true; // guard against circular configs

    final conditions = question.visibleWhen;
    if (conditions == null || conditions.isEmpty) return true;

    for (final c in conditions) {
      final key = c.key;
      if (key == null || key.trim().isEmpty) continue;

      // Read from the RxMap. When called inside Obx this subscribes it.
      final actual = controller.dynamicFormValue[key];

      if (!_matches(actual, c.value)) return false;

      final parent = controller.dynamicFormConfig.firstWhereOrNull(
        (q) => q.questionId == key,
      );
      if (parent != null && !isVisible(parent, controller, depth: depth + 1)) {
        return false;
      }
    }
    return true;
  }

  static bool _matches(dynamic actual, dynamic expected) {
    final a = normalize(actual);
    // expected may be a list => "any of"
    if (expected is List) {
      return expected.map(normalize).contains(a);
    }
    return a == normalize(expected);
  }

  static dynamic normalize(dynamic value) {
    if (value == null) return null;
    if (value is bool || value is num) return value;
    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == 'true' || v == 'yes') return true;
      if (v == 'false' || v == 'no') return false;
      return v;
    }
    return value;
  }
}
