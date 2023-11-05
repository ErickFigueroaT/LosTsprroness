import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:flutter/material.dart';

class ChecklistItemWidget extends StatefulWidget {
  final Pertenencia item;
  final Function(bool) onChanged;

   ChecklistItemWidget({
    required this.item,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _ChecklistItemWidgetState createState() => _ChecklistItemWidgetState();
}

class _ChecklistItemWidgetState extends State<ChecklistItemWidget> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = false;
    widget.item.status = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8.0),
      title: Text(widget.item.nombre),
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