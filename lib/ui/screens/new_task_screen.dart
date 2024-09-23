import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:taskmanager/data/models/task_list_wrapper_model.dart';
import 'package:taskmanager/ui/screens/add_new_task_screen.dart';
import 'package:taskmanager/ui/utility/app.colors.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/network_cached_image.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_items.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getTaskInprogress = false;
  List<TaskModel> newTaskList = [];

  @override
  void initState() {
    super.initState();
    _getNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
                child: ListView.builder(
                  itemCount: newTaskList.length,
                    itemBuilder: (context, index){
                      return TaskItems(
                        taskModel: newTaskList[index],
                      );
                    }
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        onPressed: _onTapAddButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapAddButton(){
       Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) => const AddNewTaskScreen(),)
       );
  }

  Widget _buildSummarySection() {
    return const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TashSummaryCard(
                title: 'New Task',
                count: '5',
              ),
              TashSummaryCard(
                title: 'Completed',
                count: '2',
              ),
              TashSummaryCard(
                title: 'In Progress',
                count: '1',
              ),
              TashSummaryCard(
                title: 'Canceled',
                count: '1',
              ),
            ],
          ),
        );
  }
  Future<void> _getNewTasks() async {
    _getTaskInprogress = true;
    if(mounted){
      setState(() {

      });
    }

    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);

    print(response.statusCode);
    print(response.errorMessage);

    if(response.isSuccess){
       TaskListWrapperModel taskListWrapperModel =
           TaskListWrapperModel.fromJson(response.responseData);
       newTaskList = taskListWrapperModel.taskModel ?? [];

    }else{
      if(mounted){
        showSnackBarMessage(context, ' Task List Failed');
      }
    }

    _getTaskInprogress = false;
    if(mounted){
      setState(() {

      });
    }

  }

}



class TashSummaryCard extends StatelessWidget {
  const TashSummaryCard({
    super.key, required this.title, required this.count,
  });

  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(count, style: Theme.of(context).textTheme.titleLarge),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}


