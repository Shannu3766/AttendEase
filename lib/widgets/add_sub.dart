import 'package:flutter/material.dart';


class AddSub extends StatefulWidget {
  @override
  _AddSubState createState() => _AddSubState();
}

class _AddSubState extends State<AddSub> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  var new_subject = "";
  List<String> subjects = [];
  void addsubject() {
    if (_controller.text.isNotEmpty) {
      new_subject = _controller.text;
      // print(new_subject);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(new_subject)));
      _controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Center(
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Add Subject",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a subject";
                }
                return null;
              },
              onSaved: (value) {
                new_subject = value!;
              },
            )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  addsubject();
                },
                icon: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
