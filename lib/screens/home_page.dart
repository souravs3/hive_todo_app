import 'package:flutter/material.dart';
import 'package:hive_cruds/components/width_height.dart';
import 'package:hive_cruds/models/todo_model.dart';
import 'package:hive_cruds/service/todo_service.dart';
import 'package:hive_cruds/styles/home_textstyle.dart';
import 'package:hive_cruds/utility/app_colors.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TodoService _todoService = TodoService();

  List<Todo> _todos = [];

  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();
  //loading all todos fetching.............................

  Future<void> _loadTodos() async {
    _todos = await _todoService.getTodos();

    setState(() {});
  }

  @override
  void initState() {
    _loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Todo',
          style: logoTitleStyle(),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Hy John,',
                      style: mainTitleStyle(),
                    ),
                    Text(
                      'Welcome back...',
                      style: subTitleStyle(),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      showAddDialoge();
                    },
                    child: Text(
                      '+ Add Task',
                      style: buttonTextStyle(),
                    ))
              ],
            ),
            20.h,
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return GestureDetector(
                        onTap: () {
                          //edit........................
                          showEditDialoge(todo, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${todo.title}',
                                        style: mainTitleStyleCard(),
                                      ),
                                      Text(
                                        '${todo.description}',
                                        style: subTitleStyleCard(),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat.yMMMEd().format(todo.createdAt),
                                    style: dateStyleCard(),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  VerticalDivider(),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Checkbox(
                                          fillColor: MaterialStatePropertyAll(
                                              Colors.black),
                                          shape: CircleBorder(),
                                          value: todo.completed,
                                          onChanged: (value) {
                                            setState(() {
                                              todo.completed = value!;
                                              _todoService.updateTodo(
                                                  index, todo);

                                              setState(() {});
                                            });
                                          }),
                                      RotatedBox(
                                        quarterTurns: 9,
                                        child: Text(
                                          'Todo',
                                          style: logoTitleStyleCard(),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showAddDialoge() async {
    await showDialog(
        barrierColor: const Color.fromARGB(156, 2, 2, 2),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Add New Task',
              style: mainTitleStyle(),
            ),
            backgroundColor: AppColors.primaryColor,
            content: Container(
              width: 400,
              height: MediaQuery.of(context).size.height / 3,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Fill the box';
                          }
                          return null;
                        },
                        controller: titleController,
                        style: textfieldStyle(),
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.title,
                              color: Colors.white,
                            ),
                            label: Text('Name'),
                            hintText: 'Enter the title....',
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                      20.h,
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Fill the box';
                          }
                          return null;
                        },
                        controller: descController,
                        style: textfieldStyle(),
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                            label: Text('Description'),
                            hintText: 'Enter the description....',
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder()),
                      ),
                      20.h,
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Fill the box';
                          }
                          return null;
                        },
                        onTap: () async {
                          final DateTime? dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));

                          final formatedDate =
                              DateFormat('dd-MM-yyyy').format(dateTime!);

                          // setState(() {
                          //   selectedDate = dateTime!;
                          //   dateController.text = formatedDate.toString();
                          // });

                          setState(() {
                            selectedDate = dateTime;
                            dateController.text = formatedDate.toString();
                          });
                        },
                        style: textfieldStyle(),
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            label: Text('Date'),
                            hintText: 'Pick a date....',
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder()),
                      ),
                      20.h,
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //       label: Text('Name'),
                      //       labelStyle: TextStyle(color: Colors.white),
                      //       border: OutlineInputBorder()),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.validate();
                    if (selectedDate == null) {
                      // Handle case when date is not selected
                      return;
                    }
                    final newTodo = Todo(
                        title: titleController.text,
                        description: descController.text,
                        createdAt: selectedDate!,
                        // DateFormat.yMMMMd().format(dateController.text),
                        completed: false);

                    await _todoService.addTodo(newTodo);

                    titleController.clear();
                    descController.clear();
                    dateController.clear();

                    Navigator.pop(context);

                    _loadTodos();
                  },
                  child: Text(
                    'Add',
                    style: buttonTextStyle(),
                  )),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: buttonTextStyle(),
                  )),
            ],
          );
        });
  }

  //update page..................

  Future<void> showEditDialoge(Todo todo, int index) async {
    titleController.text = todo.title;
    descController.text = todo.description;
    dateController.text = DateFormat.yMMMMd().format(todo.createdAt);

    await showDialog(
        barrierColor: const Color.fromARGB(156, 2, 2, 2),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Add New Task',
              style: mainTitleStyle(),
            ),
            backgroundColor: AppColors.primaryColor,
            content: Container(
              width: 400,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: titleController,
                    style: textfieldStyle(),
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.title,
                          color: Colors.white,
                        ),
                        label: Text('Name'),
                        hintText: 'Enter the title....',
                        hintStyle: TextStyle(color: Colors.grey.shade300),
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                  20.h,
                  TextFormField(
                    controller: descController,
                    style: textfieldStyle(),
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.description,
                          color: Colors.white,
                        ),
                        label: Text('Description'),
                        hintText: 'Enter the description....',
                        hintStyle: TextStyle(color: Colors.grey.shade300),
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder()),
                  ),
                  20.h,
                  TextFormField(
                    onTap: () async {
                      final DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));

                      final formatedDate =
                          DateFormat('dd-MM-yyyy').format(dateTime!);

                      // setState(() {
                      //   selectedDate = dateTime!;
                      //   dateController.text = formatedDate.toString();
                      // });

                      setState(() {
                        selectedDate = dateTime;
                        dateController.text = formatedDate.toString();
                      });
                    },
                    style: textfieldStyle(),
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        label: Text('Date'),
                        hintText: 'Pick a date....',
                        hintStyle: TextStyle(color: Colors.grey.shade300),
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder()),
                  ),
                  20.h,
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       label: Text('Name'),
                  //       labelStyle: TextStyle(color: Colors.white),
                  //       border: OutlineInputBorder()),
                  // ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (selectedDate == null) {
                      // Handle case when date is not selected
                      return;
                    }
                    final newTodo = Todo(
                        title: titleController.text,
                        description: descController.text,
                        createdAt: selectedDate!,
                        // DateFormat.yMMMMd().format(dateController.text),
                        completed: false);

                    await _todoService.addTodo(newTodo);

                    titleController.clear();
                    descController.clear();
                    dateController.clear();

                    Navigator.pop(context);

                    _loadTodos();
                  },
                  child: Text(
                    'Update',
                    style: buttonTextStyle(),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await _todoService.deletetodo(index);
                    _loadTodos();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: buttonTextStyle(),
                  )),
            ],
          );
        });
  }
}





//  TextFormField(
//                   // controller: dateTextEditingController,
//                   onTap: () async {
//                     final DateTime? date = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100));

//                     final formatedDate = DateFormat('dd-MM-yyyy').format(date!);

//                     print(formatedDate);

//                     setState(() {
//                       // dateTextEditingController.text = formatedDate.toString();
//                     });
//                   },
//                   style: const TextStyle(color: Colors.white),
//                   readOnly: true,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'please pick a date';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                       hintText: 'Pick the Date',
//                       hintStyle: textfieldStyle(),
//                       prefixIcon: const Icon(
//                         Icons.calendar_month,
//                         color: Colors.white,
//                       ),
//                       border: const OutlineInputBorder(),
//                       labelStyle: const TextStyle(color: Colors.grey)),
//                 ),
