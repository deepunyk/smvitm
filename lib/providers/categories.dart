import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smvitm/models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];
  List _selectedId = [];

  void addCategory(Category _category) {
    _categories.add(_category);
  }

  List<Category> getCategory() {
    return _categories;
  }

  deleteItem() {
    _categories.clear();
    _selectedId.clear();
  }

  addSelectedCategory(String id) {
    final fbm = FirebaseMessaging();
    fbm.subscribeToTopic(id);
    _selectedId.add(id);
    print(_selectedId.toString());
    final box = GetStorage();
    box.remove('selectedList');
    box.write('selectedList', _selectedId);
    notifyListeners();
  }

  removeSelectedCategory(String id) {
    final fbm = FirebaseMessaging();
    fbm.unsubscribeFromTopic(id);
    _selectedId.remove(id);
    print(_selectedId.toString());
    final box = GetStorage();
    box.remove('selectedList');
    box.write('selectedList', _selectedId);
    notifyListeners();
  }

  List getSelectedList() {
    return _selectedId;
  }

  String getCategoryName(String id) {
    String name = "";
    _categories
        .map((e) => {
              if (e.id == id) {name = e.name}
            })
        .toList();
    return name;
  }
}
