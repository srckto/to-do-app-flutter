import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/pages/add_task_page.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Center(
        child: Column(
          children: [
            _dateAndDeleteButton(),
            _dateBar(),
            _showTasks(),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 5,
            color: k_primaryClr.withOpacity(0.5),
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: k_primaryClr,
          elevation: 0,
          onPressed: () async {
            await Get.to(() => AddTaskPage());
            _taskController.getTasks();
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/person.jpeg"),
          radius: 18,
        ),
        SizedBox(width: 15),
      ],
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      leading: IconButton(
        color: Get.isDarkMode ? Colors.white : Colors.black,
        icon: Get.isDarkMode ? Icon(Icons.wb_sunny_outlined) : Icon(Icons.mode_night_sharp),
        onPressed: () {
          ThemeServices().switchTheme();
          //NotifyHelper().displayNotification(title: "title", body: "body");
        },
      ),
    );
  }

  Container _dateAndDeleteButton() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${DateFormat.yMMMMd().format(DateTime.now())}",
                style: k_subHeadingStyle,
              ),
              Text("Today", style: k_headingStyle),
            ],
          ),
          MyButton(
            lable: "Delete All Task",
            width: 120,
            lableStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            onTap: () async {
              Get.dialog(
                AlertDialog(
                  title: Text("Are you sure to delete anything?"),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButton(
                        lable: "Apply",
                        onTap: () {
                          _taskController.deleteAllTask();
                          notifyHelper.deleteAllNotification();
                          Get.back();
                        },
                        color: Colors.red,
                        width: 120,
                      ),
                      MyButton(
                        lable: "Cancel",
                        onTap: () {
                          Get.back();
                        },
                        width: 120,
                        //color: Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Container _dateBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 65,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: k_primaryClr,
        deactivatedColor: Get.isDarkMode ? Colors.white : k_darkGreyClr,
        dayTextStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        dateTextStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        monthTextStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        onDateChange: (DateTime newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Expanded _showTasks() {
    return Expanded(
      child: Obx(
        () {
          // _taskController.tasks.isEmpty
          if (_taskController.tasks.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "images/task.svg",
                    height: 90,
                    semanticsLabel: "Task",
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text("You don't have any task yet.", style: k_titleStyle),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ListView.builder(
                itemCount: _taskController.tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  Task _selectTask = _taskController.tasks[index];
                  DateTime _parseDateFromTask = DateFormat.yMd().parse(_selectTask.date!);
                  String _day = DateFormat('EEEE').format(_parseDateFromTask);
                  if (((_selectTask.date == DateFormat.yMd().format(_selectedDate)) || _selectTask.repeat == "Daily") ||
                      ((DateFormat('EEEE').format(_selectedDate) == _day) && _selectTask.repeat == "Weekly") ||
                      (_selectTask.date!.split("/")[1] == _selectedDate.day.toString() && _selectTask.repeat == "Monthly")) {
                    DateTime date = DateFormat.jm().parse(_selectTask.startTime!);
                    String _time = DateFormat("HH:mm").format(date);
                    int _hours = int.parse(_time.split(":")[0]);
                    int _minutes = int.parse(_time.split(":")[1]);
                    notifyHelper.scheduledNotification(_hours, _minutes, _selectTask);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(context, _selectTask),
                        child: TaskTile(_selectTask),
                      ),
                    );
                  } else
                    return Container();
                },
              ),
            );
          }
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1 ? SizeConfig.screenHeight * 0.6 : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1 ? SizeConfig.screenHeight * 0.3 : SizeConfig.screenHeight * 0.39),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Get.isDarkMode ? k_darkHeaderClr : Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: 3),
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              if (task.isCompleted == 0)
                _bottomSheet(
                  label: "Task Complete",
                  onTap: () {
                    notifyHelper.deleteNotification(task.id!);
                    _taskController.taskComplete(task.id!);
                    Get.back();
                  },
                  color: k_primaryClr,
                ),
              _bottomSheet(
                label: "Delete Task",
                onTap: () {
                  notifyHelper.deleteNotification(task.id!);
                  _taskController.deleteTask(task);
                  Get.back();
                },
                color: Colors.red,
              ),
              Divider(color: Get.isDarkMode ? Colors.grey : k_darkGreyClr),
              _bottomSheet(
                label: "Cancel",
                onTap: () {
                  Get.back();
                },
                color: k_primaryClr,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  _bottomSheet({
    required String label,
    required Function() onTap,
    required Color color,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 60,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Get.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose ? k_titleStyle : k_titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
