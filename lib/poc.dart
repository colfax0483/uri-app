import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
                child:
                WebView(
                  initialUrl: initurl,
                  javascriptMode: JavascriptMode.unrestricted,
                )
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
