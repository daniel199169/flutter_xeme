import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/buildder.dart';
import 'package:xenome/models/comment.dart';
import 'package:xenome/models/text_part.dart';
import 'package:xenome/models/youtube.dart';
import 'package:xenome/models/vimeo.dart';
import 'package:xenome/models/quadTitle.dart';
import 'package:xenome/models/scaleTitle.dart';
import 'package:xenome/models/instagram.dart';
import 'package:xenome/models/circleposition.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/models/styled_scale.dart';
import 'package:xenome/models/chartCirclePosition.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/page_order.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/models/image.dart';
import 'package:xenome/models/quad_chart.dart';
import 'basic_firebase.dart';

class BuildderManager {
  static Future<void> add(Buildder builder) async {
    await db.collection('Buildder').add(builder.toJson());
  }

  static Future<Buildder> getData(String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot.documents.length != 0) {
      Buildder _buildder = Buildder.fromJson(querySnapshot.documents[0].data);
      return _buildder;
    } else {
      return null;
    }
  }

  static getXmapIDForDynammicLink(
      String type, String uid, String dynalink) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('dynamiclink', isEqualTo: dynalink)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot.documents[0]['id'] == null) {
      return null;
    } else {
      return querySnapshot.documents[0]['id'];
    }
  }

  static getDynammicLink(String type, String uid, String id) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot.documents[0]['dynamiclink'] == null) {
      return '';
    } else {
      return querySnapshot.documents[0]['dynamiclink'];
    }
  }

  static Future<CoverImageModel> checkCoverImage(
      String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot.documents[0]['cover_image'] == null) {
      return null;
    } else {
      CoverImageModel _coverImage =
          CoverImageModel.fromJson(querySnapshot.documents[0]['cover_image']);
      return _coverImage;
    }
  }

  static Future<SetupInfo> getSetupInfo(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot.documents[0]['SetupInfo'] == null) {
      SetupInfo _initSetupInfo = new SetupInfo(
          title: '', description: '', global: '', privateEmailList: '');
      querySnapshot.documents[0].reference
          .updateData({'SetupInfo': _initSetupInfo.toJson()});

      return _initSetupInfo;
    } else {
      SetupInfo _result =
          SetupInfo.fromJson(querySnapshot.documents[0]['SetupInfo']);
      return _result;
    }
  }

  static addSectionPage(String id, String type, String pageName) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (pageName == 'Image') {
      ImageModel _initMyImage = new ImageModel(
          imageURL: '', link: '', description: '', tag: '', reference: '');
      if (querySnapshot.documents[0]['my_image'] == null ||
          querySnapshot.documents[0]['my_image'].length == 0) {
        List _listInitMyImage = [];
        _listInitMyImage.add(_initMyImage.toJson());
        querySnapshot.documents[0].reference
            .updateData({'my_image': _listInitMyImage});
      } else {
        var list = querySnapshot.documents[0]['my_image'].toList();
        list.add(_initMyImage.toJson());
        querySnapshot.documents[0].reference.updateData({'my_image': list});
      }
    }
    if (pageName == 'Text') {
      TextPartModel _initTextPart = new TextPartModel(
          title: '', text: '', description: '', tag: '', reference: '');
      if (querySnapshot.documents[0]['text_part'] == null ||
          querySnapshot.documents[0]['text_part'].length == 0) {
        List _listInitTextPart = [];
        _listInitTextPart.add(_initTextPart.toJson());
        querySnapshot.documents[0].reference
            .updateData({'text_part': _listInitTextPart});
      } else {
        var list = querySnapshot.documents[0]['text_part'].toList();
        list.add(_initTextPart.toJson());
        querySnapshot.documents[0].reference.updateData({'text_part': list});
      }
    }
    if (pageName == 'YouTube') {
      YoutubeModel _initYouTube = new YoutubeModel(
          image: '',
          title: '',
          youtubeURL: '',
          description: '',
          tag: '',
          reference: '');
      if (querySnapshot.documents[0]['youtube'] == null ||
          querySnapshot.documents[0]['youtube'].length == 0) {
        List _listInitYouTube = [];

        _listInitYouTube.add(_initYouTube.toJson());

        querySnapshot.documents[0].reference
            .updateData({'youtube': _listInitYouTube});
      } else {
        var list = querySnapshot.documents[0]['youtube'].toList();
        list.add(_initYouTube.toJson());
        querySnapshot.documents[0].reference.updateData({'youtube': list});
      }
    }
    if (pageName == 'Quad chart') {
      CirclePosition _initQuadCirclePosition = new CirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        subOrder: '0',
      );
      ChartCirclePosition _initQuadHeatmap = new ChartCirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        minOpacity: 0.01,
        subOrder: '0',
      );
      QuadTitleModel _initTitle = new QuadTitleModel(
          title: "",
          color: "",
          labelOne: "",
          labelTwo: "",
          labelThree: "",
          labelFour: "",
          description: "",
          tag: "",
          reference: "");
      if (querySnapshot.documents[0]['quad_heatmap'] == null ||
          querySnapshot.documents[0]['quad_heatmap'].length == 0) {
        List _listInitQuadHeatmap = [];
        _listInitQuadHeatmap.add(_initQuadHeatmap.toJson());
        querySnapshot.documents[0].reference
            .updateData({'quad_heatmap': _listInitQuadHeatmap});
      }
      if (querySnapshot.documents[0]['quad_circle_position'] == null ||
          querySnapshot.documents[0]['quad_circle_position'].length == 0) {
        List _listInitQuadCirclePosition = [];
        _listInitQuadCirclePosition.add(_initQuadCirclePosition.toJson());
        querySnapshot.documents[0].reference
            .updateData({'quad_circle_position': _listInitQuadCirclePosition});
      }
      if (querySnapshot.documents[0]['quad_title'] == null ||
          querySnapshot.documents[0]['quad_title'].length == 0) {
        // init quad_chart
        List _listInitTitle = [];
        _listInitTitle.add(_initTitle.toJson());
        querySnapshot.documents[0].reference
            .updateData({'quad_title': _listInitTitle});
      } else {
        var list = querySnapshot.documents[0]['quad_title'].toList();
        list.add(_initTitle.toJson());
        querySnapshot.documents[0].reference.updateData({'quad_title': list});
      }
    }
    if (pageName == 'Scale chart') {
      ChartCirclePosition _initScaleHeatmap = new ChartCirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        minOpacity: 0.01,
        subOrder: '0',
      );
      CirclePosition _initScaleCirclePosition = new CirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        subOrder: '0',
      );
      ScaleTitleModel _initScaleTitle = new ScaleTitleModel(
          title: "",
          color: "",
          labelOne: "",
          labelTwo: "",
          description: "",
          tag: "",
          reference: "");
      if (querySnapshot.documents[0]['scale_heatmap'] == null ||
          querySnapshot.documents[0]['scale_heatmap'].length == 0) {
        List _listInitScaleHeatmap = [];
        _listInitScaleHeatmap.add(_initScaleHeatmap.toJson());
        querySnapshot.documents[0].reference
            .updateData({'scale_heatmap': _listInitScaleHeatmap});
      }
      if (querySnapshot.documents[0]['scale_circle_position'] == null ||
          querySnapshot.documents[0]['scale_circle_position'].length == 0) {
        List _listInitScaleCirclePosition = [];
        _listInitScaleCirclePosition.add(_initScaleCirclePosition.toJson());
        querySnapshot.documents[0].reference.updateData(
            {'scale_circle_position': _listInitScaleCirclePosition});
      }
      if (querySnapshot.documents[0]['scale_title'] == null ||
          querySnapshot.documents[0]['scale_title'].length == 0) {
        // init scale_chart
        List _listInitScaleTitle = [];
        _listInitScaleTitle.add(_initScaleTitle.toJson());
        querySnapshot.documents[0].reference
            .updateData({'scale_title': _listInitScaleTitle});
      } else {
        var list = querySnapshot.documents[0]['scale_title'].toList();
        list.add(_initScaleTitle.toJson());
        querySnapshot.documents[0].reference.updateData({'scale_title': list});
      }
    }
    if (pageName == 'Vimeo') {
      VimeoModel _initVimeo = new VimeoModel(
          image: '',
          title: '',
          vimeoURL: '',
          description: '',
          tag: '',
          reference: '');
      if (querySnapshot.documents[0]['vimeo'] == null ||
          querySnapshot.documents[0]['vimeo'].length == 0) {
        List _listInitVimeo = [];

        _listInitVimeo.add(_initVimeo.toJson());

        querySnapshot.documents[0].reference
            .updateData({'vimeo': _listInitVimeo});
      } else {
        var list = querySnapshot.documents[0]['vimeo'].toList();
        list.add(_initVimeo.toJson());
        querySnapshot.documents[0].reference.updateData({'vimeo': list});
      }
    }
    if (pageName == 'Instagram') {
      InstagramModel _initInstagram = new InstagramModel(
          title: '', instagramURL: '', description: '', tag: '', reference: '');
      if (querySnapshot.documents[0]['instagram'] == null ||
          querySnapshot.documents[0]['instagram'].length == 0) {
        List _listInitInstagram = [];

        _listInitInstagram.add(_initInstagram.toJson());

        querySnapshot.documents[0].reference
            .updateData({'instagram': _listInitInstagram});
      } else {
        var list = querySnapshot.documents[0]['instagram'].toList();
        list.add(_initInstagram.toJson());
        querySnapshot.documents[0].reference.updateData({'instagram': list});
      }
    }
  }

  static addPageOrderInBuildder(
      String id, String type, String pageName, String subOrder) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    List _pageOrderList = [];
    if (querySnapshot.documents[0]['page_order'].length == 1) {
      List _temppageOrderList = [];
      _temppageOrderList = querySnapshot.documents[0]['page_order'];

      if (_temppageOrderList[0]['page_name'] == '') {
        PageOrder newPageOrder =
            new PageOrder(pageName: pageName, subOrder: '0');
        _pageOrderList.add(newPageOrder.toJson());

        querySnapshot.documents[0].reference
            .updateData({'page_order': _pageOrderList});
      } else {
        for (int i = 0;
            i < querySnapshot.documents[0]['page_order'].length;
            i++) {
          _pageOrderList.add(querySnapshot.documents[0]['page_order'][i]);
        }
        PageOrder newPageOrder =
            new PageOrder(pageName: pageName, subOrder: subOrder);

        _pageOrderList.add(newPageOrder.toJson());

        querySnapshot.documents[0].reference
            .updateData({'page_order': _pageOrderList});
      }
    } else {
      for (int i = 0;
          i < querySnapshot.documents[0]['page_order'].length;
          i++) {
        _pageOrderList.add(querySnapshot.documents[0]['page_order'][i]);
      }

      PageOrder newPageOrder =
          new PageOrder(pageName: pageName, subOrder: subOrder);
      _pageOrderList.add(newPageOrder.toJson());

      querySnapshot.documents[0].reference
          .updateData({'page_order': _pageOrderList});
    }
  }

  static addPageOrderInType(
      String id, String type, String pageName, String subOrder) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    List _pageOrderList = [];

    if (querySnapshot.documents[0]['page_order'].length == 1) {
      List _temppageOrderList = [];
      _temppageOrderList = querySnapshot.documents[0]['page_order'];

      if (_temppageOrderList[0]['page_name'] == '') {
        PageOrder newPageOrder =
            new PageOrder(pageName: pageName, subOrder: '0');
        _pageOrderList.add(newPageOrder.toJson());

        querySnapshot.documents[0].reference
            .updateData({'page_order': _pageOrderList});
      } else {
        for (int i = 0;
            i < querySnapshot.documents[0]['page_order'].length;
            i++) {
          _pageOrderList.add(querySnapshot.documents[0]['page_order'][i]);
        }
        PageOrder newPageOrder =
            new PageOrder(pageName: pageName, subOrder: subOrder);

        _pageOrderList.add(newPageOrder.toJson());

        querySnapshot.documents[0].reference
            .updateData({'page_order': _pageOrderList});
      }
    } else {
      for (int i = 0;
          i < querySnapshot.documents[0]['page_order'].length;
          i++) {
        _pageOrderList.add(querySnapshot.documents[0]['page_order'][i]);
      }

      PageOrder newPageOrder =
          new PageOrder(pageName: pageName, subOrder: subOrder);
      _pageOrderList.add(newPageOrder.toJson());

      querySnapshot.documents[0].reference
          .updateData({'page_order': _pageOrderList});
    }
  }

  static getSubOrderFromCollection(
      String id, String type, String pageName) async {
    String fieldName = '';
    if (pageName == 'Image') {
      fieldName = 'my_image';
    }
    if (pageName == 'Text') {
      fieldName = 'text_part';
    }
    if (pageName == 'YouTube') {
      fieldName = 'youtube';
    }
    if (pageName == 'Quad chart') {
      fieldName = 'quad_title';
    }
    if (pageName == 'Scale chart') {
      fieldName = 'scale_title';
    }
    if (pageName == 'Vimeo') {
      fieldName = 'vimeo';
    }
    if (pageName == 'Instagram') {
      fieldName = 'instagram';
    }

    int subOrder = 0;

    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot.documents[0][fieldName] == null) {
      return subOrder.toString();
    } else {
      subOrder = querySnapshot.documents[0][fieldName].length - 1;

      return subOrder.toString();
    }
  }

  static getPageOrder(String id, String type) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot.documents[0]['page_order'] == null) {
      List _listInitPageOrder = [];
      PageOrder _initPageOrder =
          new PageOrder(pageName: 'Cover image', subOrder: '0', commentID: '');
      _listInitPageOrder.add(_initPageOrder.toJson());

      querySnapshot.documents[0].reference
          .updateData({'page_order': _listInitPageOrder});

      List<PageOrder> temp = [];
      temp.add(_initPageOrder);
      return temp;
    } else {
      List<PageOrder> _pageOrderList = [];
      for (int i = 0;
          i < querySnapshot.documents[0]['page_order'].length;
          i++) {
        _pageOrderList.add(
            PageOrder.fromJson(querySnapshot.documents[0]['page_order'][i]));
      }
      return _pageOrderList;
    }
  }

  static getSpecialPageOrder(
      String id, String type, int pageArrayNumber) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    List _pageOrder = [];
    _pageOrder = querySnapshot.documents[0]['page_order'];
    PageOrder _specialPageOrder =
        PageOrder.fromJson(_pageOrder[pageArrayNumber]);
    String subOrder = _specialPageOrder.subOrder;
    return subOrder;
  }

  static saveSetupInfo(String id, String type, SetupInfo _setupInfo) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    querySnapshot.documents[0].reference
        .updateData({'SetupInfo': _setupInfo.toJson()});
  }

  static Future<TextPartModel> getTextPartData(
      String uid, String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot.documents[0]['text_part'] == null ||
        querySnapshot.documents[0]['text_part'].length == 0) {
      List _listInitTextPart = [];
      TextPartModel _initTextPart = new TextPartModel(
          title: '', text: '', description: '', tag: '', reference: '');

      _listInitTextPart.add(_initTextPart.toJson());

      querySnapshot.documents[0].reference
          .updateData({'text_part': _listInitTextPart});

      return _initTextPart;
    } else {
      TextPartModel _myTextPart;

      var list = querySnapshot.documents[0]['text_part'];
      if (list.length > subOrder) {
        _myTextPart = TextPartModel.fromJson(list[subOrder]);
        return _myTextPart;
      } else {
        TextPartModel _myTextPart = new TextPartModel(
            title: '', text: '', description: '', tag: '', reference: '');
        return _myTextPart;
      }
    }
  }

  static Future<YoutubeModel> getYoutubeData(
      String uid, String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (querySnapshot.documents[0]['youtube'] == null ||
        querySnapshot.documents[0]['youtube'].length == 0) {
      List _listInitYouTube = [];
      YoutubeModel _initYouTube = new YoutubeModel(
          image: '',
          title: '',
          youtubeURL: '',
          description: '',
          tag: '',
          reference: '');

      _listInitYouTube.add(_initYouTube.toJson());

      querySnapshot.documents[0].reference
          .updateData({'youtube': _listInitYouTube});

      return _initYouTube;
    } else {
      YoutubeModel _youtubeList;

      var list = querySnapshot.documents[0]['youtube'];
      if (list.length > subOrder) {
        _youtubeList = YoutubeModel.fromJson(list[subOrder]);

        return _youtubeList;
      } else {
        YoutubeModel _youtubeList = new YoutubeModel(
            image: '',
            title: '',
            youtubeURL: '',
            description: '',
            tag: '',
            reference: '');
        return _youtubeList;
      }
    }
  }

  static Future<InstagramModel> getInstagramData(
      String uid, String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot.documents[0]['instagram'] == null ||
        querySnapshot.documents[0]['instagram'].length == 0) {
      List _listInitInstagram = [];
      InstagramModel _initInstagram = new InstagramModel(
          title: '', instagramURL: '', description: '', tag: '', reference: '');

      _listInitInstagram.add(_initInstagram.toJson());

      querySnapshot.documents[0].reference
          .updateData({'instagram': _listInitInstagram});

      return _initInstagram;
    } else {
      InstagramModel _intagramList;

      var list = querySnapshot.documents[0]['instagram'];
      if (list.length > subOrder) {
        _intagramList = InstagramModel.fromJson(list[subOrder]);

        return _intagramList;
      } else {
        InstagramModel _initInstagram = new InstagramModel(
            title: '',
            instagramURL: '',
            description: '',
            tag: '',
            reference: '');
        return _initInstagram;
      }
    }
  }

  static Future<QuadTitleModel> getQuadTitleData(
      String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot.documents[0]['quad_heatmap'] == null ||
        querySnapshot.documents[0]['quad_heatmap'].length == 0) {
      List _listInitQuadHeatmap = [];
      ChartCirclePosition _initQuadHeatmap = new ChartCirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        minOpacity: 0.01,
        subOrder: subOrder.toString(),
      );

      _listInitQuadHeatmap.add(_initQuadHeatmap.toJson());

      querySnapshot.documents[0].reference
          .updateData({'quad_heatmap': _listInitQuadHeatmap});
    }
    if (querySnapshot.documents[0]['quad_circle_position'] == null ||
        querySnapshot.documents[0]['quad_circle_position'].length == 0) {
      List _listInitQuadCirclePosition = [];
      CirclePosition _initQuadCirclePosition = new CirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        subOrder: subOrder.toString(),
      );

      _listInitQuadCirclePosition.add(_initQuadCirclePosition.toJson());

      querySnapshot.documents[0].reference
          .updateData({'quad_circle_position': _listInitQuadCirclePosition});
    }
    if (querySnapshot.documents[0]['quad_title'] == null ||
        querySnapshot.documents[0]['quad_title'].length == 0) {
      // init quad_chart
      List _listInitTitle = [];
      QuadTitleModel _initTitle = new QuadTitleModel(
          title: "",
          color: "",
          labelOne: "",
          labelTwo: "",
          labelThree: "",
          labelFour: "",
          description: "",
          tag: "",
          reference: "");

      _listInitTitle.add(_initTitle.toJson());

      querySnapshot.documents[0].reference
          .updateData({'quad_title': _listInitTitle});

      return _initTitle;
    } else {
      QuadTitleModel _quadTitleList;

      var list = querySnapshot.documents[0]['quad_title'];
      if (list.length > subOrder) {
        _quadTitleList = QuadTitleModel.fromJson(list[subOrder]);

        return _quadTitleList;
      } else {
        QuadTitleModel _quadTitleList = new QuadTitleModel(
            title: "",
            color: "",
            labelOne: "",
            labelTwo: "",
            labelThree: "",
            labelFour: "",
            description: "",
            tag: "",
            reference: "");
        return _quadTitleList;
      }
    }
  }

  static Future<ScaleTitleModel> getScaleTitleData(
      String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot.documents[0]['scale_heatmap'] == null ||
        querySnapshot.documents[0]['scale_heatmap'].length == 0) {
      List _listInitScaleHeatmap = [];
      ChartCirclePosition _initScaleHeatmap = new ChartCirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        minOpacity: 0.01,
        subOrder: subOrder.toString(),
      );

      _listInitScaleHeatmap.add(_initScaleHeatmap.toJson());

      querySnapshot.documents[0].reference
          .updateData({'scale_heatmap': _listInitScaleHeatmap});
    }
    if (querySnapshot.documents[0]['scale_circle_position'] == null ||
        querySnapshot.documents[0]['scale_circle_position'].length == 0) {
      List _listInitScaleCirclePosition = [];
      CirclePosition _initScaleCirclePosition = new CirclePosition(
        x: SessionManager.getMediaWidth() / 2 - 52.5,
        y: SessionManager.getMediaHeight() * 0.8 / 2 - 72,
        uid: '',
        subOrder: subOrder.toString(),
      );

      _listInitScaleCirclePosition.add(_initScaleCirclePosition.toJson());

      querySnapshot.documents[0].reference
          .updateData({'scale_circle_position': _listInitScaleCirclePosition});
    }
    if (querySnapshot.documents[0]['scale_title'] == null ||
        querySnapshot.documents[0]['scale_title'].length == 0) {
      // init scale_chart
      List _listInitTitle = [];
      ScaleTitleModel _initTitle = new ScaleTitleModel(
          title: "",
          color: "",
          labelOne: "",
          labelTwo: "",
          description: "",
          tag: "",
          reference: "");

      _listInitTitle.add(_initTitle.toJson());

      querySnapshot.documents[0].reference
          .updateData({'scale_title': _listInitTitle});

      return _initTitle;
    } else {
      ScaleTitleModel _scaleTitleList;

      var list = querySnapshot.documents[0]['scale_title'];
      if (list.length > subOrder) {
        _scaleTitleList = ScaleTitleModel.fromJson(list[subOrder]);

        return _scaleTitleList;
      } else {
        ScaleTitleModel _scaleTitleList = new ScaleTitleModel(
            title: "",
            color: "",
            labelOne: "",
            labelTwo: "",
            description: "",
            tag: "",
            reference: "");
        return _scaleTitleList;
      }
    }
  }

  static Future<CoverImageModel> getCoverImageData(
      String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot.documents[0]['cover_image'] == null) {
      CoverImageModel _initCoverImage =
          new CoverImageModel(description: '', tag: '', reference: '');
      querySnapshot.documents[0].reference
          .updateData({'cover_image': _initCoverImage.toJson()});

      return _initCoverImage;
    } else {
      CoverImageModel _result =
          CoverImageModel.fromJson(querySnapshot.documents[0]['cover_image']);
      return _result;
    }
  }

  static Future<ImageModel> getMyImageData(
      String uid, String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot.documents[0]['my_image'] == null ||
        querySnapshot.documents[0]['my_image'].length == 0) {
      List _listInitMyImage = [];
      ImageModel _initMyImage = new ImageModel(
          imageURL: '', link: '', description: '', tag: '', reference: '');

      _listInitMyImage.add(_initMyImage.toJson());

      querySnapshot.documents[0].reference
          .updateData({'my_image': _listInitMyImage});

      return _initMyImage;
    } else {
      ImageModel _myImageList;

      var list = querySnapshot.documents[0]['my_image'];
      if (list.length > subOrder) {
        _myImageList = ImageModel.fromJson(list[subOrder]);
        return _myImageList;
      } else {
        ImageModel _myImageList = new ImageModel(
            imageURL: '', link: '', description: '', tag: '', reference: '');
        return _myImageList;
      }
    }
  }

  static Future<VimeoModel> getVimeoData(
      String uid, String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot.documents[0]['vimeo'] == null ||
        querySnapshot.documents[0]['vimeo'].length == 0) {
      List _listInitVimeo = [];
      VimeoModel _initVimeo = new VimeoModel(
          image: '',
          title: '',
          vimeoURL: '',
          description: '',
          tag: '',
          reference: '');

      _listInitVimeo.add(_initVimeo.toJson());

      querySnapshot.documents[0].reference
          .updateData({'vimeo': _listInitVimeo});

      return _initVimeo;
    } else {
      VimeoModel _vimeoList;

      var list = querySnapshot.documents[0]['vimeo'];
      if (list.length > subOrder) {
        _vimeoList = VimeoModel.fromJson(list[subOrder]);

        return _vimeoList;
      } else {
        VimeoModel _vimeoList = new VimeoModel(
            image: '',
            title: '',
            vimeoURL: '',
            description: '',
            tag: '',
            reference: '');
        return _vimeoList;
      }
    }
  }

  static Future<StyledQuad> getQuad(String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    StyledQuad _titleList;
    _titleList =
        StyledQuad.fromJson(docSnapShot.documents[0]['quad_title_list']);
    return _titleList;
  }

  static Future<StyledScale> getScale(
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    StyledScale _titleList;
    _titleList =
        StyledScale.fromJson(docSnapShot.documents[0]['scale_title_list']);
    return _titleList;
  }

  static Future<List<ChartCirclePosition>> getQuadHeatmap(
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    List<ChartCirclePosition> quadChartList = [];
    for (int i = 0; i < docSnapShot.documents[0]['quad_heatmap'].length; i++) {
      quadChartList.add(new ChartCirclePosition.fromJson(
          docSnapShot.documents[0]['quad_heatmap'][i]));
    }
    return quadChartList;
  }

  static Future<List<ChartCirclePosition>> getScaleHeatmap(
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    List<ChartCirclePosition> scaleChartList = [];
    for (int i = 0; i < docSnapShot.documents[0]['scale_heatmap'].length; i++) {
      scaleChartList.add(new ChartCirclePosition.fromJson(
          docSnapShot.documents[0]['scale_heatmap'][i]));
    }
    return scaleChartList;
  }

  static Future<CirclePosition> getQuadPosition(
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    CirclePosition quadCirclePositionList;
    for (int i = 0;
        i < docSnapShot.documents[0]['quad_circle_position'].length;
        i++) {
      CirclePosition _quadCirclePositionList = new CirclePosition.fromJson(
          docSnapShot.documents[0]['quad_circle_position'][i]);
      if (_quadCirclePositionList.uid == SessionManager.getUserId()) {
        quadCirclePositionList = _quadCirclePositionList;
      }
    }
    return quadCirclePositionList;
  }

  static Future<CirclePosition> getScalePosition(
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    CirclePosition scaleCirclePositionList;
    for (int i = 0;
        i < docSnapShot.documents[0]['scale_circle_position'].length;
        i++) {
      CirclePosition _scaleCirclePositionList = new CirclePosition.fromJson(
          docSnapShot.documents[0]['scale_circle_position'][i]);
      if (_scaleCirclePositionList.uid == SessionManager.getUserId()) {
        scaleCirclePositionList = _scaleCirclePositionList;
      }
    }
    return scaleCirclePositionList;
  }

  static Future<void> updateQuadPosition(
      var position, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    int isPosition;
    for (int i = 0;
        i < docSnapShot.documents[0]['quad_circle_position'].length;
        i++) {
      CirclePosition _quadCirclePosition = new CirclePosition.fromJson(
          docSnapShot.documents[0]['quad_circle_position'][i]);

      if (_quadCirclePosition.uid == position.uid) {
        docSnapShot.documents[0]['quad_circle_position'][i] = position.toJson();
        isPosition = 1;
      }
      docSnapShot.documents[0].reference.updateData({
        'quad_circle_position': docSnapShot.documents[0]['quad_circle_position']
      });
    }
    if (isPosition == null) {
      List _quadCirclePosition =
          docSnapShot.documents[0]['quad_circle_position'].toList();
      _quadCirclePosition.add(position.toJson());
      docSnapShot.documents[0].reference
          .updateData({'quad_circle_position': _quadCirclePosition});
    }
  }

  static Future<void> updateScalePosition(
      var position, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    int isPosition;
    for (int i = 0;
        i < docSnapShot.documents[0]['scale_circle_position'].length;
        i++) {
      CirclePosition _scaleCirclePosition = new CirclePosition.fromJson(
          docSnapShot.documents[0]['scale_circle_position'][i]);

      if (_scaleCirclePosition.uid == position.uid) {
        docSnapShot.documents[0]['scale_circle_position'][i] =
            position.toJson();
        isPosition = 1;
      }
      docSnapShot.documents[0].reference.updateData({
        'scale_circle_position': docSnapShot.documents[0]
            ['scale_circle_position']
      });
    }
    if (isPosition == null) {
      List _scaleCirclePosition =
          docSnapShot.documents[0]['scale_circle_position'].toList();
      _scaleCirclePosition.add(position.toJson());
      docSnapShot.documents[0].reference
          .updateData({'scale_circle_position': _scaleCirclePosition});
    }
  }

  static Future<void> updateQuadHeatmap(
      ChartCirclePosition position, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    int isPosition;
    for (int i = 0; i < docSnapShot.documents[0]['quad_heatmap'].length; i++) {
      ChartCirclePosition _quadCirclePosition =
          new ChartCirclePosition.fromJson(
              docSnapShot.documents[0]['quad_heatmap'][i]);
      if (_quadCirclePosition.uid == position.uid) {
        docSnapShot.documents[0]['quad_heatmap'][i] = position.toJson();
        isPosition = 1;
      }
      docSnapShot.documents[0].reference.updateData(
          {'quad_heatmap': docSnapShot.documents[0]['quad_heatmap']});
    }
    if (isPosition == null) {
      List _quadCirclePosition =
          docSnapShot.documents[0]['quad_heatmap'].toList();
      _quadCirclePosition.add(position.toJson());
      docSnapShot.documents[0].reference
          .updateData({'quad_heatmap': _quadCirclePosition});
    }
  }

  static Future<void> updateScaleHeatmap(
      ChartCirclePosition position, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    int isPosition;
    for (int i = 0; i < docSnapShot.documents[0]['scale_heatmap'].length; i++) {
      ChartCirclePosition _scaleCirclePosition =
          new ChartCirclePosition.fromJson(
              docSnapShot.documents[0]['scale_heatmap'][i]);
      if (_scaleCirclePosition.uid == position.uid) {
        docSnapShot.documents[0]['scale_heatmap'][i] = position.toJson();
        isPosition = 1;
      }
      docSnapShot.documents[0].reference.updateData(
          {'scale_heatmap': docSnapShot.documents[0]['scale_heatmap']});
    }
    if (isPosition == null) {
      List _scaleCirclePosition =
          docSnapShot.documents[0]['scale_heatmap'].toList();
      _scaleCirclePosition.add(position.toJson());
      docSnapShot.documents[0].reference
          .updateData({'scale_heatmap': _scaleCirclePosition});
    }
  }

  static Future<int> getQuadColor(String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    int _color;
    _color = docSnapShot.documents[0]['quad_circle_color'];
    return _color;
  }

  static Future<int> getScaleColor(String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    int _color;
    _color = docSnapShot.documents[0]['scale_circle_color'];
    return _color;
  }

  static Future<void> updateImage(
      var image, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) return;
    docSnapShot.documents[0].reference.updateData({'image': image});
  }

  static Future<void> updatePosition(
      var position, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) return;
    docSnapShot.documents[0].reference
        .updateData({'position': position.toJson()});
  }

  static Future<void> updatePosition1(
      var position, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) return;
    docSnapShot.documents[0].reference
        .updateData({'position1': position.toJson()});
  }

  static Future<void> updateTitle(
      var title, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) return;
    docSnapShot.documents[0].reference.updateData({'title': title.toJson()});
  }

  static Future<void> updateSubTitle(
      var subtitle, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) return;
    docSnapShot.documents[0].reference
        .updateData({'subtitle': subtitle.toJson()});
  }

  static Future<void> updateTextPart(TextPartModel textpart, String uid,
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    var list = docSnapShot.documents[0]['text_part'].toList();
    list[subOrder] = textpart.toJson();
    docSnapShot.documents[0].reference.updateData({'text_part': list});
  }

  static Future<void> updateYoutube(YoutubeModel youtube, String uid, String id,
      String type, int subOrder) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    var list = docSnapShot.documents[0]['youtube'].toList();
    list[subOrder] = youtube.toJson();
    docSnapShot.documents[0].reference.updateData({'youtube': list});
  }

  static Future<void> updateCoverImage(
      CoverImageModel coverImage, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      db.collection(type).add({'cover_image': coverImage.toJson()});
    } else {
      docSnapShot.documents[0].reference
          .updateData({'cover_image': coverImage.toJson()});
    }
  }

  static Future<void> updateMyImage(ImageModel myImage, String uid, String id,
      String type, int subOrder) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    var list = docSnapShot.documents[0]['my_image'].toList();
    list[subOrder] = myImage.toJson();
    docSnapShot.documents[0].reference.updateData({'my_image': list});
  }

  static Future<void> updateVimeo(VimeoModel vimeo, String uid, String id,
      String type, int subOrder) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    var list = docSnapShot.documents[0]['vimeo'].toList();
    list[subOrder] = vimeo.toJson();
    docSnapShot.documents[0].reference.updateData({'vimeo': list});
  }

  static Future<void> updateInstagram(InstagramModel instagram, String uid,
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    var list = docSnapShot.documents[0]['instagram'].toList();
    list[subOrder] = instagram.toJson();
    docSnapShot.documents[0].reference.updateData({'instagram': list});
  }

  static Future<void> updateQuadTitle(QuadTitleModel quadTitle, String uid,
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    var list = docSnapShot.documents[0]['quad_title'].toList();
    list[subOrder] = quadTitle.toJson();
    docSnapShot.documents[0].reference.updateData({'quad_title': list});
  }

  static Future<void> updateScaleTitle(ScaleTitleModel scaleTitle, String uid,
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    var list = docSnapShot.documents[0]['scale_title'].toList();
    list[subOrder] = scaleTitle.toJson();
    docSnapShot.documents[0].reference.updateData({'scale_title': list});
  }

  static Future<void> savePageStructure(
      String pageType, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
    } else {
      if (docSnapShot.documents[0]['page_order'] == null) {
        List pageStructure = [
          'ViewerSecond',
          pageType,
        ];

        docSnapShot.documents[0].reference
            .updateData({'page_order': pageStructure});
      } else {
        var pageStructure = docSnapShot.documents[0]['page_order'].toList();

        int flag = 0;
        for (int i = 0; i < pageStructure.length; i++) {
          if (pageStructure[i] == pageType) {
            flag = 1;
          }
        }
        if (flag == 0) {
          pageStructure.add(pageType);
        }
        docSnapShot.documents[0].reference
            .updateData({'page_order': pageStructure});
      }
    }
  }

  static Future<void> setInitialQuadTitleList(
      StyledQuad quadList, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      docSnapShot.documents[0].reference
          .updateData({'quad_title_list': quadList.toJson()});
    }
  }

  static Future<void> setInitialScaleTitleList(
      StyledScale scaleList, String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      docSnapShot.documents[0].reference
          .updateData({'scale_title_list': scaleList.toJson()});
    }
  }

  static Future<void> setInitialQuadCirclePosition(
      CirclePosition quadCirclePosition,
      String uid,
      String id,
      String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      List criclePositionList = [];
      criclePositionList.add(quadCirclePosition.toJson());
      docSnapShot.documents[0].reference
          .updateData({'quad_circle_position': criclePositionList});
    }
  }

  static Future<void> setInitialScaleCirclePosition(
      CirclePosition scaleCirclePosition,
      String uid,
      String id,
      String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      List criclePositionList = [];
      criclePositionList.add(scaleCirclePosition.toJson());
      docSnapShot.documents[0].reference
          .updateData({'scale_circle_position': criclePositionList});
    }
  }

  static Future<void> setInitialQuadHeatmap(ChartCirclePosition initHeatmapInfo,
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      List quadHeatmapList = [];
      quadHeatmapList.add(initHeatmapInfo.toJson());
      docSnapShot.documents[0].reference
          .updateData({'quad_heatmap': quadHeatmapList});
    }
  }

  static Future<void> setInitialScaleHeatmap(
      ChartCirclePosition initHeatmapInfo,
      String uid,
      String id,
      String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      List scaleHeatmapList = [];
      scaleHeatmapList.add(initHeatmapInfo.toJson());
      docSnapShot.documents[0].reference
          .updateData({'scale_heatmap': scaleHeatmapList});
    }
  }

  static Future<void> setInitialQuadCircleColor(
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      docSnapShot.documents[0].reference
          .updateData({'quad_circle_color': 4294926080});
    }
  }

  static Future<void> setInitialScaleCircleColor(
      String uid, String id, String type) async {
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null) {
      return null;
    } else {
      docSnapShot.documents[0].reference
          .updateData({'scale_circle_color': 4294926080});
    }
  }

  static getPageStructure(String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      var pageStructure = querySnapshot.documents[0]['page_order'];

      return pageStructure.length;
    }
  }

  static Future<void> publish(
      String uid, String id, String type, String dynamiclink) async {
    QuerySnapshot querySnapshotdyna = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    querySnapshotdyna.documents[0].reference
        .updateData({'dynamiclink': dynamiclink});

    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    await db.collection('Trending').add(querySnapshot.documents[0].data);

    // ********* Save my profile page  **********

    QuerySnapshot querySnapshot1 = await db
        .collection('SavedDraft')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot1.documents.length == 0) {
      DocumentReference docRef = await db
          .collection('SavedDraft')
          .add(querySnapshot.documents[0].data);

      docRef.updateData({'xmaptype': 'published'});
    }
  }

  static Future<void> moveUpPages(String id, String type, int pageOrder) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    List pageStructure = querySnapshot.documents[0]['page_order'];
    PageOrder _tempbefore = PageOrder.fromJson(pageStructure[pageOrder - 1]);
    PageOrder _temp = PageOrder.fromJson(pageStructure[pageOrder]);

    pageStructure[pageOrder - 1] = _temp.toJson();
    pageStructure[pageOrder] = _tempbefore.toJson();
    print("builder moveup page");
    querySnapshot.documents[0].reference
        .updateData({'page_order': pageStructure});
  }

  static Future<void> updateMoveUpPageOrderIdFromPublishedXmap(
      String id, String type, int pageOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection('Comments')
        .where('xmap_id', isEqualTo: id)
        .where('collection_type', isEqualTo: type)
        .where('page_order_id', isEqualTo: pageOrder.toString())
        .getDocuments();
    QuerySnapshot querySnapshotBefore;
    int beforePageOrder = pageOrder - 1;
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      querySnapshot.documents[0].reference
          .updateData({'page_order_id': 'temp'});
      querySnapshotBefore = await db
          .collection('Comments')
          .where('xmap_id', isEqualTo: id)
          .where('collection_type', isEqualTo: type)
          .where('page_order_id', isEqualTo: beforePageOrder.toString())
          .getDocuments();

      if (querySnapshotBefore != null &&
          querySnapshotBefore.documents.length != 0) {
        querySnapshotBefore.documents[0].reference
            .updateData({'page_order_id': pageOrder.toString()});
      }

      QuerySnapshot querySnapshotTemp = await db
          .collection('Comments')
          .where('xmap_id', isEqualTo: id)
          .where('collection_type', isEqualTo: type)
          .where('page_order_id', isEqualTo: 'temp')
          .getDocuments();

      querySnapshotTemp.documents[0].reference
          .updateData({'page_order_id': beforePageOrder.toString()});
    } else {
      QuerySnapshot querySnapshotBefore = await db
          .collection('Comments')
          .where('xmap_id', isEqualTo: id)
          .where('collection_type', isEqualTo: type)
          .where('page_order_id', isEqualTo: beforePageOrder.toString())
          .getDocuments();
      if (querySnapshotBefore != null &&
          querySnapshotBefore.documents.length != 0) {
        querySnapshotBefore.documents[0].reference
            .updateData({'page_order_id': pageOrder.toString()});
      }
    }
  }

  static Future<void> updateMoveDownPageOrderIdFromPublishedXmap(
      String id, String type, int pageOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection('Comments')
        .where('xmap_id', isEqualTo: id)
        .where('collection_type', isEqualTo: type)
        .where('page_order_id', isEqualTo: pageOrder.toString())
        .getDocuments();
    QuerySnapshot querySnapshotAfter;
    // querySnapshotAfter = db.collection('').document('').collection('collectionPath')

    int nextPageOrder = pageOrder + 1;
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      querySnapshot.documents[0].reference
          .updateData({'page_order_id': 'temp'});

      querySnapshotAfter = await db
          .collection('Comments')
          .where('xmap_id', isEqualTo: id)
          .where('collection_type', isEqualTo: type)
          .where('page_order_id', isEqualTo: nextPageOrder.toString())
          .getDocuments();

      if (querySnapshotAfter != null &&
          querySnapshotAfter.documents.length != 0) {
        querySnapshotAfter.documents[0].reference
            .updateData({'page_order_id': pageOrder.toString()});
      }

      QuerySnapshot querySnapshotTemp = await db
          .collection('Comments')
          .where('xmap_id', isEqualTo: id)
          .where('collection_type', isEqualTo: type)
          .where('page_order_id', isEqualTo: 'temp')
          .getDocuments();

      querySnapshotTemp.documents[0].reference
          .updateData({'page_order_id': nextPageOrder.toString()});
    } else {
      QuerySnapshot querySnapshotAfter = await db
          .collection('Comments')
          .where('xmap_id', isEqualTo: id)
          .where('collection_type', isEqualTo: type)
          .where('page_order_id', isEqualTo: nextPageOrder.toString())
          .getDocuments();

      if (querySnapshotAfter != null &&
          querySnapshotAfter.documents.length != 0) {
        querySnapshotAfter.documents[0].reference
            .updateData({'page_order_id': pageOrder.toString()});
      }
    }
  }

  static Future<void> moveDownPages(
      String id, String type, int pageOrder) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    List pageStructure = querySnapshot.documents[0]['page_order'];
    if (pageStructure.length - 1 != pageOrder) {
      PageOrder _temp = PageOrder.fromJson(pageStructure[pageOrder]);
      PageOrder _tempnext = PageOrder.fromJson(pageStructure[pageOrder + 1]);

      pageStructure[pageOrder] = _tempnext.toJson();
      pageStructure[pageOrder + 1] = _temp.toJson();

      querySnapshot.documents[0].reference
          .updateData({'page_order': pageStructure});
    }
  }

  static Future<void> saveDraft(String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    QuerySnapshot querySnapshot1 = await db
        .collection('SavedDraft')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot1.documents.length == 0) {
      DocumentReference docRef = await db
          .collection('SavedDraft')
          .add(querySnapshot.documents[0].data);

      docRef.updateData({'xmaptype': 'draft'});
    }
  }

  static Future<void> saveDraftForBuilderUpdater(
      String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    QuerySnapshot querySnapshot1 = await db
        .collection('SavedDraft')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot1.documents[0]['xmaptype'] == 'draft') {
      // already draft xmap exist in SavedDraft

      querySnapshot1.documents[0].reference
          .updateData(querySnapshot.documents[0].data);
    } else {
      querySnapshot1.documents[0].reference
          .updateData(querySnapshot.documents[0].data);
      querySnapshot1.documents[0].reference.updateData({'xmaptype': 'draft'});
    }
  }

  static Future<void> publishForEdit(String uid, String id) async {
    QuerySnapshot querySnapshot = await db
        .collection("Buildder")
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    QuerySnapshot querySnapshot1 = await db
        .collection('SavedDraft')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    querySnapshot1.documents[0].reference
        .updateData(querySnapshot.documents[0].data);

    querySnapshot1.documents[0].reference.updateData({'xmaptype': 'published'});

    QuerySnapshot querySnapshot2 = await db
        .collection('Trending')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot2 == null || querySnapshot2.documents.length == 0) {
      DocumentReference docRef =
          await db.collection('Trending').add(querySnapshot.documents[0].data);

      docRef.updateData({'xmaptype': 'published'});
    } else {
      querySnapshot2.documents[0].reference
          .updateData(querySnapshot.documents[0].data);
      querySnapshot2.documents[0].reference
          .updateData({'xmaptype': 'published'});
    }

    // if section order have changed, update comments table .
  }

  static Future<void> updateXmap(String uid, String id) async {
    QuerySnapshot querySnapshot = await db
        .collection('Buildder')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    QuerySnapshot querySnapshot1 = await db
        .collection('SavedDraft')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    querySnapshot1.documents[0].reference
        .updateData(querySnapshot.documents[0].data);

    QuerySnapshot querySnapshot2 = await db
        .collection('Trending')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    querySnapshot2.documents[0].reference
        .updateData(querySnapshot.documents[0].data);
  }

  static setGlobal(String global, String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    SetupInfo _new =
        SetupInfo.fromJson(querySnapshot.documents[0]['SetupInfo']);
    _new.global = global;

    querySnapshot.documents[0].reference
        .updateData({'SetupInfo': _new.toJson()});
  }

  static getXmapType(String id) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection("SavedDraft")
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    String xmaptype = querySnapshot.documents[0]['xmaptype'];
    return xmaptype;
  }

  static Future<void> addNewBuilder(String id, String type) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    QuerySnapshot querySnapshot1 = await db
        .collection("Buildder")
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot1.documents.length == 1) {
      querySnapshot1.documents[0].reference.delete();
    }

    await db.collection('Buildder').add(querySnapshot.documents[0].data);
  }

  static Future<void> deleteEntireXmap(
      String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      querySnapshot.documents[0].reference.delete();
    }
  }

  static deleteFromXmapInfo(String uid, String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('xmapID', isEqualTo: id).getDocuments();
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      querySnapshot.documents[0].reference.delete();
    }
  }

  static deleteFromComments(String uid, String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('xmap_id', isEqualTo: id)
        .getDocuments();
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      querySnapshot.documents[0].reference.delete();
    }
  }

  static Future<void> deleteComments(String id, String type) async {
    QuerySnapshot querySnapshot = await db
        .collection("Comments")
        .where('xmap_id', isEqualTo: id)
        .where('collection_type', isEqualTo: type)
        .getDocuments();

    for (int j = 0; j < querySnapshot.documents.length; j++) {
      querySnapshot.documents[j].reference.delete();
    }
  }

  static Future<void> deleteFromSection(String uid, String id, String type,
      String sectionName, int pageArrayNumber, int subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    // 1. delete from type

    if (sectionName == 'Quad chart') {
      var _updateheatmap = [];

      _updateheatmap = querySnapshot.documents[0]['quad_heatmap'];

      for (int i = 0; i < _updateheatmap.length; i++) {
        int tempSubOrder = int.parse(_updateheatmap[i]['subOrder']);

        if (tempSubOrder > subOrder) {
          tempSubOrder = tempSubOrder - 1;
          _updateheatmap[i]['subOrder'] = tempSubOrder.toString();
        }
      }

      querySnapshot.documents[0].reference
          .updateData({'quad_heatmap': _updateheatmap});

      var _updatecircle = [];

      _updatecircle = querySnapshot.documents[0]['quad_circle_position'];

      for (int i = 0; i < _updatecircle.length; i++) {
        int tempSubOrder = int.parse(_updatecircle[i]['subOrder']);

        if (tempSubOrder > subOrder) {
          tempSubOrder = tempSubOrder - 1;
          _updatecircle[i]['subOrder'] = tempSubOrder.toString();
        }
      }

      querySnapshot.documents[0].reference
          .updateData({'quad_circle_position': _updatecircle});
    } else if (sectionName == 'Scale chart') {
      var _updateheatmap = [];

      _updateheatmap = querySnapshot.documents[0]['scale_heatmap'];

      for (int i = 0; i < _updateheatmap.length; i++) {
        int tempSubOrder = int.parse(_updateheatmap[i]['subOrder']);

        if (tempSubOrder > subOrder) {
          tempSubOrder = tempSubOrder - 1;
          _updateheatmap[i]['subOrder'] = tempSubOrder.toString();
        }
      }

      querySnapshot.documents[0].reference
          .updateData({'scale_heatmap': _updateheatmap});

      var _updatecircle = [];

      _updatecircle = querySnapshot.documents[0]['scale_circle_position'];

      for (int i = 0; i < _updatecircle.length; i++) {
        int tempSubOrder = int.parse(_updatecircle[i]['subOrder']);

        if (tempSubOrder > subOrder) {
          tempSubOrder = tempSubOrder - 1;
          _updatecircle[i]['subOrder'] = tempSubOrder.toString();
        }
      }

      querySnapshot.documents[0].reference
          .updateData({'scale_circle_position': _updatecircle});
    }

    // 3. update suborder if suborder in pageOrder > subOrder

    var _updatepageOrder = [];

    _updatepageOrder = querySnapshot.documents[0]['page_order'];

    for (int i = 0; i < _updatepageOrder.length; i++) {
      if (_updatepageOrder[i]['page_name'] == sectionName) {
        int tempSubOrder = int.parse(_updatepageOrder[i]['sub_order']);

        if (tempSubOrder > subOrder) {
          tempSubOrder = tempSubOrder - 1;
          _updatepageOrder[i]['sub_order'] = tempSubOrder.toString();
        }
      }
    }

    querySnapshot.documents[0].reference
        .updateData({'page_order': _updatepageOrder});
  }

  static Future<void> deleteSection(String uid, String id, String type,
      String sectionName, int pageArrayNumber, int subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    String fieldName = '';

    // 1. delete from type

    if (sectionName == 'Quad chart') {
      List _dataheatmap = [];
      List _tempDataheatmap = [];
      if (querySnapshot.documents[0]['quad_heatmap'] != null &&
          querySnapshot.documents[0]['quad_heatmap'].length != 0) {
        _dataheatmap = querySnapshot.documents[0]['quad_heatmap'];
        for (int i = 0; i < _dataheatmap.length; i++) {
          if (_dataheatmap[i]['subOrder'] != subOrder.toString()) {
            _tempDataheatmap.add(_dataheatmap[i]);
          }
        }
        querySnapshot.documents[0].reference
            .updateData({'quad_heatmap': _tempDataheatmap});
      }

      List _datacircle = [];
      List _tempDatacircle = [];
      if (querySnapshot.documents[0]['quad_circle_position'] != null &&
          querySnapshot.documents[0]['quad_circle_position'].length != 0) {
        _datacircle = querySnapshot.documents[0]['quad_circle_position'];
        for (int i = 0; i < _datacircle.length; i++) {
          if (_datacircle[i]['subOrder'] != subOrder.toString()) {
            _tempDatacircle.add(_datacircle[i]);
          }
        }
        querySnapshot.documents[0].reference
            .updateData({'quad_circle_position': _tempDatacircle});
      }

      List _datatitle = [];
      List _tempDatatitle = [];
      if (querySnapshot.documents[0]['quad_title'] != null &&
          querySnapshot.documents[0]['quad_title'].length != 0) {
        _datatitle = querySnapshot.documents[0]['quad_title'];
        for (int i = 0; i < _datatitle.length; i++) {
          if (i != subOrder) {
            _tempDatatitle.add(_datatitle[i]);
          }
        }
        querySnapshot.documents[0].reference
            .updateData({'quad_title': _tempDatatitle});
      }
    } else if (sectionName == 'Scale chart') {
      List _dataheatmap = [];
      List _tempDataheatmap = [];
      if (querySnapshot.documents[0]['scale_heatmap'] != null &&
          querySnapshot.documents[0]['scale_heatmap'].length != 0) {
        _dataheatmap = querySnapshot.documents[0]['scale_heatmap'];
        for (int i = 0; i < _dataheatmap.length; i++) {
          if (_dataheatmap[i]['subOrder'] != subOrder.toString()) {
            _tempDataheatmap.add(_dataheatmap[i]);
          }
        }
        querySnapshot.documents[0].reference
            .updateData({'scale_heatmap': _tempDataheatmap});
      }

      List _datacircle = [];
      List _tempDatacircle = [];
      if (querySnapshot.documents[0]['scale_circle_position'] != null &&
          querySnapshot.documents[0]['scale_circle_position'].length != 0) {
        _datacircle = querySnapshot.documents[0]['scale_circle_position'];
        for (int i = 0; i < _datacircle.length; i++) {
          if (_datacircle[i]['subOrder'] != subOrder.toString()) {
            _tempDatacircle.add(_datacircle[i]);
          }
        }
        querySnapshot.documents[0].reference
            .updateData({'scale_circle_position': _tempDatacircle});
      }

      List _datatitle = [];
      List _tempDatatitle = [];
      if (querySnapshot.documents[0]['scale_title'] != null &&
          querySnapshot.documents[0]['scale_title'].length != 0) {
        _datatitle = querySnapshot.documents[0]['scale_title'];
        for (int i = 0; i < _datatitle.length; i++) {
          if (i != subOrder) {
            _tempDatatitle.add(_datatitle[i]);
          }
        }
        querySnapshot.documents[0].reference
            .updateData({'scale_title': _tempDatatitle});
      }
    } else {
      if (sectionName == "Image") {
        fieldName = 'my_image';
      }
      if (sectionName == "Text") {
        fieldName = 'text_part';
      }
      if (sectionName == 'YouTube') {
        fieldName = 'youtube';
      }
      if (sectionName == 'Vimeo') {
        fieldName = 'vimeo';
      }
      if (sectionName == 'Instagram') {
        fieldName = 'instagram';
      }

      List _data = [];
      List _tempData = [];
      if (querySnapshot.documents[0][fieldName] != null &&
          querySnapshot.documents[0][fieldName].length != 0) {
        _data = querySnapshot.documents[0][fieldName];
        for (int i = 0; i < _data.length; i++) {
          if (i != subOrder) {
            _tempData.add(_data[i]);
          }
        }
        querySnapshot.documents[0].reference.updateData({fieldName: _tempData});
      }
    }

    // 2. delete from pageOrder
    List _pageOrder = [];
    List _tempPageOrder = [];
    _pageOrder = querySnapshot.documents[0]['page_order'];

    for (int i = 0; i < _pageOrder.length; i++) {
      if (i != pageArrayNumber) {
        _tempPageOrder.add(_pageOrder[i]);
      }
    }

    querySnapshot.documents[0].reference
        .updateData({'page_order': _tempPageOrder});

    // 4. delete from Comments
    //    if type is not Buildder or savedDraft, then delete comments from type

    if (type != "Buildder" && type != "SavedDraft") {
      String _tempPageOrderId = (pageArrayNumber + 2).toString();

      QuerySnapshot querySnapshot1 = await db
          .collection("Comments")
          .where('xmap_id', isEqualTo: id)
          .where('collection_type', isEqualTo: type)
          .where('page_order_id', isEqualTo: _tempPageOrderId)
          .getDocuments();

      if (querySnapshot1.documents.length != 0) {
        querySnapshot1.documents[0].reference.delete();
      }
    }
  }
}
