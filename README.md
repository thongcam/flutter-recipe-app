# flutter-recipe-app

Access this app via: [https://flutter-recipe-app.thong.cam](https://flutter-recipe-app.thong.cam "link")

## Project idea

This is a very simple recipe management app. Users can add new recipes, view, and edit existing recipes. Each recipe contains the following information:

- Recipe name
- Recipe time (how long it takes to make) in minutes
- Whether it is vegan
- Which meal of the day it is (Breakfast, Lunch, or Dinner)
- Recipe content in rich text

In the homescreen, users can filter the recipe by time, vegan, and meal. Homescreen is responsive to different screen sizes. Recipes data are saved locally using the Hive database, and thus should persist through app refreshes.

## Instructions

Start adding a new recipe by clicking the "+" floating button on the homescreen. Enter all required information. Click "Add" in the top right corner to add the new recipe. Alternatively, you can click the "X" button in the top left corner to cancel adding.

After adding a new recipe, you will be redirected to the homescreen, where you can see the new recipe. You can add as many recipes as you wish. You can use the filter inputs above the recipes to filter them.

Simply click on a recipe to view it. To edit the recipe, click the pencil icon floating button or the pencil icon button in the top right corner. Change any information you wish and press the "Save" button in the top right corner to save the edits. Alternatively, you can click the "X" button in the top left corner to cancel editing. After saving, you will be back to the recipe view screen.
