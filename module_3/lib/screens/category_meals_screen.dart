import 'package:flutter/material.dart';
import 'package:module_3/widgets/meal_item.dart';
import '../models/meal.dart';

class CategoryMealsSceen extends StatefulWidget {
  // final String categoryId;
  // final String categoryTitle;

  // CategoryMealsSceen(this.categoryId, this.categoryTitle);
  static const routeName = '/category-meals';
  final List<Meal> availableMeals;

  CategoryMealsSceen(this.availableMeals);
  @override
  _CategoryMealsSceenState createState() => _CategoryMealsSceenState();
}

class _CategoryMealsSceenState extends State<CategoryMealsSceen> {
  String categoryTitle;
  List<Meal> displayedMeals;
  bool _loadedInitData = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routsArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routsArgs['title'];
      final categoryId = routsArgs['id'];
      displayedMeals = widget.availableMeals.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();
      _loadedInitData = true;
    }

    super.didChangeDependencies();
  }

  void _removeMeal(String mealId) {
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryTitle),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, index) {
            return MealItem(
              id: displayedMeals[index].id,
              title: displayedMeals[index].title,
              imageUrl: displayedMeals[index].imageUrl,
              duration: displayedMeals[index].duration,
              affordability: displayedMeals[index].affordability,
              complexity: displayedMeals[index].complexity,
            );
          },
          itemCount: displayedMeals.length,
        ));
  }
}
