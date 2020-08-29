import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatefulWidget {
  static const routeName = '/imageView';

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  Color _color;
  bool _isLoading = true;
  bool code = false;
  String passValue = "";

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    passValue = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Image View",
          style: TextStyle(color: _color),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: _color),
        actions: [
          IconButton(
              icon: Icon(
                Icons.file_download,
                color: _color,
              ),
              onPressed: () async {
                final status = await Permission.storage.request();

                if (status.isGranted) {
                  final externalDir = await getExternalStorageDirectory();
                  final taskId = await FlutterDownloader.enqueue(
                    url: passValue,
                    savedDir: externalDir.path,
                    showNotification: true,
                    openFileFromNotification: true,
                  );
                }
              })
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(passValue),
        ),
      ),
    );
  }
}
