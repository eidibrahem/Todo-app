
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shar/componant/componant.dart';
import 'package:todo/shar/cubit/cubit.dart';
import 'package:todo/shar/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer <AppCubit,AppStates>(
      listener:(context,state ){} ,
      builder:(context,state ){
        var tasks = AppCubit.git(context).archivedTasks ;
        if(tasks.length>0)
          return tasksBuilder(tasks: tasks);
        else
          return emptyTasksScreen();
      }  ,

    );

  }
}
