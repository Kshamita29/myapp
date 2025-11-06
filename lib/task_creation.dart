import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCreation extends StatefulWidget {
  const TaskCreation({super.key});

  @override
  State<TaskCreation> createState() => _TaskCreationState();
}

class _TaskCreationState extends State<TaskCreation> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desctiptionController = TextEditingController();
  bool isSwitched = false; // 👈 Current state
  void _showCustomRecurrenceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int repeatEvery = 1;
        String repeatUnit = "week";
        String endOption = "Never";
        DateTime? endDate;
        List<String> selectedDays = ["S"];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const Text(
                "Custom Recurrence",
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Repeat every
                    Row(
                      children: [
                        const Text(
                          "Repeats every ",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(isDense: true),
                            onChanged: (value) {
                              setState(() {
                                repeatEvery = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: repeatUnit,
                          items: ["day", "week", "month", "year"]
                              .map((unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              repeatUnit = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Repeat on (days)
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Repeats on",
                          style: TextStyle(color: Colors.white),
                        )),
                    Wrap(
                      spacing: 6,
                      children: ["S", "M", "T", "W", "T", "F", "S"].map((day) {
                        bool isSelected = selectedDays.contains(day);
                        return ChoiceChip(
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),

                    // Ends section
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ends",
                          style: TextStyle(color: Colors.white),
                        )),
                    RadioMenuButton(
                      value: "Never",
                      groupValue: endOption,
                      onChanged: (value) => setState(() => endOption = value!),
                      child: const Text("Never"),
                    ),
                    RadioMenuButton(
                      value: "On",
                      groupValue: endOption,
                      onChanged: (value) async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            endDate = picked;
                            endOption = "On";
                          });
                        }
                      },
                      child: const Text(
                        "On specific date",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (endDate != null)
                      Text(
                        DateFormat('MMM d, yyyy').format(endDate!),
                        style: TextStyle(color: Colors.white),
                      ),
                    RadioMenuButton(
                      value: "After",
                      groupValue: endOption,
                      onChanged: (value) => setState(() => endOption = value!),
                      child: const Text(
                        "After N occurrences",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedRepeat =
                          "Every $repeatEvery $repeatUnit(s), ends: $endOption";
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  DateTime selectedDate = DateTime.now();
  List<Map<String, String>> selectedPeople = [];

  String selectedRepeat = "Does not repeat";
  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, MMM d, yyyy').format(selectedDate);
    final formattedTime = DateFormat('hh:mm a').format(selectedDate);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          'Create Task',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white),
            child: Text('Save'),
          )
        ],
      ),
      body: SafeArea(
          child: Container(
        //   color: Colors.grey.shade900,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Colors.grey.shade800, // border color
            width: 1, // border thickness
          ),
        ),
        child: ListView(
          children: [
            // 🔹 Title
            ListTile(
              leading: const Icon(Icons.notes),
              title: TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notes),
              title: TextField(
                controller: _desctiptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              onTap: () {},
            ),
            const Divider(),

            ListTile(
              leading: Icon(Icons.alarm),
              //   tileColor: Colors.grey.shade900,
              title: GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        selectedDate.hour,
                        selectedDate.minute,
                      );
                    });
                  }
                },
                child: Text(
                  formattedDate,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDate),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                child: Text(
                  formattedTime,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text(
                'Daily Task',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: isSwitched,
                activeThumbColor: Colors.lightGreenAccent, // knob color
                activeTrackColor: Colors.lightGreenAccent.shade100.withAlpha(102), // track color
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade800,
                onChanged: (bool value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.repeat),
              title: Text(
                selectedRepeat,
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String? tempRepeat = selectedRepeat;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text(
                            "Repeat Options",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text(
                                  "Daily",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() => tempRepeat = "Daily");
                                  Navigator.pop(context);
                                  setState(() => selectedRepeat = tempRepeat!);
                                },
                              ),
                              ListTile(
                                title: const Text(
                                  "Once a week",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() => tempRepeat = "Once a week");
                                  Navigator.pop(context);
                                  setState(() => selectedRepeat = tempRepeat!);
                                },
                              ),
                              ListTile(
                                title: const Text(
                                  "Fortnight",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() => tempRepeat = "Fortnight");
                                  Navigator.pop(context);
                                  setState(() => selectedRepeat = tempRepeat!);
                                },
                              ),
                              ListTile(
                                title: const Text(
                                  "Monthly",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() => tempRepeat = "Monthly");
                                  Navigator.pop(context);
                                  setState(() => selectedRepeat = tempRepeat!);
                                },
                              ),
                              ListTile(
                                title: const Text(
                                  "Quarterly",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() => tempRepeat = "Quarterly");
                                  Navigator.pop(context);
                                  setState(() => selectedRepeat = tempRepeat!);
                                },
                              ),
                              const Divider(),
                              ListTile(
                                title: const Text(
                                  "Custom",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showCustomRecurrenceDialog();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const Divider(),
            // 🔹 Add People
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                "Add people",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black,
                        title: const Text(
                          "Selected People",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedPeople.length,
                            itemBuilder: (context, index) {
                              final person = selectedPeople[index];
                              return ListTile(
                                leading: Icon(Icons.person),
                                title: Text(
                                  person['name']!,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  person['department']!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Close",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "View Selected",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String? selectedName;
                    String? selectedDept;

                    List<String> names = [
                      'Alice',
                      'Alex',
                      'Bob',
                      'Charlie',
                      'David'
                    ];
                    List<String> departments = ['HR', 'Engineering', 'Design'];

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.grey.shade900,
                                width: 0.7), // 👈 Border
                            borderRadius:
                                BorderRadius.circular(20), // 👈 Rounded corners
                          ),
                          elevation: 5,
                          backgroundColor: Colors.black,
                          title: const Text(
                            "Add People",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return departments;
                                  }
                                  return departments.where((dept) => dept
                                      .toLowerCase()
                                      .startsWith(
                                          textEditingValue.text.toLowerCase()));
                                },
                                onSelected: (value) {
                                  setState(() {
                                    selectedDept = value;
                                  });
                                },
                                fieldViewBuilder: (context, controller,
                                    focusNode, onFieldSubmitted) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      labelText: "Type Department",
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return departments;
                                  }
                                  return departments.where((dept) => dept
                                      .toLowerCase()
                                      .startsWith(
                                          textEditingValue.text.toLowerCase()));
                                },
                                onSelected: (value) {
                                  setState(() {
                                    selectedDept = value;
                                  });
                                },
                                fieldViewBuilder: (context, controller,
                                    focusNode, onFieldSubmitted) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      labelText: "Type Role",
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return names;
                                  }
                                  return names.where((name) => name
                                      .toLowerCase()
                                      .startsWith(
                                          textEditingValue.text.toLowerCase()));
                                },
                                onSelected: (value) {
                                  setState(() {
                                    selectedName = value;
                                  });
                                },
                                fieldViewBuilder: (context, controller,
                                    focusNode, onFieldSubmitted) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      labelText: "Type Name",
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedName != null &&
                                    selectedDept != null) {
                                  setState(() {
                                    selectedPeople.add({
                                      'name': selectedName!,
                                      'department': selectedDept!,
                                    });
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                "Add",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            const Divider(),

            // 🔹 Notifications
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text(
                "30 minutes before",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Add notification",
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.close),
              onTap: () {},
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text(
                "Add Google Drive attachment",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      )),
    );
  }
}
