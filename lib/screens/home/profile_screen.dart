import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musikat_app/controllers/auth_controller.dart';
import 'package:musikat_app/models/user_model.dart';
import 'package:musikat_app/screens/home/account_info.dart';
import 'package:musikat_app/service_locators.dart';
import 'package:musikat_app/widgets/avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _auth = locator<AuthController>();

  UserModel? user;

  @override
  void initState() {
    UserModel.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff262525),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                profilePic(),
                userName(),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '-- \n FOLLOWERS',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '-- \n FOLLOWING',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 1.0,
                  indent: 1.0,
                ),
                ListTile(
                  leading: const Icon(Icons.queue_music,
                      color: Colors.white, size: 25),
                  title: Text(
                    'Playlists',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  indent: 1.0,
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.heart,
                      color: Colors.white, size: 25),
                  title: Text(
                    'Liked Songs',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  indent: 1.0,
                ),
                ListTile(
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const AccountInfoScreen()),
                    ),
                  },
                  leading: const Icon(Icons.account_box,
                      color: Colors.white, size: 25),
                  title: Text(
                    'Account info',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  indent: 1.0,
                ),
                ListTile(
                  leading:
                      const Icon(Icons.people, color: Colors.white, size: 25),
                  title: Text(
                    'Find friends',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  indent: 1.0,
                ),
                ListTile(
                  leading:
                      const Icon(Icons.info, color: Colors.white, size: 25),
                  title: Text(
                    'About us',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  indent: 1.0,
                ),
                ListTile(
                  onTap: () async {
                    _auth.logout();
                  },
                  leading:
                      const Icon(Icons.logout, color: Colors.white, size: 25),
                  title: Text(
                    'Log-out',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text userName() {
    return Text(user?.username ?? '...',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ));
  }

  Padding profilePic() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Stack(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: AvatarImage(uid: FirebaseAuth.instance.currentUser!.uid),
          ),
        ],
      ),
    );
  }
}