import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/follow_manager.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/screens/profile/others_profile.dart';
import 'package:xenome/screens/profile/my_profile.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:xenome/models/trending.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/cover_image.dart';
import '../../models/setup_info.dart';
import '../../models/trending.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:xenome/utils/session_manager.dart';

class FilterPage extends StatefulWidget {
  FilterPage({this.id, this.type});
  final String id;
  final String type;

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  TextEditingController editingController = TextEditingController();
  String creatorUserName = '';
  String creatorUserAvatar = '';
  String creatorUserId = '';
  String followStatus = '';

  Trending xmapInfo;

  @override
  void initState() {
    super.initState();

    xmapInfo = new Trending(
        id: '',
        image: new CoverImageModel(imageURL: ''),
        title: new SetupInfo(title: ''),
        description: new SetupInfo(description: ''),
        uid: '');
    getFollowStatus();
    getCreatorInfo();
  }

  getFollowStatus() async {
    String _creatorUserId =
        await TrendingManager.getFeaturedUserId(widget.id, widget.type);
    String _followStatus = await FollowManager.getFollowStatus(_creatorUserId);
    setState(() {
      followStatus = _followStatus;
    });
  }

  getCreatorInfo() async {
    Trending _xmapInfo =
        await TrendingManager.getListFromID(widget.id, widget.type);
    setState(() {
      xmapInfo = _xmapInfo;
    });
    String _creatorUserId =
        await TrendingManager.getFeaturedUserId(widget.id, widget.type);
    setState(() {
      creatorUserId = _creatorUserId;
    });

    String _creatorUserAvatar =
        await TrendingManager.getAvatarImage(creatorUserId);
    setState(() {
      creatorUserAvatar = _creatorUserAvatar;
    });

    String _creatorUserName = await TrendingManager.getUserName(creatorUserId);
    setState(() {
      creatorUserName = _creatorUserName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              30, MediaQuery.of(context).size.height * 0.15, 30, 30),
          child: creatorUserName == ''
              ? Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'assets/icos/loader.gif',
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: RichText(
                        text: new TextSpan(
                          text: xmapInfo.title.title,
                          style: TextStyle(
                            fontFamily: 'Roboto Medium',
                            fontWeight: FontWeight.w600,
                            fontSize: 30.0,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: RichText(
                        text: new TextSpan(
                          text: xmapInfo.description.description,
                          style: TextStyle(
                            fontFamily: 'Roboto Medium',
                            fontWeight: FontWeight.w300,
                            fontSize: 22.0,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Row(children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (creatorUserId != SessionManager.getUserId()) {
                              Navigator.push(
                                  context,
                                  FadeRoute(
                                      page: OthersProfile(
                                    uid: creatorUserId,
                                  )));
                            } else {
                              Navigator.push(
                                  context, FadeRoute(page: MyProfile()));
                            }
                          },
                          child: creatorUserAvatar !=
                                  'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                              ? CircleAvatar(
                                  radius: 13,
                                  backgroundImage: NetworkImage(
                                    creatorUserAvatar,
                                  ),
                                )
                              : new CircleAvatar(
                                  radius: 13,
                                  child: CachedNetworkImage(
                                    imageUrl: creatorUserAvatar,
                                    placeholder:
                                        (BuildContext context, String url) =>
                                            Image.asset(
                                      'assets/icos/loader.gif',
                                      height: 13,
                                      width: 13,
                                      fit: BoxFit.cover,
                                    ),
                                    width: 13,
                                    height: 13,
                                    fit: BoxFit.fill,
                                  ),
                                  backgroundColor: Color(0xFF272D3A),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(creatorUserName,
                              style: TextStyle(
                                fontFamily: 'Roboto Medium',
                                fontSize: 14.0,
                                color: Color(0xFF868E9C),
                              )),
                        ),
                        creatorUserId != SessionManager.getUserId()
                            ? GestureDetector(
                                onTap: () async {
                                  if (SessionManager.getUserId() != '') {
                                    if (followStatus == "Follow") {
                                      await FollowManager.setFollowingOther(
                                          creatorUserId);

                                      setState(() {
                                        followStatus = "Unfollow";
                                      });
                                    } else {
                                      await FollowManager.delFollowingOther(
                                          creatorUserId);
                                      setState(() {
                                        followStatus = "Follow";
                                      });
                                    }
                                    print(followStatus);
                                  } else {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.6,
                                            child: Container(
                                              color: Color(0xFF737373),
                                              height: 500,
                                              child: Container(
                                                child: BottomSheetWidget(),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                                child: Text(
                                  followStatus,
                                  style: TextStyle(
                                    fontFamily: 'Roboto Medium',
                                    fontSize: 14.0,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              )
                            : Container(),
                      ]),
                    ),
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    //   width: 300,
                    //   decoration: new BoxDecoration(
                    //     color: Colors.black,
                    //     borderRadius: new BorderRadius.circular(10.0),
                    //     border: Border.all(width: 0.5, color: Color(0xFF868E9C)),
                    //   ),
                    //   child: TextFormField(
                    //     style: TextStyle(
                    //       fontFamily: 'Roboto Reqular',
                    //       fontSize: 16,
                    //       color: Color(0xFF868E9C),
                    //     ),
                    //     onChanged: (value) {
                    //       // filterSearchResults(value);
                    //     },
                    //     controller: editingController,
                    //     decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.white, width: 1.0),
                    //       ),

                    //       // labelText: 'Filter by keyword',
                    //       hintText: 'Filter by keyword',
                    //       hintStyle: TextStyle(
                    //         color: Color(0xFF868E9C),
                    //       ),
                    //       prefixIcon: Padding(
                    //         padding: const EdgeInsetsDirectional.only(start: 12.0),
                    //         child: IconTheme(
                    //           data: new IconThemeData(color: Color(0xFF868E9C)),
                    //           child: new Icon(Icons.search),
                    //         ), // myIcon is a 48px-wide widget.
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: 210,
                    //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //   margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemExtent: 35.0,
                    //       itemCount: items.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return ListTile(
                    //             contentPadding: EdgeInsets.only(left: 0),
                    //             title: index > 0
                    //                 ? Text(
                    //                     items[index],
                    //                     style: TextStyle(
                    //                       fontFamily: 'Roboto Medium',
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 16.0,
                    //                       color: Color(0xFF868E9C),
                    //                     ),
                    //                   )
                    //                 : null,
                    //             onTap: () {
                    //               // setState(() {
                    //               //   List temp2 = ["FilterPage"];
                    //               //   temp2.add(items[index]);
                    //               //   items.clear();
                    //               //   items.addAll(temp2);

                    //               // });
                    //             });
                    //       }),
                    // )
                  ],
                ),
        ));
  }
}
