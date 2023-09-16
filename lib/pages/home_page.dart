import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/custom_search_delegate.dart';
import 'package:to_do_app/widgets/task_list_item.dart';
import 'package:to_do_app/helper/translations_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _tumGorevler;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _tumGorevler = <Task>[];
    getAllTasksFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _gorevEkleCubugunuGoster();
          },
          child: const Text(
            'title',
            style: TextStyle(fontFamily: 'Roboto'),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _gorevEkleCubugunuGoster();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _tumGorevler.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var oAnkiListedeYerlesdenEleman = _tumGorevler[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // ignore: prefer_const_constructors
                      Text('remove_task').tr(),
                    ],
                  ),
                  key: Key(oAnkiListedeYerlesdenEleman.id),
                  onDismissed: (direction) {
                    _tumGorevler.removeAt(index);
                    _localStorage.deleteTask(task: oAnkiListedeYerlesdenEleman);
                    setState(() {});
                  },
                  child: TaskItem(task: oAnkiListedeYerlesdenEleman),
                );
              },
              itemCount: _tumGorevler.length,
            )
          : Center(
              child: GestureDetector(
                  onTap: () {
                    _gorevEkleCubugunuGoster();
                  },
                  // ignore: prefer_const_constructors
                  child: Text(
                    'empty_task_list',
                    style: const TextStyle(fontSize: 20),
                  ).tr()),
            ),
    );
  }

  void _gorevEkleCubugunuGoster() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'you_have_to_must_works'.tr(),
                  border: InputBorder.none),
              onSubmitted: (deger) {
                Navigator.of(context).pop();
                if (deger.length > 3) {
                  DatePicker.showTimePicker(context,
                      showSecondsColumn: false,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      onConfirm: (time) async {
                    var yeniEklenecekTask =
                        Task.create(name: deger, createdAt: time);
                    // _tumGorevler.add(yeniEklenecekTask);
                    _tumGorevler.insert(0, yeniEklenecekTask);
                    await _localStorage.addTask(task: yeniEklenecekTask);
                    setState(() {});
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  void getAllTasksFromDb() async {
    _tumGorevler = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() {
    showSearch(
        context: context,
        delegate: CustomSearchDelegate(allTasks: _tumGorevler));
    getAllTasksFromDb();
  }
}
