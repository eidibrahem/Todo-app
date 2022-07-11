

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/Archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shar/componant/componant.dart';
import 'package:todo/shar/componant/constant.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shar/cubit/cubit.dart';
import 'package:todo/shar/cubit/states.dart';

class HomeLayout extends StatelessWidget {



  var scaffoldKey =GlobalKey<ScaffoldState>();
  var formKey =GlobalKey<FormState>();

  var titleController =TextEditingController();
  var timeController =TextEditingController();
  var dateController =TextEditingController();



  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {
              if (state is AppInsertDatabaseState)
              {
                Navigator.pop(context);
              }
            },
            builder: (context, state)
            {
              var cubit =AppCubit.git(context);
              return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
              cubit.titeles[cubit.currentIndex],
          ),

        ),//Center(child: CircularProgressIndicator())
        body: state is!AppGetDatabaseLoadingState?  cubit.screens[cubit.currentIndex]:Center(child: CircularProgressIndicator()),

        //tasks.length>1?cubit.screens[cubit.currentIndex]: Center(child: CircularProgressIndicator()),


        floatingActionButton: FloatingActionButton(
          onPressed: ()
          {
            if(cubit.isBottomSheetShown)
            {
              if(formKey.currentState!.validate())
            {
             cubit.insertToDatabase(
                  title: titleController.text,
                  time: timeController.text
                  , date: dateController.text
              ).then((value)
              {

              });
              //
              //   Navigator.pop(context);
              //   // isBottomSheetShown=false;
              //   // setState(() {
              //   //   fabIcon =Icons.edit ;
              //   // });
              // });


            }



            }else
              {
                scaffoldKey.currentState?.showBottomSheet((context) =>Container(
                  color: Colors.purple[100],
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                      defaultFormFieldX(
                            Controller: titleController,
                      type: TextInputType.text,
                      validator: ( value)
                       {
                        if(value!.isEmpty){
                         return 'title must not be empty';
                       }
                       },
                      label: 'Task title ',
                      prefix: Icons.title ,
                      color: Colors.amberAccent,
                        ontap: ()
                        {

                        }
                      ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormFieldX(
                            Controller: timeController,
                            type: TextInputType.text,
                            validator: ( value)
                            {
                              if(value!.isEmpty){
                                return 'time must not be empty';
                              }
                            },
                            label: 'Task time ',
                            prefix: Icons.access_time ,
                            color: Colors.amberAccent,
                            ontap: ()
                            {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                              ).then((value)
                              {
                          timeController.text= value!.format(context).toString();
                             print(timeController.text);
                              });
                            }

                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormFieldX(
                            Controller: dateController,
                            type: TextInputType.text,
                            validator: ( value)
                            {
                              if(value!.isEmpty){
                                return 'date must not be empty';
                              }
                            },
                            label: 'Task date ',
                            prefix: Icons.perm_contact_calendar_outlined ,
                            color: Colors.amberAccent,
                            ontap: ()
                            {
                          showDatePicker(
                                 context: context,
                                 initialDate:DateTime.now(),
                                 firstDate: DateTime.now(),
                                 lastDate: DateTime.parse('2029-06-30'),
                             ).then((value)
                                         {
                                          dateController.text= DateFormat.yMMMd().format(value!) ;
                                         }) ;
                            }

                        )





                      ],
                    ),
                  ),
                ),
                ).closed.then((value) {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                    // setState(() {
                    //    isBottomSheetShown=false;
                    //    fabIcon =Icons.edit ;
                    //       });

                  });
                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                // isBottomSheetShown=true ;
                // setState(() {
                //   fabIcon =Icons.add ;
                // });
              }

          },
          elevation: 20.0,
          backgroundColor: Colors.purple[300],
          child: Icon(
              cubit.fabIcon
          ),

        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white38,
          currentIndex:cubit.currentIndex,
          onTap: (index){
            cubit.changeIndex(index);
            // setState(() {
            //   currentIndex=index;
            // });
          },
          elevation: 50.0,
          items: [
            BottomNavigationBarItem(
                icon:Icon(
                  Icons.done_outline_outlined,
                ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon:Icon(
                Icons.check_circle_outline,
              ),
              label: 'done',
            ),
            BottomNavigationBarItem(
              icon:Icon(
                Icons.archive_outlined,
              ),
              label: 'Archived',
            ),
          ],

        ),
      );
            }
            ),);

  }

  }



