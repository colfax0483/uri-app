import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

import 'bloc.dart';
class PocWidget extends StatefulWidget{
  PocWidget({Key key}) : super(key: key);

  @override
  _MyPocWidgetState createState() => _MyPocWidgetState();
}

class _MyPocWidgetState extends State<PocWidget> {
  var initurl, inittoken;
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              child: Center(
                  child: Text('No deep link was used  ',
                      style: Theme.of(context).textTheme.title)));
        } else {

          log('data: ${snapshot.data}');
          Uri initialUri = Uri.parse(snapshot.data);
          final params = initialUri?.queryParametersAll?.entries?.toList();
          log("---------------params : ${params}");
          var cUrl = params[0].value;
          var cInittoken = params[1].value;
          log("---------------params con : ${params[0]}");

          initialUri.queryParameters.forEach((i, k){
            log('=key: $i - value: $k');
            if(i == 'url') {
              initurl = k.toString();
              log("---k : ${initurl}");
            }
            else if(i == 'token'){
              inittoken = k.toString();
            }
          });
          return Scaffold(
            body: SafeArea(
                child: InAppWebView(
                  initialUrl: initurl,
                  initialHeaders: {},
                  onWebViewCreated: (InAppWebViewController controller) {
                    //webView = controller;

                    controller.addJavaScriptHandler(handlerName: "Print", callback: (args) {
                      print("From the JavaScript side:");
                      print(args);
                      return args;
                    });
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                  },
                  onLoadStop: (InAppWebViewController controller, String url) {
                  },
                  onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
                    log("Console: ${consoleMessage.message}");
                    showToast(consoleMessage.message);
                  },
                ),
            ),
          );
      /*
          return Container(
              child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Redirected: ${snapshot.data}\nurl: ${initurl}\ntoken: ${inittoken}',
                          style: Theme.of(context).textTheme.title))));
*/

        }
      },
    );
  }

}
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM
  );
}