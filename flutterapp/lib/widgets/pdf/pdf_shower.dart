import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/app_bar/xtm_app_bar.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  final String path;
  final String titleStr;
  PDFViewerPage({this.path, this.titleStr});

  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String pdfFilePath = '';

  @override
  void initState() {
    super.initState();

    pdfFilePath = widget.path;
  }

  Future<String> downApkFunction() async {
    {
      final directory = await getTemporaryDirectory();
      String savePath = directory.path;
      String appName = "temp.pdf";
      String fileFullPath = "${savePath}/${appName}";
      Dio dio = Dio();

      String token = xtmGlobalStore.auth.token ?? '';
      await dio.download(widget.path, fileFullPath, options: Options(headers: {'token': token}));
      return fileFullPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.titleStr != null ? XtmAppBar(title: widget.titleStr) : null,
      body: _buildBody(),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          return Container();
        },
      ),
    );
  }

  Widget _buildBody() {
    Widget pdfView;
    if (widget.path.startsWith('http')) {
      pdfView = FutureBuilder<String>(
        future: downApkFunction(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            String response = snapshot.data;
            return _buildPdfView(response);
          }
          return Container();
        },
      );
    } else {
      pdfView = _buildPdfView(widget.path);
    }
    return SafeArea(
      child: Container(
        margin: widget.titleStr != null ? EdgeInsets.all(15) : EdgeInsets.zero,
        padding: widget.titleStr != null ? EdgeInsets.all(15) : EdgeInsets.zero,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Stack(
              children: [
                pdfView,
                errorMessage.isEmpty
                    ? !isReady
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container()
                    : Center(
                        child: Text(errorMessage),
                      )
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfView(String pdfFilePath) {
    return PDFView(
      filePath: pdfFilePath,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      pageFling: true,
      pageSnap: true,
      defaultPage: currentPage,
      fitPolicy: FitPolicy.BOTH,
      preventLinkNavigation: false,
      onRender: (_pages) {
        setState(() {
          pages = _pages;
          isReady = true;
        });
      },
      onError: (error) {
        setState(() {
          errorMessage = error.toString();
        });
      },
      onPageError: (page, error) {
        setState(() {
          errorMessage = '$page: ${error.toString()}';
        });
      },
      onViewCreated: (PDFViewController pdfViewController) {
        _controller.complete(pdfViewController);
      },
      onLinkHandler: (String uri) {},
      onPageChanged: (int page, int total) {
        setState(() {
          currentPage = page;
        });
      },
    );
  }
}
