



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/Archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shar/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
   static AppCubit git(context)=>BlocProvider.of(context) ;
  int currentIndex=0 ;
  List <Widget>screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List <String> titeles =
  [
    '   NewTasks',
    '   DoneTasks',
    '   ArchivedTasks',
  ];
  void changeIndex(index)
  {
    currentIndex=index ;
    emit(AppChangeBottomNaveBarState());
  }

  late Database database ;

  List<Map> tasks1=[];
  List<Map> newTasks=[];
  List<Map> donTasks=[];
  List<Map> archivedTasks=[];

  void createDatabase()
  {
 openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version) async
        {
          print('db creat');
          database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT )').then((value)
          {
            print('table created');

          }).catchError((onError)
          {     print('error when creat${onError.toString()}');
          });
        }  ,
        onOpen: (database)
        async {
          await  gitDataFromDatabase(database) ;
          print('db open ');

        }
    ).then((value)
          {
            database=value ;
            emit(AppCreateDatabaseState());
          }) ;

  }

 insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    print('inserted successf');
     await database.transaction ((txn)
    async {
      txn.rawInsert(
          'INSERT INTO tasks(title ,date ,time, status)VALUES ("$title","$date","$time","new")'
      )
          .then((value)
      async{
        print('${value}- inserted successfully');
        emit(AppInsertDatabaseState());
       await gitDataFromDatabase(database);
      }
      ).catchError((error){
        print(' erorre when Iserting ${error.toString()}');
      });


    }
      // await database.transaction((txn) async {
      //   int id1 = await txn.rawInsert(
      //       'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      //   print('inserted1: $id1');
      //   int id2 = await txn.rawInsert(
      //       'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
      //       ['another name', 12345678, 3.1416]);
      //   print('inserted2: $id2');
      // });
    );
  }

   gitDataFromDatabase(database)
  {
     newTasks=[];
     donTasks=[];
     archivedTasks=[];
      emit( AppGetDatabaseLoadingState());
     database!.rawQuery('SELECT * FROM tasks').then((value)
     {
       value.forEach((element)
       {
         if(element['status']=='new')
           newTasks.add(element);
         else if(element['status']=='done')
           donTasks.add(element);
         else
           archivedTasks.add(element);
       })   ;

       emit(AppGetDatabaseState());

     });
  }

Color gets({required String status ,})
      {
        Color? color ;
        if(status=='archive')
        {
         color=Colors.amber[200];
         emit(AppCheckColorsState());

        }else if(status=='done')
        {
         color= Colors.green;
         emit(AppCheckColorsState());


        }else{
          color=Colors.red[200] ;

        }

        return color! ;
      }

  updateData(
    {
      required String status ,
      required int id ,
    })
   {
    database.rawUpdate(
      'UPDATE tasks SET status =? WHERE id = ? ',
        ['$status',id ]
        ).then((value)
    {
      gitDataFromDatabase(database);
          emit(AppUpdateDatabaseState());

    });
    }
  deleteData(
      {
        required int id ,
      })
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ? ',
        [id ]
    ).then((value)
    {
      gitDataFromDatabase(database);
      emit(AppDeleteDatabaseState());

    });
  }

  bool isBottomSheetShown=false;
  IconData fabIcon =Icons.edit ;

  void changeBottomSheetState (
  {
  required bool? isShow,
   required IconData? icon ,
  })
  {
   isBottomSheetShown=isShow! ;
   fabIcon =icon! ;
   emit(AppChangeBottomSheetState());

  }


}
