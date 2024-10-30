import 'package:first_project/main.dart';
import 'package:first_project/schema/recipe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';
import 'dart:math';

class AddRecipeScreen extends StatelessWidget {
  final recipesController = Get.find<RecipesController>();
  final _formKey = GlobalKey<FormBuilderState>();
  QuillController _controller = QuillController.basic();

  String urlSafeString(String inputString) {
    // Extract the first 5 words
    final firstFiveWords = inputString.split(' ').take(5).join(' ');

    // Encode the first 5 words to URL-safe base64
    final encodedString = base64UrlEncode(utf8.encode(firstFiveWords));

    return encodedString;
  }

  _save() {
    var formData = _submit();
    if (formData != null) {
      var recipeID = urlSafeString(formData["name"]);
      var newRecipe = Recipe(
          id: recipeID,
          name: formData["name"],
          vegan: formData["vegan"],
          minutes: int.parse(formData["minutes"]),
          meal: formData["meal"],
          richTextDelta: _controller.document.toDelta());
      recipesController.addRecipe(newRecipe);
      Get.back();
    }
  }

  _clear() {
    _formKey.currentState?.reset();
  }

  _submit() {
    var validated = _formKey.currentState?.saveAndValidate();
    return (validated != null && validated)
        ? _formKey.currentState?.value
        : null;
  }

  AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Recipe name"),
          leading: IconButton(
              onPressed: () => Get.back(), icon: const Icon(Icons.close)),
          actions: [FilledButton(onPressed: () => _save(), child: Text("Add"))],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.

                  child: Row(children: [
                    Expanded(
                        child: Column(
                            // Column is also a layout widget. It takes a list of children and
                            // arranges them vertically. By default, it sizes itself to fit its
                            // children horizontally, and tries to be as tall as its parent.
                            //
                            // Column has various properties to control how it sizes itself and
                            // how it positions its children. Here we use mainAxisAlignment to
                            // center the children vertically; the main axis here is the vertical
                            // axis because Columns are vertical (the cross axis would be
                            // horizontal).
                            //
                            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                            // action in the IDE, or press "p" in the console), to see the
                            // wireframe for each widget.
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Expanded(
                              child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormBuilderTextField(
                                    name: 'name',
                                    decoration: InputDecoration(
                                      hintText: 'Type text here',
                                      border: OutlineInputBorder(),
                                      label: Text("Recipe name"),
                                    ),
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: FormBuilderValidators.compose(
                                      [
                                        FormBuilderValidators.required(),
                                      ],
                                    )),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 200.0),
                                      child: FormBuilderSwitch(
                                        name: 'vegan',
                                        title: Text("Vegan?"),
                                        initialValue: false,
                                      )),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: FormBuilderTextField(
                                          name: 'minutes',
                                          decoration: InputDecoration(
                                            hintText: 'Type number here',
                                            border: OutlineInputBorder(),
                                            label: Text(
                                                "Recipe time (in minutes)"),
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          validator:
                                              FormBuilderValidators.compose(
                                            [
                                              FormBuilderValidators.required(),
                                              FormBuilderValidators
                                                  .positiveNumber()
                                            ],
                                          ))),
                                ]),
                                SizedBox(
                                  height: 16,
                                ),
                                Text("Which meal?"),
                                FormBuilderChoiceChip(
                                    name: "meal",
                                    spacing: 8.0,
                                    options: [
                                      FormBuilderChipOption(value: "Breakfast"),
                                      FormBuilderChipOption(value: "Lunch"),
                                      FormBuilderChipOption(value: "Dinner")
                                    ],
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: FormBuilderValidators.compose(
                                      [
                                        FormBuilderValidators.required(),
                                      ],
                                    )),
                                SizedBox(
                                  height: 32,
                                ),
                                LimitedBox(
                                    child: QuillSimpleToolbar(
                                  controller: _controller,
                                  configurations:
                                      const QuillSimpleToolbarConfigurations(),
                                )),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  child: QuillEditor.basic(
                                    controller: _controller,
                                    configurations:
                                        const QuillEditorConfigurations(),
                                  ),
                                ))
                              ],
                            ),
                          ))
                        ]))
                  ])),
            )));
  }
}
