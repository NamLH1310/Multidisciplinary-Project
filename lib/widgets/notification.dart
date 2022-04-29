import 'package:flutter/material.dart';
import 'package:multidisciplinary_project_se/utils/global.dart';

class DashBoardNotification extends StatefulWidget {
  const DashBoardNotification({Key? key}) : super(key: key);

  @override
  State<DashBoardNotification> createState() => _DashBoardNotificationState();
}

class _DashBoardNotificationState extends State<DashBoardNotification> {
  List<String> messageList = [];
  bool hasNewMsg = false;
  @override
  void initState() {
    firestore.collection("notifications").get().then(
          (value) => {
            for (var ds in value.docs) {ds.reference.delete()}
          },
        );
    firestore
        .collection("notifications")
        .orderBy('createAt', descending: true)
        .limit(4)
        .snapshots()
        .listen((event) {
      hasNewMsg = true;
      for (var doc in event.docs) {
        messageList.add(doc.data()["message"]);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: PopupMenuButton(
        itemBuilder: (context) {
          return getMessageList();
        },
        icon: Icon(
          hasNewMsg ? Icons.notification_important : Icons.notifications,
        ),
        onCanceled: () {
          messageList.clear();
          setState(() {});
        },
      ),
    );
  }

  List<PopupMenuItem<int>> getMessageList() {
    List<PopupMenuItem<int>> widgetList = [];
    for (var i = 0; i < messageList.length; i++) {
      widgetList.add(PopupMenuItem(
        child: Text(messageList[i]),
        value: i,
      ));
    }
    return widgetList;
  }
}
