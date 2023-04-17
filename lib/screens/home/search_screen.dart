import 'package:firebase_auth/firebase_auth.dart';
import 'package:musikat_app/models/user_model.dart';
import 'package:musikat_app/screens/home/categories_screen.dart';
import 'package:musikat_app/screens/home/other_artist_screen.dart';
import 'package:musikat_app/utils/ui_exports.dart';
import 'package:musikat_app/utils/widgets_export.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textCon = TextEditingController();
  Future<List<UserModel>>? getUsers;

  @override
  void dispose() {
    _textCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUsers ??= UserModel.getUsers();

    return SafeArea(
      child: Scaffold(
        appBar: appbar(context),
        backgroundColor: musikatBackgroundColor,
        body: SizedBox(
          child: FutureBuilder<List<UserModel>>(
              future: getUsers,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                List<UserModel> searchResult = [];
                if (_textCon.text.isNotEmpty) {
                  for (var element in snapshot.data!) {
                    if (element.searchUsername(_textCon.text)) {
                      searchResult.add(element);
                    }
                  }

                  return searchResult.isEmpty
                      ? Center(
                          child: Text('No results found',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.white.withOpacity(0.2),
                                thickness: 0,
                              ),
                          itemCount: searchResult.length,
                          itemBuilder: (context, index) {
                            return searchResult[index].uid !=
                                    FirebaseAuth.instance.currentUser?.uid
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ArtistsProfileScreen(
                                                    selectedUserUID:
                                                        searchResult[index]
                                                            .uid)),
                                      );
                                    },
                                    leading: AvatarImage(
                                        uid: searchResult[index].uid),
                                    title: Text(
                                      searchResult[index].username,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    subtitle: null,
                                  )
                                : const SizedBox();
                          });
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 150),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/search.png",
                          width: 254,
                          height: 254,
                        ),
                        Text('Search for your favourite music or your friends',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      title: TextField(
        autofocus: true,
        controller: _textCon,
        onSubmitted: (textCon) {},
        onChanged: (text) {
          setState(() {});
          // if (text) print(text);
        },
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
        // ignore: prefer_const_constructors
        decoration: InputDecoration(
          hintText: 'Search',

          border: InputBorder.none,
          // ignore: prefer_const_constructors
          hintStyle: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.angleLeft,
          size: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CategoriesScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.category,
            size: 20,
          ),
        ),
      ],
    );
  }
}
