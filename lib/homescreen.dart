import 'dart:convert';
import 'package:circular_progress_stack/circular_progress_stack.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Widget taskItem(String title, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.black : Colors.black,
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              color: done ? Colors.black : Colors.black,
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Move this helper function ABOVE the fetch method
    Color getPriorityColor(String priority) {
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

    Future<List<Map<String, dynamic>>> fetchTasks() async {
      final response = await http.get(
        Uri.parse(
          "https://legendary-fishstick-pq5vjj7945x36w4w-3000.app.github.dev/tasks",
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
                "color": getPriorityColor(task["priority"]),
              },
            )
            .toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hello 👋\nHrishi Chanchal!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.grey.shade900,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 5),
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.grey.shade900,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// AI Report Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: const LinearGradient(
                    colors: [Colors.pinkAccent, Colors.blueAccent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Text("12 Dec", style: TextStyle(color: Colors.white)),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Today's Tasks",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "You Have 5",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Tasks for Today",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Priority Task
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent.shade100,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Daily Task",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          taskItem("Design Assets Export", true),
                          taskItem("HR Catch-Up Call", false),
                          taskItem("Marketing Huddle", false),
                          taskItem("Onboarding Call", false),
                          taskItem("Wp Setup & Deliver", false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Stats
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Center(
                                    child:
                                        SingleAnimatedStackCircularProgressBar(
                                          isTextShow: false,
                                          size: 50,
                                          progressStrokeWidth: 5,
                                          backStrokeWidth: 5,
                                          startAngle: 0,
                                          backColor: Colors.black,
                                          barColor: Colors.pink,
                                          barValue: 30,
                                        ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "30%",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Completed",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: List.generate(
                                    8,
                                    (index) => Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        height: (index.isEven ? 30 : 20)
                                            .toDouble(),
                                        decoration: BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                size: 30,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "In Progress\n6 task",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// All Tasks
              Container(
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
                          child: Text(
                            "Assigned Task",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_outward, color: Colors.grey),
                        ),
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

          // Text(
          //   "⏰ ${task["time"]}",
          //   style: const TextStyle(color: Colors.grey, fontSize: 14),
          // ),
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
