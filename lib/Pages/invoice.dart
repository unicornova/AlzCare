
import 'package:alzcare/api/mobile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/material.dart';




class Pdf extends StatelessWidget {
  const Pdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 216, 230),
      body: Center(
        child: GestureDetector(
          onTap: createPDF,
          child: Container(
            height: 50,
            width: 300,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(6)),
            child:  Center(child: Text('Generate PDF',
            style: TextStyle(color: Colors.blueGrey.shade100, fontSize: 16),
            )),
          ),
        ),
      ),
    );
  }
}


/*Future<void> createPDF() async{
 PdfDocument document = PdfDocument();
 final page = document.pages.add();

 page.graphics.drawString('Welcome!', PdfStandardFont(PdfFontFamily.helvetica, 30));

 List<int> bytes = await document.save();
 document.dispose();

 saveandLaunch(bytes, 'output.pdf');
}*/

/*Future<void> createPDF() async {
  // Fetch user details from Firestore
  final userSnapshot = await FirebaseFirestore.instance.collection('user details').doc('uid').get();
  final userDetails = userSnapshot.data();

  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  // Display user details in the PDF
  final username = userDetails?['username'];
  final birthdate = userDetails?['birthdate'];
  final continent = userDetails?['continent'];
  final country = userDetails?['country'];

  page.graphics.drawString('Name: $username\n', PdfStandardFont(PdfFontFamily.helvetica, 25));
  page.graphics.drawString('Birthdate: $birthdate\n', PdfStandardFont(PdfFontFamily.helvetica, 25));
  page.graphics.drawString('Address: $continent\n', PdfStandardFont(PdfFontFamily.helvetica, 25));
  page.graphics.drawString('Number of Posts: $country\n', PdfStandardFont(PdfFontFamily.helvetica, 25));

  List<int> bytes = await document.save();
  document.dispose();

  saveandLaunch(bytes, 'output.pdf');
}*/

Future<void> createPDF() async {
  // Fetch user details from Firestore
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userSnapshot = await FirebaseFirestore.instance.collection('user details').doc(currentUser.uid).get();
  final userDetails = userSnapshot.data();

  final postsQuery = FirebaseFirestore.instance.collection('user posts').where('UserEmail', isEqualTo: currentUser.email);
  final postsSnapshot = await postsQuery.get();
  final numberOfPosts = postsSnapshot.size;

  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  // Display user details in the PDF
  final username = userDetails?['username'];
  final continent = userDetails?['continent'];
  final country = userDetails?['country'];
  final city = userDetails?['city'];
  final state = userDetails?['state'];
  final phone = userDetails?['phoneNumber'];

  final startY = 50.0; // Adjust the starting Y position as needed
  final spacing = 40.0;

  double currentY = startY;

  // Display the heading in bold and center-align
  final fontBold = PdfStandardFont(PdfFontFamily.helvetica, 40);
  const headingText = 'Your Details';
  final headingSize = fontBold.measureString(headingText).width;
  final headingX = (page.getClientSize().width - headingSize) / 2;
  page.graphics.drawString(headingText, fontBold, brush: PdfSolidBrush(PdfColor(0, 0, 0)), bounds: Rect.fromLTWH(headingX, 50, headingSize, fontBold.height));
  currentY += 70.0;
  

  final font = PdfStandardFont(PdfFontFamily.helvetica, 30);

  final lineHeight = font.height * 1.5; // Adjust the line height as needed

  

  page.graphics.drawString('Userame: $username', font, bounds: Rect.fromLTWH(50, currentY, page.getClientSize().width - 100, lineHeight));
  currentY += spacing;

  page.graphics.drawString('Continent: $continent', font, bounds: Rect.fromLTWH(50, currentY, page.getClientSize().width - 100, lineHeight));
  currentY += spacing;

  page.graphics.drawString('Country: $country', font, bounds: Rect.fromLTWH(50, currentY, page.getClientSize().width - 100, lineHeight));
  currentY += spacing;

  page.graphics.drawString('State: $state', font, bounds: Rect.fromLTWH(50, currentY, page.getClientSize().width - 100, lineHeight));
  currentY += spacing;

  page.graphics.drawString('City: $city', font, bounds: Rect.fromLTWH(50, currentY, page.getClientSize().width - 100, lineHeight));
  currentY += spacing;

  page.graphics.drawString('Phone: $phone', font, bounds: Rect.fromLTWH(50, currentY, page.getClientSize().width - 100, lineHeight));
  currentY += spacing;

  page.graphics.drawString('Number of Posts: $numberOfPosts', font, bounds: Rect.fromLTWH(50, currentY, page.getClientSize().width - 100, lineHeight));
  currentY += spacing;

  List<int> bytes = await document.save();
  document.dispose();

  saveandLaunch(bytes, 'output.pdf');
}






