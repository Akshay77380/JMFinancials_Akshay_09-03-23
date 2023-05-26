import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class WebViewLinkScreen extends StatefulWidget {
  final String url;
  final String title;

  WebViewLinkScreen(this.url, this.title);

  @override
  _WebViewLinkScreenState createState() => _WebViewLinkScreenState();
}

class _WebViewLinkScreenState extends State<WebViewLinkScreen> {
  InAppWebViewController webViewController;

  double progress = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(color: theme.textTheme.bodyText1.color),
          ),
          /* Removed by BOB */
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.refresh),
          //     onPressed: () {
          //       if (webViewController != null)
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 WebViewLinkScreen(widget.url, widget.title),
          //           ),
          //         );
          //     },
          //   ),
          // ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.url),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                  ),
                  crossPlatform: InAppWebViewOptions(
                      // debuggingEnabled: false,
                      transparentBackground: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      javaScriptEnabled: true),
                ),
                androidOnPermissionRequest: (controller, origin, resources) async {
                  return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                },
                onWebViewCreated: (controller) {
                  webViewController = controller;

                  controller.addJavaScriptHandler(
                      handlerName: "eDISHandler",
                      callback: (args) {
                        // // Here you receive all the arguments from the JavaScript side
                        // // that is a List<dynamic>
                        // // //print("From the JavaScript side:");
                        // // //print("java script$args");
                        // // goToGPay(args);
                        // // Dataconstants.ismandateComplete =
                        // //     args[0] == 1 ? true : false;
                        // // //print(
                        // //     "Dataconstants.ismandateComplete  => ${Dataconstants.ismandateComplete}");
                        //
                        // for (int i = 0; i < DataConstants.holdingsReportModel.holdings.length; i++) {
                        //   if (DataConstants.holdingsReportModel.holdings[i].clientDPQty == DataConstants.holdingsReportModel.holdings[i].totalQty && DataConstants.newFundWeb[0] == 0) {
                        //     DataConstants.isAuthorized = true;
                        //   } else {
                        //     DataConstants.isAuthorized = false;
                        //     break;
                        //   }
                        // }
                        // DataConstants.itsClient.sendReportRequest(ITSRequestType.holdingReport);
                        // DataConstants.changeTabEdisSuccess = true;
                        // InAppSelection.mainScreenIndex = 3;
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (_) => MainScreen(
                        //           toChangeTab: true,
                        //         )));
                        // return args.reduce((curr, next) => curr + next);
                      });
                  // loadURL();
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onReceivedServerTrustAuthRequest: (controller, challenge) async {
                  return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                },
                onReceivedClientCertRequest: (controller, challenge) async {
                  return ClientCertResponse(action: ClientCertResponseAction.PROCEED);
                },
                onReceivedHttpAuthRequest: (contoller, challenge) async {
                  return HttpAuthResponse(action: HttpAuthResponseAction.PROCEED);
                },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

// void loadURL() {
//   webViewController.
// }
}
