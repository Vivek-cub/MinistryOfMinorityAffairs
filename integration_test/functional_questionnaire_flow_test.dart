import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/switch_form_field_widgets.dart';

import '../test/helpers/functional_test_fakes.dart';

void main(dynamic IntegrationTestWidgetsFlutterBinding) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('functional questionnaire flow reveals dependent fields', (
    tester,
  ) async {
    final controller = buildFunctionalController();

    final functionalQuestion = FunctionalQuestion(
      questionId: 'functional',
      questionText: 'Is the asset functional?',
      questionType: 'YES_NO',
      isMandatory: true,
    );
    final remarksQuestion = FunctionalQuestion(
      questionId: 'remarks',
      questionText: 'Functional remarks',
      questionType: 'TEXT',
      isMandatory: true,
      visibleWhen: [VisibleWhen(key: 'functional', value: true)],
    );

    controller.dynamicFormConfig
      ..clear()
      ..addAll([functionalQuestion, remarksQuestion]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: FormBuilder(
              key: controller.formKey,
              child: ListView(
                children: [
                  SwitchFormFieldWidgets(
                    question: functionalQuestion,
                    controller: controller,
                  ),
                  SwitchFormFieldWidgets(
                    question: remarksQuestion,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      find.textContaining('Is the asset functional?', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Functional remarks', findRichText: true),
      findsNothing,
    );

    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Functional remarks', findRichText: true),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'Site is operational');
    await tester.pumpAndSettle();

    expect(controller.formKey.currentState!.saveAndValidate(), isTrue);
    expect(controller.dynamicFormValue['functional'], isTrue);
    expect(controller.dynamicFormValue['remarks'], 'Site is operational');
    expect(controller.prepareAssessment(), [
      {'questionId': 'functional', 'answer': 'YES'},
      {'questionId': 'remarks', 'answer': 'Site is operational'},
    ]);
  });
}
