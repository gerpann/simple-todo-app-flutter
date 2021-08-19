import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/widgets/dialog_add_task_widget.dart';
import 'package:todo_app/src/widgets/task_widget.dart';
import 'package:todo_app/src/__mocks__/tasks_mock.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> _tasks = tasksMock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: ListView(
        children: _tasks.isNotEmpty
            ? _tasks
                .map((task) => TaskWidget(
                      key: Key(task.id.toString()),
                      task: task,
                      toggleCompleteTask: this._toggleCompleteTask,
                      removeTask: this._removeTask,
                    ))
                .toList()
            : <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        focusColor: Theme.of(context).accentColor,
        hoverColor: Theme.of(context).accentColor,
        onPressed: _onPressedAddButton,
        child: Icon(CupertinoIcons.add),
      ),
    );
  }

  void _onPressedAddButton() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogAddWidget(
              lastTaskId: _getLastTaskId(), addTask: _addTask);
        });
  }

  int _getLastTaskId() {
    if (this._tasks.isEmpty) {
      return 0;
    }
    return this
        ._tasks
        .reduce((curr, next) => curr.id > next.id ? curr : next)
        .id;
  }

  void _addTask(Task task) {
    setState(() {
      this._tasks.add(task);
    });
  }

  void _toggleCompleteTask(int taskId) {
    setState(() {
      this._tasks = this._tasks.map((task) {
        if (task.id != taskId) {
          return task;
        } else {
          return new Task(task.id, task.title, task.content, !task.isCompleted);
        }
      }).toList();
    });
  }

  void _removeTask(int taskId) {
    setState(() {
      this._tasks = this._tasks.where((task) => task.id != taskId).toList();
    });
  }
}
