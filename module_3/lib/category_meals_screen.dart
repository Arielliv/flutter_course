import 'package:flutter/material.dart';

class CategoryMealsSceen extends StatelessWidget {
  // final String categoryId;
  // final String categoryTitle;

  // CategoryMealsSceen(this.categoryId, this.categoryTitle);
  
  @override
  Widget build(BuildContext context) {
    final routsArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routsArgs['title'];
    final categoryId = routsArgs['id'];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: Center(
        child: const Text('The recipes for the category'),
      ),
    );
  }
}
