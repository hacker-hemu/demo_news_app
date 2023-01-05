import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../components/likeCommentShare.dart';
import '../constants/constants.dart';

class EpaperViewScreen extends StatefulWidget {
  final url;
  final name;
  final date;

  const EpaperViewScreen({Key? key, this.url, this.name, this.date})
      : super(key: key);

  @override
  State<EpaperViewScreen> createState() => _EpaperViewScreenState();
}

class _EpaperViewScreenState extends State<EpaperViewScreen> {
  bool loading = true;
  late PDFDocument pdfDocument;

  _loadEpaper() async {
    pdfDocument = await PDFDocument.fromURL(widget.url);

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // epaper load function
    _loadEpaper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}'),
        actions: [
          //share
          likeShareComment(
              label: '',
              icon: FontAwesomeIcons.shareNodes,
              iconColor: Colors.white,
              onPressed: () {
                Share.share(
                    '${widget.name}\n\n\n${widget.date}\n\n\nन्यूज़ के लिए आज ही ऐप इंस्टॉल करें।\n\n$playStoreAppLink\n\n\nसंपर्क करें: $clientMobileNumber\nEmail: $clientEmail\n\n\n',
                    subject: 'Look what I made!');
              }),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(document: pdfDocument),
    );
  }
}
