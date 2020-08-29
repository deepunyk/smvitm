import 'package:flutter/material.dart';
import 'package:smvitm/models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  void addCategory(Category _category) {
    _categories.add(_category);
  }

  List<Category> getCategory() {
    return _categories;
  }

  deleteItem() {
    _categories.clear();
  }
}
