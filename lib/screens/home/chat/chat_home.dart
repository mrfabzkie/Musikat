import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musikat_app/controllers/individual_chat_controller.dart';
import 'package:musikat_app/controllers/navigation/navigation_service.dart';
import 'package:musikat_app/models/chat_message_model.dart';
import 'package:musikat_app/models/user_model.dart';
import 'package:musikat_app/screens/home/chat/global_chat.dart';
import 'package:musikat_app/screens/home/chat/private_chat.dart';
import 'package:musikat_app/utils/exports.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final IndividualChatController _chatController = IndividualChatController();
  ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
          if (!snap.hasData) {
            return const Center(child: LoadingIndicator());
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: musikatBackgroundColor,
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Messages',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    globalChat(context),
                    chatList(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  StreamBuilder<List<UserModel>> chatList() {
    return StreamBuilder<List<UserModel>>(
        stream: _chatController.fetchChatroomsStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: LoadingIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.length == 0) {
            return const Center(
              child: Text(
                'No messages yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            // Rest of your code for displaying the chat list

            return snapshot.data!.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    children: [
                      for (UserModel user in snapshot.data)
                        if (user.uid != FirebaseAuth.instance.currentUser!.uid)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              onTap: () => {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PrivateChatScreen(
                                        selectedUserUID: user.uid),
                                  ),
                                )
                              },
                              leading: AvatarImage(
                                uid: user.uid,
                                radius: 18,
                              ),
                              title: Text(
                                user.username,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                    ],
                  );
          }
        });
  }

  Padding globalChat(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        onTap: () => {
          Navigator.of(context).push(
            FadeRoute(
              page: const GlobalChatScreen(),
              settings: const RouteSettings(),
            ),
          )
        },
        leading: FittedBox(
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.transparent,
            child: Image.asset("assets/images/musikat_global.png"),
          ),
        ),
        title: Text(
          "Global Chat",
          style: GoogleFonts.inter(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
