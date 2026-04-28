import 'package:flutter/material.dart';
import 'package:flutter_proj/models/widget/upload_image_model.dart';
import 'package:flutter_proj/widgets/image/image_upload.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class RegisterStepWidget extends StatefulWidget {
  final String title;
  final String businessSource;
  final List<UploadImageModel> uploadImages;
  final VoidCallback imgUploadSuccess;

  RegisterStepWidget({
    Key key,
    @required this.businessSource,
    this.title,
    this.uploadImages,
    this.imgUploadSuccess,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterStepWidgetState();
}

class _RegisterStepWidgetState extends State<RegisterStepWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width - 80;
    final double height = width / 5 * 3.3;
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XtmBlockHeader(headerTitle: widget.title),
          SizedBox(height: 15.0),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 15.0);
              },
              itemCount: widget.uploadImages.length,
              itemBuilder: (context, index) {
                return Center(
                  child: ImageUpload(
                    width: width,
                    height: height,
                    fit: BoxFit.fill,
                    imgId: widget.uploadImages[index].imgId,
                    businessSource: widget.businessSource,
                    imgDesc: widget.uploadImages[index].imageDesc,
                    imageType: widget.uploadImages[index].imageType,
                    isRequired: widget.uploadImages[index].isRequired,
                    onImageUploaded: (fileId) {
                      widget.uploadImages[index].imgId = fileId;
                      if (widget.imgUploadSuccess != null) {
                        widget.imgUploadSuccess();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
