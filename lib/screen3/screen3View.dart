import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/Screen2/controller.dart';
import 'package:todolist/screen3/controller.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Screen3View extends StatelessWidget {
  Screen3View({super.key});
  final Screen2Controller screen2controller= Get.put(Screen2Controller());
  final Screen3Controller screen3controller=Get.put(Screen3Controller());

  TextEditingController subController= TextEditingController();
  TextEditingController desController= TextEditingController();
  TextEditingController catController= TextEditingController();
  TextEditingController dateController= TextEditingController();
  TextEditingController checkController= TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffffd99f),Color(0xfffb7d74)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SafeArea(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Welcome, ${screen2controller.firstnameController.text}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),
                ),
                SizedBox(height: 2,),
                IconButton(
                    icon: FaIcon(FontAwesomeIcons.pencilSquare), // Notebook icon with a pen
                    onPressed: () {
                      clearconfirm(context);
                    }),
                SizedBox(height: 50,),
                Expanded(child: _listview(context))

              ],
            ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showbottom(context);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _listview(context){
    return Obx(() {
      if (screen3controller.todolist.isEmpty) {
        return const Center(
            child:Text(
              "Add to your\n TO-DO LIST",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            )
        );
      } else if (screen3controller.todolist.length > 0) {
        List<String> keysList = screen3controller.todolist.keys.toList();
        return ListView.separated(
          separatorBuilder: (context,builder){
            return const Divider(
              color: Colors.transparent,
              height: 10,
            );
          },
          itemBuilder: (context, index){
            return Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child:
                          InkWell(
                              onTap: (){
                                _showRecordDetails(context, keysList[index]);
                              },
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "${screen3controller.todolist[keysList[index]]['subject']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(
                                    "${screen3controller.todolist[keysList[index]]['description']}",
                                    style: const TextStyle(
                                        fontSize: 15
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 15,),

                                  Row(
                                      children: [
                                        const Text(
                                          "Category : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                          ),
                                        ),
                                        Text(
                                          "${screen3controller.todolist[keysList[index]]['category']}",
                                          style: const TextStyle(
                                              fontSize: 12
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ]
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                      children: [
                                        const Text(
                                          "Created on : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                          ),
                                        ),
                                        Text(
                                          "${screen3controller.todolist[keysList[index]]['date']}",
                                          style: const TextStyle(
                                              fontSize: 12
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ]
                                  ),
                                  Row(
                                      children: [
                                        const Text(
                                          "Completed ?  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                          ),
                                        ),
                                        Obx(()=>Checkbox(
                                          value:  screen3controller.checkedTask[keysList[index]]?.value ?? false,
                                          onChanged: (bool? value) {
                                            screen3controller.changecheck(keysList[index]);
                                          },
                                        )),
                                      ]
                                  ),

                                ],
                              )),

                        ),


                      )),
                  Container(
                    width: MediaQuery.of(context).size.width* 0.1,
                    child: InkWell(
                      child: const Icon(Icons.delete),
                      onTap: (){
                        _showDeleteConfirmation(context, keysList[index]);
                      },
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: screen3controller.todolist.length,
        );
      } else {
        return const Text("Something went wrong, \n Plase try again");
      }
    });
  }


  void clearconfirm(context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Clear List"),
        content: Text("Do you really want to clear your to-do list?"),
        actions: [
          TextButton(
            onPressed: () {
              screen3controller.clearTodolist();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Just close the dialog
            child: Text("No"),
          ),
        ],
      ),
    );
  }


  void _showRecordDetails(BuildContext context, dynamic key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero, // To avoid extra padding around content
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width* 0.8,
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Record Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);  // Close the dialog
                        },
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subject: ${screen3controller.todolist[key]['subject']}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Description: ${screen3controller.todolist[key]['description']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Category: ${screen3controller.todolist[key]['category']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Created on: ${screen3controller.todolist[key]['date']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text("Completed: ", style: TextStyle(fontSize: 14)),
                              Checkbox(
                                value: screen3controller.todolist[key]['checked'],
                                onChanged: (bool? value) {
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);  // Close dialog
                    },
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),

        );
      },
    );
  }


  void _showDeleteConfirmation(BuildContext context, dynamic key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                screen3controller.deletefromtodolist(key);
                Navigator.of(context).pop();  // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  _showbottom(context){

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        context: context,
        isScrollControlled:true,
        builder: (builder) => FractionallySizedBox(
            heightFactor: 0.6,
            child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          subController.clear();
                          desController.clear();
                          catController.clear();
                          checkController.clear();
                          screen3controller.isTaskCompleted.value = false;
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                  ),
                  body: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child:Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Subject field
                              TextFormField(
                                controller: subController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  hintText: "SUBJECT",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a subject';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Description field
                              TextFormField(
                                controller: desController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  hintText: "Description",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                maxLines: 3,
                                minLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Category field
                              TextFormField(
                                controller: catController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  hintText: "Category",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a category';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),

                              Row(
                                children: [
                                  const Text("Completed?"),
                                  const SizedBox(width: 20),
                                  Obx(() {
                                    return Checkbox(
                                      value: screen3controller.isTaskCompleted.value,
                                      onChanged: (bool? value) {
                                        screen3controller.toggleTaskCompletion(value);
                                        checkController.text = value.toString();
                                      },
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 10),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    if(checkController.text!='true'){
                                      checkController.text='false';
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      screen3controller.addtolist(
                                        subController.text,
                                        desController.text,
                                        catController.text,
                                        DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                                        checkController.text,
                                      );

                                      subController.clear();
                                      desController.clear();
                                      catController.clear();
                                      checkController.clear();
                                      screen3controller.isTaskCompleted.value = false;
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      "UPDATE",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                )
            )));
  }
}
