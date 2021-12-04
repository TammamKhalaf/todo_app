import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();
var formKey = GlobalKey<FormState>();

var titleEditingController = TextEditingController();
var timeEditingController = TextEditingController();
var dateEditingController = TextEditingController();

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
            if (state is AppInsertDatabaseState) {
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: titleEditingController.text,
                          date: dateEditingController.text,
                          time: timeEditingController.text);
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      controller: titleEditingController,
                                      type: TextInputType.text,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'title must not be empty!';
                                        }
                                        return null;
                                      },
                                      label: "Task Title",
                                      prefix: Icons.title),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) => {
                                                  timeEditingController.text =
                                                      value!
                                                          .format(context)
                                                          .toString(),
                                                });
                                      },
                                      controller: timeEditingController,
                                      type: TextInputType.datetime,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Time must not be empty!';
                                        }
                                        return null;
                                      },
                                      label: "Task Time",
                                      prefix: Icons.watch_later_outlined),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    "${DateTime.now().year + 1}-05-01"))
                                            .then((value) {
                                          dateEditingController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      controller: dateEditingController,
                                      type: TextInputType.datetime,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Date must not be empty!';
                                        }
                                        return null;
                                      },
                                      label: "Task Date",
                                      prefix: Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                          elevation: 15.0,
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(isShow:false,icon:Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow:true,icon:Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: "Archive"),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
              ),
              body: cubit.screens[cubit.currentIndex],
            );
          },
        ),
      ),
    );
  }
}
