import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:markdown/markdown.dart' as md;

import '../controllers/theme_controller.dart';


class MarkdownResponseTile extends StatelessWidget {
  final String response;
  const MarkdownResponseTile({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      title: Markdown(
        padding: EdgeInsets.zero,
        selectable: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        data: response,
        builders: {
          'code': CodeBlockBuilder(),
        },
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          // Adjust font sizes as needed:
          p: const TextStyle(fontSize: 16),
          h1: const TextStyle(fontSize: 24),
          // ... add other styles if needed
        ),
      ),
    );

  }

}

class CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  void visitElementBefore(md.Element element) {}

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) => null;

  @override
  Widget? visitElementAfterWithContext(
      BuildContext context,
      md.Element element,
      TextStyle? preferredStyle,
      TextStyle? parentStyle,
      ) {
    if (element.tag == "code") {
      String? language = element.attributes['class']?.split('-').last;
      language ??= "Code Block";
      if (element.textContent.contains('\n')) {
        // Assume this is a block-level code element.
        return Obx((){
          final containerHeadingBackgroundColor = ThemeController.to.isDarkTheme.value ? HexColor('#212121') : Colors.grey[200];
          final containerBackgroundColor = ThemeController.to.isDarkTheme.value ? HexColor('#333333') : Colors.grey[200];
          final headingIconColor = ThemeController.to.isDarkTheme.value ? Colors.white : Colors.black;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 0),
            decoration: BoxDecoration(
              color: containerBackgroundColor,
              border: Border.all(color: Colors.black12, width: 1.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: containerHeadingBackgroundColor,
                      border: const Border(
                        left: BorderSide(color: Colors.blue, width: 3.0),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            language!,
                            textStyle: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                        totalRepeatCount: 1,
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: element.textContent));
                        },
                        icon: Icon(
                          Icons.copy,
                          color: headingIconColor,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SelectableText(
                    element.textContent,
                    style: const TextStyle(fontSize: 16.0, fontFamily: 'Courier New'),
                  ),
                ),
              ],
            ),
          );
        });
      } else {
        // This is likely an inline code element.
        return Obx((){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Container(
              color: ThemeController.to.isDarkTheme.value ? HexColor('#333333') : Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: SelectableText(
                element.textContent,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Courier New',
                ),
              ),
            ),
          );
        });
      }
    }
    return null;
  }
}


