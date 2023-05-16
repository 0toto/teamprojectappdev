import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'deadlines page',
    home: DeadlinePage(),
  ));
}

class Deadline {
  final String name;
  final DateTime date;
  DeadlineStatus status;

  Deadline(
      {required this.name,
        required this.date,
        this.status = DeadlineStatus.NotStarted});
}

enum DeadlineStatus {
  NotStarted,
  InProgress,
  Done,
}

class DeadlinePage extends StatefulWidget {
  const DeadlinePage({Key? key}) : super(key: key);

  @override
  _DeadlinePageState createState() => _DeadlinePageState();
}

class _DeadlinePageState extends State<DeadlinePage> {
  int _currentIndex = 0;
  List<Deadline> deadlines = [];

  void addDeadline(String name, DateTime date) {
    setState(() {
      deadlines.add(Deadline(name: name, date: date));
    });
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
  }

  Widget buildDeadlineList() {
    return ListView.builder(
      itemCount: deadlines.length,
      itemBuilder: (context, index) {
        final deadline = deadlines[index];
        return DeadlineWidget(
          deadline: deadline,
          onDelete: () {
            setState(() {
              deadlines.removeAt(index);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.blue.shade100,
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text(
                'Deadlines',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(child: buildDeadlineList()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          String deadlineName = '';
          DateTime selectedDate = DateTime.now();

          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Deadline',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          deadlineName = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Deadline Name',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedDate = value;
                            });
                          }
                        });
                      },
                      child: Text('Select Date'),
                    ),
                    SizedBox(height: 10),
                    Text('Selected Date: ${formatDateTime(selectedDate)}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        addDeadline(deadlineName, selectedDate);
                        Navigator.pop(context);
                      },
                      child: Text('Add Deadline'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
          child: Icon(Icons.add),
        ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        child: SizedBox(
          height: 100,
          child: FloatingNavbar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue.shade700,
            borderRadius: 40,
            onTap: (int val) {
              setState(() {
                _currentIndex = val;
              });
            },
            currentIndex: _currentIndex,
            unselectedItemColor: Colors.grey,
            iconSize: 33,
            fontSize: 15,
            items: [
              FloatingNavbarItem(icon: Icons.home, title: 'Home'),
              FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
              FloatingNavbarItem(icon: Icons.settings, title: 'Setting'),
            ],
          ),
        ),
      ),
    );
  }
}
class DeadlineWidget extends StatefulWidget {
  final Deadline deadline;
  final Function() onDelete;

  const DeadlineWidget({
    required this.deadline,
    required this.onDelete,
  });

  @override
  _DeadlineWidgetState createState() => _DeadlineWidgetState();
}

class _DeadlineWidgetState extends State<DeadlineWidget> {
  void updateStatus(DeadlineStatus newStatus) {
    setState(() {
      widget.deadline.status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Text(
                  widget.deadline.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                  size: 16,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Date: ${formatDateTime(widget.deadline.date)}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 16,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Status: ${getStatusText(widget.deadline.status)}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<DeadlineStatus>(
              value: widget.deadline.status,
              onChanged: (newValue) {
                updateStatus(newValue!);
              },
              items: DeadlineStatus.values.map((status) {
                return DropdownMenuItem<DeadlineStatus>(
                  value: status,
                  child: Text(
                    getStatusText(status),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
              color: Colors.red,
            ),
          ],
        ),
        onTap: () {
          // TODO: Implement the onTap behavior if needed
        },
        onLongPress: () {
          // TODO: Implement the onLongPress behavior if needed
        },
      ),
    );
  }

  String getStatusText(DeadlineStatus status) {
    switch (status) {
      case DeadlineStatus.NotStarted:
        return 'Not Started';
      case DeadlineStatus.InProgress:
        return 'In Progress';
      case DeadlineStatus.Done:
        return 'Done';
      default:
        return '';
    }
  }
}






String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('yyyy-MM-dd HH:mm');
  return formatter.format(dateTime);
}