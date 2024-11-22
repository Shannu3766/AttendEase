import 'package:flutter/material.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<String> days = ['M', 'T', 'W', 'T', 'F', 'S'];
//   int selectedIndex = 2; // Default selected day (Wednesday)
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(169, 216, 243, 1),
//         title: Text(
//           "AttendEase",
//           style: GoogleFonts.pacifico(
//             fontSize: 33,
//           ),
//         ),
//         actions: [
//           ElevatedButton.icon(
//             onPressed: () {},
//             label: Text("Logout"),
//             icon: Icon(Icons.exit_to_app),
//           )
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(colors: [
//             Color.fromRGBO(169, 216, 243, 1),
//             Color.fromARGB(255, 255, 255, 255)
//           ], begin: Alignment.topLeft, end: Alignment.bottomRight),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Choose a day",
//                 style: GoogleFonts.assistant(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 37.33,
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(days.length, (index) {
//                   bool isSelected = index == selectedIndex;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                     },
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 8),
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.black : Colors.white,
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 1,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           days[index],
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.05,
//               ),
//               Divider(
//                 color: Colors.black,
//                 thickness: 2.0,
//                 endIndent: MediaQuery.of(context).size.width * 0.05,
//                 indent: MediaQuery.of(context).size.width * 0.05,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class DaySelectorWithSubjects extends StatefulWidget {
  const DaySelectorWithSubjects({super.key});

  @override
  _DaySelectorWithSubjectsState createState() =>
      _DaySelectorWithSubjectsState();
}

class _DaySelectorWithSubjectsState extends State<DaySelectorWithSubjects> {
  List<String> days = ['M', 'T', 'W', 'T', 'F', 'S'];
  int selectedIndex = 2; // Default selected day (Wednesday)
  List<TextEditingController> controllers = [
    TextEditingController()
  ]; // Default one subject

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Day'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Day Selector
            const Text(
              "Choose a day",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    width: 50,
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
            // Subject Fields
            Expanded(
              child: ListView.builder(
                itemCount: controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.drag_handle, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controllers[index],
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
                              controllers.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    ),
                  );
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
                      controllers.add(TextEditingController());
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
                    List<String> subjects =
                        controllers.map((c) => c.text).toList();
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
