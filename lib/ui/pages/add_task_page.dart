import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = DateFormat("hh:mm a").format(DateTime.now().add(Duration(minutes: 5))).toString();
  int _selectRemind = 5;
  List<int> _remindList = [5, 10, 15, 20];
  String _selectRepeat = "None";
  List<String> _repeatList = ["None", "Daily", "Weekly", "Monthly"];

  int _selectedColor = 0;
  List<Color> _colorList = [k_primaryClr, k_pinkClr, k_orangeClr];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              Text("Add Task", style: k_headingStyle),
              InputField(
                title: "Title",
                hint: "Enter title",
                controller: _titleController,
              ),
              SizedBox(height: 15),
              InputField(
                title: "Note",
                hint: "Enter note",
                controller: _noteController,
              ),
              SizedBox(height: 15),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate).toString(),
                widget: IconButton(
                  onPressed: _getDateFromUser,
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: Icon(
                          Icons.alarm,
                          color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: Icon(
                          Icons.alarm,
                          color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              _remind(),
              SizedBox(height: 15),
              _repeat(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _selectColor(),
                    MyButton(
                      lable: "Create Task",
                      onTap: _validationData,
                      height: 60,
                      radius: 17,
                      width: 120,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _validationData() {
    if (_titleController.text.trim().isNotEmpty && _noteController.text.trim().isNotEmpty) {
      _submitData();
      Get.back();
    } else {
      //if(_titleController.text.trim().isEmpty)
      Get.snackbar(
        "Required",
        "Please Insert all field",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? k_primaryClr : k_orangeClr,
      );
    }
  }

  _submitData() async {
    String newDate = DateFormat.yMd().format(_selectedDate).toString();
    String newTitle = _titleController.text.toString();
    String newNote = _noteController.text.toString();

    int _value = await _taskController.addTask(
        task: Task(
      title: newTitle,
      note: newNote,
      date: newDate,
      isCompleted: 0,
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectRemind,
      repeat: _selectRepeat,
    ));
    print("value count = $_value \nIn _submitDate Function");
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2017),
      lastDate: DateTime(2040),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? TimeOfDay.fromDateTime((DateTime.now())) : TimeOfDay.fromDateTime((DateTime.now().add(Duration(minutes: 5)))),
    );

    if (_pickedTime != null && isStartTime) {
      String? _convertPickedTime = _pickedTime.format(context);
      setState(() {
        _startTime = _convertPickedTime;
      });
    }
    if (_pickedTime != null && !isStartTime) {
      String? _convertPickedTime = _pickedTime.format(context);

      setState(() {
        _endTime = _convertPickedTime;
      });
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios_new),
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/person.jpeg"),
          radius: 18,
        ),
        SizedBox(width: 15),
      ],
    );
  }

  Column _selectColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Color", style: k_titleStyle),
        SizedBox(height: 4),
        Wrap(
          spacing: 7,
          children: List<Widget>.generate(
            _colorList.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: CircleAvatar(
                child: index == _selectedColor ? Icon(Icons.done, size: 18, color: Colors.white) : null,
                backgroundColor: _colorList[index],
                radius: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputField _repeat() {
    return InputField(
      title: "Repeat",
      hint: _selectRepeat,
      widget: DropdownButton(
        items: List.generate(
          _repeatList.length,
          (index) => DropdownMenuItem<String>(
            value: _repeatList[index],
            child: Text(_repeatList[index].toString()),
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
        ),
        elevation: 4,
        onChanged: (String? value) {
          setState(() {
            _selectRepeat = value!;
          });
        },
        underline: Container(),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  InputField _remind() {
    return InputField(
      title: "Remind",
      hint: "${_selectRemind} minutes early",
      widget: DropdownButton(
        items: List.generate(
          _remindList.length,
          (index) => DropdownMenuItem<int>(
            value: _remindList[index],
            child: Text(_remindList[index].toString()),
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
        ),
        elevation: 4,
        onChanged: (int? value) {
          setState(() {
            _selectRemind = value!;
          });
        },
        underline: Container(),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
