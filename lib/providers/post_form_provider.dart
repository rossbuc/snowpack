import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/models/aspect.dart';

final postFormProvider = ChangeNotifierProvider((ref) => PostFormProvider());

class PostFormProvider with ChangeNotifier {
  String? _title;
  String? _description;
  String? _elevation;
  Aspect? _aspect;
  int? _temperature;

  String? get title => _title;
  String? get description => _description;
  String? get elevation => _elevation;
  Aspect? get aspect => _aspect;
  int? get temperature => _temperature;

  void setTitle(String? title) {
    _title = title;
    notifyListeners();
  }

  void setDescription(String? description) {
    _description = description;
    notifyListeners();
  }

  void setElevation(String? elevation) {
    _elevation = elevation;
    notifyListeners();
  }

  void setAspect(Aspect? aspect) {
    _aspect = aspect;
    notifyListeners();
  }

  void setTemperature(int? temperature) {
    _temperature = temperature;
    notifyListeners();
  }
}
