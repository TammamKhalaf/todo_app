import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit.get(context).doneTasks;
    return tasks.length > 0
        ? BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var tasks = AppCubit.get(context).doneTasks;
              return ListView.separated(
                  itemBuilder: (context, index) =>
                      buildTaskItem(tasks[index], context),
                  separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20.0),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                  itemCount: tasks.length);
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  "No tasks yet please add some!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                )
              ],
            ),
          );
  }
}
