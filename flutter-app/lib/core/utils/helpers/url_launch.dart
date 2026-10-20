import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(Uri appUri, Uri webUri) async {
    try {
      if (!await launchUrl(appUri, mode: LaunchMode.externalApplication)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }