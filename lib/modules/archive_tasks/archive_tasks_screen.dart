import 'package:flutter/cupertino.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Archive Tasks"
        ,style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold,)
      ),
    );
  }
}
