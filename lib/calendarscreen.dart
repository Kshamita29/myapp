import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Calendarscreen extends StatefulWidget {
  const Calendarscreen({super.key});

  @override
  State<Calendarscreen> createState() => _CalendarscreenState();
}

class _CalendarscreenState extends State<Calendarscreen> {
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.lightGreenAccent;
      case "Medium":
        return Colors.tealAccent;
      case "Low":
        return Colors.amberAccent;
      default:
        return Colors.grey;
    }
  }

  DateTime selectedDate = DateTime.now();
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(
      Uri.parse(
        'https://legendary-fishstick-pq5vjj7945x36w4w-3000.app.github.dev/api/tasks',
      ),
    ); // 👈 Replace with your actual API URL

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map(
            (task) => {
              "priority": task["priority"],
              "title": task["title"],
              "time": task["time"],
              "meet": task["meet"],
              "due": task["due"],
              "color": _getPriorityColor(task["priority"]),
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Upcomming",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                          ), // adjust value as needed
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "All Task",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(
                        //       Icons.arrow_outward,
                        //       color: Colors.grey,
                        //     ))
                      ],
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchTasks(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No tasks found'));
                        }

                        final tasks = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: tasks.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return _buildTaskCard(task);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Priority Chip
          Row(
            children: [
              Chip(
                label: Text(
                  task["priority"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: task["priority"] == "High"
                    ? Colors.pink
                    : Colors.teal,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: -2,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const Spacer(),
              Text(
                task["meet"] ?? "",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 Task Title
          Text(
            task["title"],
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // 🔹 Time Row
          Row(
            children: [
              Icon(Icons.access_alarm_rounded, color: Colors.grey.shade100),
              SizedBox(width: 5),
              Text(
                "${task["time"]}",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 🔹 Due Date + Avatars Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (task["due"] != null)
                Text(
                  "Due Date: ${task["due"]}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              Row(
                children: const [
                  CircleAvatar(radius: 14, backgroundColor: Colors.grey),
                  SizedBox(width: 4),
                  CircleAvatar(radius: 14, backgroundColor: Colors.grey),
                  SizedBox(width: 4),
                  CircleAvatar(radius: 14, backgroundColor: Colors.grey),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
