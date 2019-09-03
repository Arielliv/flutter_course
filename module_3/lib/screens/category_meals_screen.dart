import 'package:flutter/material.dart';
import 'package:module_3/widgets/meal_item.dart';
import '../dummy-data.dart';

class CategoryMealsSceen extends StatelessWidget {
  // final String categoryId;
  // final String categoryTitle;

  // CategoryMealsSceen(this.categoryId, this.categoryTitle);
  static const routeName = '/category-meals';

  @override
  Widget build(BuildContext context) {
    final routsArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routsArgs['title'];
    final categoryId = routsArgs['id'];
    final categoryMeals = DUMMY_MEALS.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryTitle),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, index) {
            return MealItem(
              title: categoryMeals[index].title,
              imageUrl: categoryMeals[index].imageUrl,
              duration: categoryMeals[index].duration,
              affordability: categoryMeals[index].affordability,
              complexity: categoryMeals[index].complexity,
            );
          },
          itemCount: categoryMeals.length,
        ));
  }
}
