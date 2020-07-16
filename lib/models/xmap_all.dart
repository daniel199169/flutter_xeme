import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/models/image.dart';
import 'package:xenome/models/quadTitle.dart';
import 'package:xenome/models/chartCirclePosition.dart';
import 'package:xenome/models/circleposition.dart';
import 'package:xenome/models/scaleTitle.dart';
import 'package:xenome/models/youtube.dart';
import 'package:xenome/models/vimeo.dart';
import 'package:xenome/models/instagram.dart';
import 'package:xenome/models/text_part.dart';

class XmapAllData {
  String id;
  String xmapType;
  SetupInfo setupInfo;
  CoverImageModel coverImage;
  ImageModel myImage;
  TextPartModel textpart;
  YoutubeModel youtube;
  VimeoModel vimeo;
  InstagramModel instagram;
  QuadTitleModel quadTitle;
  ScaleTitleModel scaleTitle;
  ChartCirclePosition quadHeatmap;
  ChartCirclePosition scaleHeatmap;
  CirclePosition quadCirclePosition;
  CirclePosition scaleCirclePosition;

  XmapAllData(
      {this.id,
      this.xmapType,
      this.setupInfo,
      this.coverImage,
      this.myImage,
      this.textpart,
      this.youtube,
      this.vimeo,
      this.instagram,
      this.quadTitle,
      this.scaleTitle,
      this.quadHeatmap,
      this.quadCirclePosition,
      this.scaleCirclePosition});

  XmapAllData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    xmapType = json['xmaptype'];
    setupInfo = SetupInfo.fromJson(json['SetupInfo']);
    coverImage = CoverImageModel.fromJson(json['cover_image']);

    json['my_image'] != null ? myImage = ImageModel.fromJson(json['my_image']): myImage = new ImageModel();
    json['text_part']  != null ? textpart = TextPartModel.fromJson(json['text_part']): textpart = new TextPartModel();
    json['youtube']  != null ? youtube = YoutubeModel.fromJson(json['youtube']) : youtube = new YoutubeModel();
    json['vimeo']  != null ? vimeo = VimeoModel.fromJson(json['vimeo']) : vimeo = new VimeoModel();
    json['instagram']  != null ? instagram = InstagramModel.fromJson(json['instagram']) : instagram = new InstagramModel();
    json['quad_title']  != null ? quadTitle = QuadTitleModel.fromJson(json['quad_title']) : quadTitle = new QuadTitleModel();
    json['scale_title']  != null ? scaleTitle = ScaleTitleModel.fromJson(json['scale_title']) : scaleTitle = new ScaleTitleModel();
    json['quad_heatmap']  != null ? quadHeatmap = ChartCirclePosition.fromJson(json['quad_heatmap']) : quadHeatmap = new ChartCirclePosition();
    json['scale_heatmap']  != null ? scaleHeatmap = ChartCirclePosition.fromJson(json['scale_heatmap']) : scaleHeatmap = new ChartCirclePosition();
    json['quad_circle_position']  != null ? quadCirclePosition = CirclePosition.fromJson(json['quad_circle_position']) : quadCirclePosition = new CirclePosition();
    json['scale_circle_position']  != null ? scaleCirclePosition =
        CirclePosition.fromJson(json['scale_circle_position']) : scaleCirclePosition = new CirclePosition();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['xmaptype'] = this.xmapType;
    data['SetupInfo'] = this.setupInfo.toJson();
    data['cover_image'] = this.coverImage.toJson();
    data['my_image'] = this.myImage.toJson();
    data['text_part'] = this.textpart.toJson();
    data['youtube'] = this.youtube.toJson();
    data['vimeo'] = this.vimeo.toJson();
    data['instagram'] = this.instagram.toJson();
    data['quad_title'] = this.quadTitle.toJson();
    data['scale_title'] = this.scaleTitle.toJson();
    data['quad_heatmap'] = this.quadHeatmap.toJson();
    data['scale_heatmap'] = this.scaleHeatmap.toJson();
    data['quad_circle_position'] = this.quadCirclePosition.toJson();
    data['scale_circle_position'] = this.scaleCirclePosition.toJson();
    return data;
  }
}
