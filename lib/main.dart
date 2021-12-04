import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/shared/bloc_observer.dart';
import 'layout/home_layout.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(HomeLayout());
}
