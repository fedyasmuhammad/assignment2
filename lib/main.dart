import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  final ThemeController themeController = Get.put(ThemeController());

  runApp(
    Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,

          // ✅ THIS IS REQUIRED
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,

          home: SplashScreen(),
        )),
  );
}

// ============ THEME CONTROLLER ============
class ThemeController extends GetxController {
 
 
  var isDark = false.obs;

 void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
  }
}

// ============ SPLASH SCREEN ============
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => Task_Manager());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 201, 121, 0),
              Color.fromARGB(255, 255, 153, 0),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt,
                          size: 100, color: Colors.white),
                      SizedBox(height: 20),
                      Text("Task Manager",
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      CircularProgressIndicator(color: Colors.white),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}









// ============ TASK Manager ============
class TaskController extends GetxController {
  var tasks = [].obs;

  void addTask(String title, String description) {
    tasks.add({'title': title, 'description': description});
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }
}








// ============ TASK MANAGER ============
class Task_Manager extends StatelessWidget {
  const Task_Manager({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.put(TaskController());
    final ThemeController themeController = Get.find();

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text("Task Manager Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 201, 121, 0),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              themeController.isDark.value
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              print("Theme toggled! Current: ${themeController.isDark.value}");
              themeController.toggleTheme();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.tasks.isEmpty) {
          return Center(child: Text("No Tasks Yetttttttttttttttttt"));
        }

        
        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (_, index) {
            final task = controller.tasks[index];
            return Card(
              child: ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteTask(index),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () => Get.to(() => Add_Task()),
      ),
    ),
    );
  }
}










// ============ ADD TASK ============
class Add_Task extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();
    final title = TextEditingController();
    final desc = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Taskkkkkkkkkk"),
        backgroundColor: Color.fromARGB(255, 201, 121, 0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
               maxLines: 2,
              controller: title,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.orange),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: desc,
               maxLines: 7,
              decoration: InputDecoration(
               
                labelText: "Description",
                
                labelStyle: TextStyle(color: Colors.orange),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
  if (title.text.isNotEmpty) {
     controller.addTask(title.text, desc.text);
    Get.back();
     Get.snackbar(
      
      "sucsufuly",                 // title
      "Task added sucsufuly ",   // message
      backgroundColor: const Color.fromARGB(255, 9, 153, 48),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
   
  } else {
    Get.snackbar(
      "Warning",                 // title
      "Title cannot be empty",   // message
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
},
              child: Text("Add Task", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}