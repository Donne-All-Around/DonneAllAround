import 'package:daum_postcode_search/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PostcodeSearchPage extends StatefulWidget {
  const PostcodeSearchPage({super.key});

  @override
  State<PostcodeSearchPage> createState() => _PostcodeSearchPageState();
}

class _PostcodeSearchPageState extends State<PostcodeSearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text("다음 주소 검색")),
        body: DaumPostcodeSearch(
          webPageTitle: "다음 주소 검색",
          initialOption: InAppWebViewGroupOptions(),
          onConsoleMessage: ((controller, consoleMessage) {}),
          onLoadError: ((controller, url, code, message) {}),
          onLoadHttpError: (controller, url, statusCode, description) {},
          onProgressChanged: (controller, progress) {},
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
        ),
      ),
    );;
  }
}
