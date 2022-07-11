import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shar/cubit/cubit.dart';

Widget defultbuttom({
  double width =double.infinity,
  Color background =Colors.teal,
  required VoidCallback function ,
  bool isUpperCase = true ,
  String text ='' ,
  double borderRadius =10,
}) =>Container(

  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    color: background,
  ),
  width :width,
  child: MaterialButton(
    child: Text(
      isUpperCase?text.toUpperCase():text,
      style: TextStyle(
        color :Colors.white,
        fontSize: 18,

      ),
    ),
    onPressed : function,


  ),
) ;

Widget defultformfild ({
  double width = double.infinity,
  Color background  =Colors.teal,
  required TextEditingController textController ,
  String label ='@' ,
  IconData pri = Icons.email,
  required String valu ,
  IconData? sufIcon  ,
  required VoidCallback function(valu) ,
  required VoidCallback fun(valu) ,
  keyboardType = TextInputType.text,
  bool isUpperCase = true ,
  String text ='' ,
  double borderRadius =10,
})=>Container(

  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    color: background,
  ),
  width :width,
  child:TextFormField(
    controller:textController ,
    keyboardType:keyboardType ,
    onFieldSubmitted:   function,

    onChanged:   fun ,
    decoration:  InputDecoration(
      enabledBorder: InputBorder.none,
      labelText: label,
      border: OutlineInputBorder(),
      icon : Icon( Icons.email ) ,
      prefixIcon: Icon( pri ,color: Colors.teal,) ,
      suffixIcon: sufIcon!=null? Icon( sufIcon,color: Colors.teal,): null,
    ),
  ) ,
) ;
Widget defaultFormFieldX ({
  required TextEditingController Controller ,
  required TextInputType type ,
  Function? onsubmit(String  v)? ,
  Function? onchanged(String v)? ,
  VoidCallback? onpees ,
  VoidCallback? ontap ,
  TextStyle? style ,
  required String? validator ( String? v )? ,
  String? label ,
  IconData? prefix ,
  IconData? suffix ,
  bool ispass = false ,
  Color? color ,

})=>TextFormField(
  style: style,
  controller: Controller,
  keyboardType: type,
  onFieldSubmitted:  onsubmit,
  onTap: ontap,
  obscureText: ispass ,
  onChanged: onchanged ,
  validator: validator,

  decoration:  InputDecoration(

      border: OutlineInputBorder( ),

      prefixIcon: Icon( prefix ,) ,
      suffixIcon: IconButton( onPressed:onpees, icon: Icon( suffix,),)
  ),
);
Widget buildTaskItem(Map modle)=>Container(
  color: Colors.brown,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 50,
      vertical: 50,
    ),
    child: Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          //shape: BoxShape.circle,
          color: Colors.brown[300]
      ),
      child:Center(

          child: Container(

            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius:35 ,
                    child: Text('${modle['time']}'),
                  ),
                  SizedBox(width: 20 ,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text('${modle['title']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold ,
                        ),
                      ),
                      Text('${modle['data']}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold ,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    ),
  ),
);
Widget buildTaskItems(Map modle,context )=> Dismissible(
  key: Key(modle['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 35,

          child: Text('${modle['time']}'),

        ),

        SizedBox(width: 20.0,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                '${modle['title']}',

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              SizedBox(height: 10,),

              Text(

                '${modle['date']}',

                style: TextStyle(

                    color: Colors.grey

                ),

              ),

            ],

          ),

        ),

        SizedBox(width: 20.0,),

        IconButton(

            onPressed:()

            {

                  AppCubit.git(context).updateData(status: 'done', id: modle['id']);

            },

            icon:Icon(

              Icons.check_box ,

              color:AppCubit.git(context).gets(status:modle['status'] ),

              size: 30 ,

            )),

        IconButton(

            onPressed:()

            {

              AppCubit.git(context).updateData(status: 'archive', id: modle['id']);

            },

            icon:Icon(

              Icons.archive,

            color: Colors.black45,

            ))

      ],



    ),

  ),
  onDismissed: (direction)
  {
    AppCubit.git(context).deleteData(id:modle['id'] );
  },
);

Widget tasksBuilder({
required List<Map> tasks ,
})=>ListView.separated(
    itemBuilder: (context,index)=>buildTaskItems(tasks[index],context),
    separatorBuilder: (context,index)=>Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 20.0
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],

      ),
    ),
    itemCount:tasks.length ) ;
Widget emptyTasksScreen() => Center(
  child:   Column(
  mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Icon(

        Icons.menu,

        size: 100,

        color: Colors.grey,

      ),

      Text(

          'No Tasks Yet',

           style: TextStyle(

             fontSize: 16 ,

             fontWeight: FontWeight.bold,

             color: Colors.grey,



           ),

      ),

    ],



  ),
);