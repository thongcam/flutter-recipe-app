import 'package:first_project/schema/recipe.dart';
import 'package:first_project/screen/recipeScreen.dart';
import 'package:first_project/widget/recipeInformationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  Function navigateToRecipe;
  RecipeWidget(
      {super.key, required this.recipe, required this.navigateToRecipe});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IntrinsicHeight(
        child: Center(
            child: InkWell(
                onTap: () => navigateToRecipe(recipe.id),
                child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: ListTile(
                          contentPadding: EdgeInsets.only(bottom: 16, left: 16),
                          title: Text(
                            recipe.name,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            Document.fromDelta(recipe.richTextDelta)
                                .toPlainText(),
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                          ),
                        )),
                        SizedBox(
                          width: 200,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RecipeInformationWidget(
                                      label: "Time: ${recipe.minutes}\"",
                                      icon: Icon(
                                        Icons.timer,
                                        color: Colors.black54,
                                        size: 16,
                                      )),
                                  recipe.vegan
                                      ? RecipeInformationWidget(
                                          label: "Vegan",
                                          icon: SvgPicture.asset(
                                            'assets/icons/vegan.svg',
                                            color: Colors.black54,
                                          ))
                                      : Container(),
                                  RecipeInformationWidget(
                                      label: "Meal: ${recipe.meal}",
                                      icon: SvgPicture.asset(
                                        'assets/icons/fork_spoon.svg',
                                        color: Colors.black54,
                                      )),
                                ],
                              )),
                        )
                      ],
                    )))));
  }
}
