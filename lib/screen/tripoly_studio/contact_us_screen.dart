import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utility/colors.dart';
import '../../utility/text_style.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    List branchList = ["AHMEDABAD", "RAJKOT", "SURAT", "MUMBAI", "GURUGRAM", "BENGALURU", "DUBAI", "AUSTRALIA"];
    return Scaffold(
      backgroundColor: color000000,
      appBar: AppBar(
        backgroundColor: color000000,
        elevation: 0,
        leadingWidth: 220,
        leading: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Text("Contact Us", style: colorFFFFFFw40025),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("TriPoly Studio", style: GoogleFonts.raleway(textStyle: color000000w60025)),
                Image.asset("assets/icon/logo_black.png", scale: 2, color: colorFFFFFF),
                SizedBox(height: 10),
                Text(
                  "Tripolystudio Pvt. Ltd. proudly marks its 18th year as at rusted name in real estate and architectural visualization. We specialize in delivering high-quality 3D architectural and interior renderings, 3D walkthroughs,video presentations, facade designs, branding, and cutting-edge 360°, AR, and VR solutions.",
                  style: colorFFFFFFw40015,
                ),
                SizedBox(height: 10),
                Text(
                  "To further elevate immersive experiences, we have launched a dedicated division under the name 360EdgeVision, with the tagline “Beyond Vision,Into Experience.” Through 360EdgeVision, we focus exclusively on real estate projects,offering interactive 360°, AR, and VR solutions that make it easier for developers to present project information, and for customers to explore and understand spaces with clarity and impact.",
                  style: colorFFFFFFw40015,
                ),
                SizedBox(height: 20),
                Container(
                      decoration: BoxDecoration(
                        color: color000000,
                        border: Border.all(color: colorFF9800, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Contact Us", style: colorFFFFFFw40020),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () async {
                                //for direct phone call...............
                                // const number = '9898869160'; //set the number here
                                // await FlutterPhoneDirectCaller.callNumber(number);

                                /// for open in phone app........................
                                final Uri phoneUri = Uri(scheme: 'tel', path: '+91 9898869160');
                                await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
                              },
                              child: Row(
                                children: [
                                  Image.asset("assets/icon/phone_logo.png", scale: 3),
                                  SizedBox(width: 5),
                                  Text("+91 9898869160", style: colorFFFFFFw40012),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .move(
                      duration: 1000.ms,
                      begin: const Offset(-200, 0), // from left
                      end: Offset.zero,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(duration: 1000.ms),
                SizedBox(height: 10),
                Container(
                      decoration: BoxDecoration(
                        color: color000000,
                        border: Border.all(color: colorFF9800, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", style: colorFFFFFFw40020),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () async {
                                final String email = 'info@tripolystudio.com';
                                final Uri emailUri = Uri(scheme: 'mailto', path: email);
                                await launchUrl(emailUri);
                              },
                              child: Row(
                                children: [
                                  Image.asset("assets/icon/email_logo.png", scale: 3),
                                  SizedBox(width: 5),
                                  Text("info@tripolystudio.com", style: colorFFFFFFw40012),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .move(
                      duration: 1000.ms,
                      begin: const Offset(-200, 0), // from left
                      end: Offset.zero,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(duration: 1000.ms),
                SizedBox(height: 20),
                Text("Branches", style: GoogleFonts.raleway(textStyle: colorFFFFFFw60025)),
                SizedBox(height: 20),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    itemCount: branchList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Text(branchList[index], style: colorFF9800w40015),
                        SizedBox(width: 5),
                        Text("|", style: colorFFFFFFw40015),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
