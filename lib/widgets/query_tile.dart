import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:syncia/widgets/markdown_response_tile.dart';

class QueryTile extends StatefulWidget {
  const QueryTile(
      {Key? key,
      required this.isLast,
      required this.isRead,
      required this.query,
      required this.response})
      : super(key: key);
  final bool isLast;
  final bool isRead;
  final String query;
  final String response;

  @override
  State<QueryTile> createState() => _QueryTileState();
}

class _QueryTileState extends State<QueryTile> {
  bool _showFormatted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.grey.withOpacity(0.15),
          child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(left: BorderSide(color: Colors.blue, width: 3.0))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SelectableText(
                        widget.query,
                        style: const TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.normal),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          color: Colors.blue,
                          tooltip: 'copy response',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.response));
                          }, icon: const Icon(Icons.copy, color: Colors.black,)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          title: widget.isLast &&
                  !widget.isRead && !_showFormatted// Check if it's the latest response
              ? AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(widget.response),
                  ],
                  totalRepeatCount: 1,
            onFinished: (){
              setState(() {
                _showFormatted = true;
              });
            },
                )
              : MarkdownResponseTile(response: widget.response),
        ),
      ],
    );
  }
}
