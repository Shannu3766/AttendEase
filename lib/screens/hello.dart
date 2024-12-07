// @override
// Widget build(BuildContext context) {
//   String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Home Screen'),
//     ),
//     body: Center(
//       child: _isloading
//           ? CircularProgressIndicator()
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   label: Text('$formattedDate'),
//                   icon: Icon(Icons.calendar_month),
//                   onPressed: () async {
//                     await _selectDate(context);
//                     await fetchAttendanceForDay();
//                   },
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Divider(
//                     thickness: 2,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Expanded(
//                   child: day_sub.isNotEmpty
//                       ? ListView.builder(
//                           itemCount: day_sub.length,
//                           itemBuilder: (context, index) {
//                             return CheckboxListTile(
//                               title: Text(day_sub[index].subname),
//                               subtitle: Text(day_sub[index].subcode),
//                               value: selected_sub.contains(day_sub[index]),
//                               onChanged: (bool? isChecked) {
//                                 setState(() {
//                                   if (isChecked == true) {
//                                     selected_sub.add(day_sub[index]);
//                                   } else {
//                                     selected_sub.remove(day_sub[index]);
//                                   }
//                                 });
//                               },
//                             );
//                           },
//                         )
//                       : const Center(child: Text("No subjects available")),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     update_attendece();
//                   },
//                   child: Text('Update Attendance'),
//                 ),
//               ],
//             ),
//     ),
//   );
// }
