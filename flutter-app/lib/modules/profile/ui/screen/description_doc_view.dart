import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum DescriptionViewType {
  aboutApp("About App"),
  privacyPolicy("Privacy Policy"),
  termsAndCondition("Terms & Conditions"),
  acceptableUsePolicy("Acceptable Use Policy"),
  cookiesPolicy("Cookies Policy"),
  dataOwnershipPolicy("Data Ownership Policy"),
  refundPolicy("Refund Policy");

  final String name;
  const DescriptionViewType(this.name);
}

class DescriptionDocView extends StatelessWidget {
  final DescriptionViewType descriptionScreenType;
  final String descriptionText;
  const DescriptionDocView({
    super.key,
    required this.descriptionScreenType,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: BackButton(),
                  title: Text(
                    descriptionScreenType.name
                  ),
                ),
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Markdown(
                      data: descriptionText,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ).copyWith(h2Padding: EdgeInsets.only(bottom: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
