import 'package:flutter/material.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';
import 'package:taskmanager/ui/widgets/profile_app_bar.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/snack_bar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _desTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addTaskInprogress=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleTEController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter Title';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _desTEController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                    validator: (String? value){
                  if(value?.trim().isEmpty ?? true){
                    return 'Enter Description';
                  }
                  return null;
                }
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _addTask();
                      }
                    },
                    child: const Text('Add'),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addTask() async {
    _addTaskInprogress = true;
    if(mounted){
      setState(() {

      });
    }

    Map<String, dynamic> requestInput = {
      "title": _titleTEController.text.trim(),
      "description": _desTEController.text.trim(),
    };
    NetworkResponse response = await NetworkCaller.postRequest(Urls.createTask, body: requestInput);
    _addTaskInprogress = false;
    if(mounted){
      setState(() {

      });
    }
    print(response.statusCode);
    print(response.errorMessage);

    if(response.isSuccess){
      _clearTextField();
      if(mounted){
        showSnackBarMessage(context, 'Add New Task Added');
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, 'Add Task Failed');
      }
    }
  }

  void _clearTextField(){
    _titleTEController.clear();
    _desTEController.clear();
  }

  @override
  void dispose(){
    _titleTEController.dispose();
    _desTEController.dispose();
    super.dispose();
  }

}


