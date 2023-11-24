//import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:flutter/material.dart';

class ChecklistLabelWidget extends StatefulWidget {
  final String item;
  final List<String> labels;
  final Function(bool) onChanged;

   ChecklistLabelWidget({
    required this.item,
    required this.onChanged,
    required this.labels,
    Key? key,
  }) : super(key: key);

  @override
  _ChecklistLabelWidgetState createState() => _ChecklistLabelWidgetState();
}

class _ChecklistLabelWidgetState extends State<ChecklistLabelWidget> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.labels.contains(widget.item);
    //widget.item.status = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8.0),
      title: Text(widget.item),
      trailing: Checkbox(
        value: isChecked,
        onChanged: (bool? newValue) {
          setState(() {
            isChecked = newValue ?? false;
            widget.onChanged(isChecked); // Notify parent about the change
          });
        },
      ),
    );
  }
}