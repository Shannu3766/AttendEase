import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reorderables/reorderables.dart';

class DaySelectorWithSubjects extends StatefulWidget {
  const DaySelectorWithSubjects({super.key});

  @override
  _DaySelectorWithSubjectsState createState() =>
      _DaySelectorWithSubjectsState();
}

class _DaySelectorWithSubjectsState extends State<DaySelectorWithSubjects> {
  List<String> days = ['M', 'T', 'W', 'T', 'F', 'S'];
  int selectedIndex = 2; // Default selected day (Wednesday)

  // Each day will have its own list of subjects
  Map<int, List<TextEditingController>> dayControllers = {
    for (int i = 0; i < 6; i++) i: [TextEditingController()]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AttendEase",
          style: GoogleFonts.pacifico(
            fontSize: 33,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Day Selector
            Text(
              "Choose a day",
              style: GoogleFonts.assistant(
                  fontWeight: FontWeight.bold, fontSize: 37.33),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(days.length, (index) {
                bool isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        days[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Animated Subject Fields
            Expanded(
              child: ReorderableColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  dayControllers[selectedIndex]!.length,
                  (index) {
                    return Padding(
                      key: ValueKey(index),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.drag_handle, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: dayControllers[selectedIndex]![index],
                              decoration: InputDecoration(
                                hintText: "Subject Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                dayControllers[selectedIndex]!.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item =
                        dayControllers[selectedIndex]!.removeAt(oldIndex);
                    dayControllers[selectedIndex]!.insert(newIndex, item);
                  });
                },
              ),
            ),
            // Add and Save Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      dayControllers[selectedIndex]!
                          .add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Sub"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Save Logic (e.g., save entered subjects)
                    List<String> subjects = dayControllers[selectedIndex]!
                        .map((c) => c.text)
                        .toList();
                    print("Selected Day: ${days[selectedIndex]}");
                    print("Subjects: $subjects");
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
