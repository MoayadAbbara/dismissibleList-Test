import 'package:dismissible_list/my_dialog.dart';
import 'package:flutter/material.dart';

class MyNewScreen extends StatefulWidget {
  const MyNewScreen({super.key, required this.title});

  final String title;

  @override
  State<MyNewScreen> createState() => _MyNewScreenState();
}

class _MyNewScreenState extends State<MyNewScreen> {
  List<Map<String, dynamic>> myItems = [
    {'name': 'Create Database', 'is_done': true},
    {'name': 'Design UI', 'is_done': true},
    {'name': 'Develop The App', 'is_done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text(widget.title), centerTitle: true),
      body: ReorderableListView.builder(
        itemCount: myItems.length,
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = myItems.removeAt(oldIndex);
            myItems.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final item = myItems[index];
          return Dismissible(
            key: Key(item['name']),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              // Show dialog and wait for user confirmation
              final result = await MyDialog.show(context: context, title: 'Confirm Delete', message: 'Are you sure you want to delete "${item['name']}"?');
              return result == true;
            },
            onDismissed: (direction) {
              setState(() {
                myItems.remove(item);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item['name']} deleted"),
                      InkWell(
                        onTap: () {
                          setState(() {
                            myItems.insert(index, item);
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        child: const Text(
                          'UNDO',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle, color: Colors.grey),
                ),
                trailing: Checkbox(
                  value: item['is_done'],
                  onChanged: (value) {
                    setState(() {
                      item['is_done'] = !item['is_done'];
                    });
                  },
                ),
                title: Text(item['name']),
                titleTextStyle: TextStyle(decoration: item['is_done'] ? TextDecoration.lineThrough : TextDecoration.none, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
