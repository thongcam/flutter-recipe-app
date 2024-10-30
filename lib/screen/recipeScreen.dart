import 'dart:math';
import 'package:first_project/main.dart';
import 'package:flutter_quill/flutter_quill.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:first_project/widget/recipeInformationWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<RecipeScreen> createState() => _RecipeScreen();
}

class _RecipeScreen extends State<RecipeScreen> {
  final recipesController = Get.find<RecipesController>();
  @override
  Widget build(BuildContext context) {
    String recipeID = Get.parameters["recipeID"] != null
        ? Get.parameters["recipeID"].toString()
        : "";
    if (recipeID == "") {
      Get.back();
      return MyHomePage(title: 'Recipe app');
    } else {
      var recipe = recipesController.recipesList[recipeID]!;
      QuillController _controller = QuillController(
          document: Document.fromDelta(recipe.richTextDelta),
          readOnly: true,
          selection: const TextSelection.collapsed(offset: 0));
      // This method is rerun every time setState is called, for instance as done
      // by the _incrementCounter method above.
      //
      // The Flutter framework has been optimized to make rerunning build methods
      // fast, so that you can just rebuild anything that needs updating rather
      // than having to individually change instances of widgets.
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            tooltip: "Edit this recipe",
            onPressed: () async {
              await Get.toNamed("/edit/$recipeID");
              setState(() {});
            },
            child: Icon(Icons.edit),
          ),
          appBar: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(recipe.name),
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back)),
            actions: [
              IconButton(
                onPressed: () async {
                  await Get.toNamed("/edit/$recipeID");
                  setState(() {});
                },
                icon: Icon(Icons.edit),
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Container(
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
                              Text(recipe.name,
                                  style: TextStyle(fontSize: 36.0)),
                              SizedBox(
                                height: 36,
                              ),
                              Column(
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
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              QuillEditor(
                                controller: _controller,
                                scrollController: ScrollController(),
                                focusNode: FocusNode(canRequestFocus: false),
                                configurations: QuillEditorConfigurations(
                                  showCursor: false, // true for view only mode
                                ),
                              )
                            ],
                          ))
                        ])),
                  ))));
    }
  }
}
