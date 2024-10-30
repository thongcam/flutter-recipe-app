import 'package:first_project/schema/recipe.dart';
import 'package:first_project/widget/recipeWidget.dart';
import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';

class RecipeListWidget extends StatelessWidget {
  final recipesController = Get.find<RecipesController>();
  final _formKeyFilter = GlobalKey<FormBuilderState>();
  Function navigateToRecipe;
  RxBool filterApplied = false.obs;

  bool checkFilter(Recipe recipe) {
    if (!filterApplied.value) {
      return true;
    } else {
      var formValues = _formKeyFilter.currentState?.value;
      return (formValues?["maxTime"] == "unlimited" ||
              recipe.minutes < formValues?["maxTime"]) &&
          (formValues?["vegan"] == null ||
              recipe.vegan ||
              recipe.vegan == formValues?["vegan"]) &&
          (formValues?["meal"].contains(recipe.meal));
    }
  }

  RxList<Widget> cards;

  List<Widget> getCards() => recipesController.recipesList.entries
      .where((element) => checkFilter(element.value))
      .map<Widget>((e) => RecipeWidget(
            recipe: e.value,
            navigateToRecipe: navigateToRecipe,
          ))
      .toList()
      .obs;

  RecipeListWidget({super.key, required this.navigateToRecipe})
      : cards = <Widget>[].obs {
    cards = getCards().obs;
  }

  _clear() {
    _formKeyFilter.currentState?.reset();
    _formKeyFilter.currentState?.fields['maxTime']?.didChange("unlimited");
    filterApplied.value = false;
  }

  _submit() {
    _formKeyFilter.currentState?.saveAndValidate();
    filterApplied.value = true;
    cards.value = getCards();
    filterApplied.refresh();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var columnCount = MediaQuery.of(context).size.width >= 1000 ? 2 : 1;
    var rowCount = (cards.length / columnCount).ceil();

    List<Widget> dropDownAndVegan = [
      Flexible(
          flex: 2,
          child: FormBuilderDropdown(
            onChanged: (v) => _submit(),
            name: "maxTime",
            decoration: InputDecoration(label: Text("Max time")),
            items: [
              DropdownMenuItem(child: Text("30 minutes"), value: 30),
              DropdownMenuItem(child: Text("60 minutes"), value: 60),
              DropdownMenuItem(child: Text("120 minutes"), value: 120),
              DropdownMenuItem(child: Text("Unlimited"), value: "unlimited"),
            ],
            initialValue: "unlimited",
          )),
      SizedBox(width: 16),
      Flexible(
          flex: 1,
          child: FormBuilderCheckbox(
              onChanged: (v) => _submit(),
              name: "vegan",
              title: Text("Vegan"))),
    ];

    return Obx(() => Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(32),
        child: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1270),
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.

                child: Column(children: [
                  FormBuilder(
                      key: _formKeyFilter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 3,
                              child: MediaQuery.of(context).size.width >= 650
                                  ? Row(children: dropDownAndVegan)
                                  : ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxHeight: 120),
                                      child: Column(
                                        children: dropDownAndVegan,
                                      ))),
                          SizedBox(width: 16),
                          Flexible(
                              flex: 2,
                              child: FormBuilderCheckboxGroup(
                                onChanged: (v) => _submit(),
                                name: "meal",
                                options: [
                                  FormBuilderFieldOption(value: "Breakfast"),
                                  FormBuilderFieldOption(value: "Lunch"),
                                  FormBuilderFieldOption(value: "Dinner")
                                ],
                                initialValue: ["Breakfast", "Lunch", "Dinner"],
                                wrapSpacing: 8.0,
                                decoration:
                                    InputDecoration(label: Text("Which meal?")),
                              )),
                          ElevatedButton(
                            onPressed: filterApplied.value ? _clear : null,
                            child: Text("Reset filter"),
                            style: ButtonStyle(),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 32,
                  ),
                  Expanded(
                      child: LayoutGrid(
                    gridFit: GridFit.loose,
                    rowSizes: rowCount == 0
                        ? [auto]
                        : Iterable<IntrinsicContentTrackSize>.generate(
                            rowCount, (e) => auto).toList(),
                    columnSizes: columnCount == 1 ? [1.fr] : [1.fr, 1.fr],
                    columnGap: 16,
                    rowGap: 16,
                    children: cards,
                  ))
                ])))));
  }
}
