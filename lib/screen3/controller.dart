import 'package:get/get.dart';

class Screen3Controller extends GetxController {
  var todolist = <String, dynamic>{}.obs;
  int id = 0;

  var isTaskCompleted = false.obs; // Observable to track checkbox state
  var checkedTask = <String, RxBool>{}.obs;

  void toggleTaskCompletion(bool? value) {
    isTaskCompleted.value = value ?? false; // Update checkbox value
  }

  addtolist(sub, desc, cat, date, checked) {
    id = id + 1;
    String sid = id.toString();
    if (!todolist.containsKey(sid)) {
      todolist[sid] = {};
    }
    todolist[sid]['id'] = id;
    todolist[sid]['subject'] = sub;
    todolist[sid]['description'] = desc;
    todolist[sid]['category'] = cat;
    todolist[sid]['date'] = date;

    if (checked == 'true') {
      todolist[sid]['checked'] = true;
      checkedTask[sid] = true.obs;
    } else if (checked == 'false') {
      todolist[sid]['checked'] = false;
      checkedTask[sid] = false.obs;
    }
  }

  deletefromtodolist(sid) {
    if (todolist.containsKey(sid)) {
      todolist.remove(sid);
      checkedTask.remove(sid);
    }
  }

  changecheck(sid) {
    todolist[sid]['checked'] = !todolist[sid]['checked'];

    if (checkedTask.containsKey(sid)) {
      checkedTask[sid]!.value = !checkedTask[sid]!.value;
    }
  }

  void clearTodolist() {
    todolist.clear();
    checkedTask.clear();
  }
}
