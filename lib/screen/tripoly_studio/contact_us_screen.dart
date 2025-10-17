import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/common_method.dart';
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
                Text("Tripoly Studio", style: GoogleFonts.raleway(textStyle: colorFFFFFFw60025)),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    openSocialLinkIn("https://www.tripolystudio.com/");
                  },
                  child: Row(
                    children: [
                      Image.asset("assets/icon/www.png", scale: 3),
                      SizedBox(width: 5),
                      Text(" www.tripolystudio.com", style: colorFFFFFFw40012),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.facebook.com/tripolystudiopvtltd");
                      },
                      child: Image.asset("assets/icon/facebook.png", scale: 3),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.instagram.com/tripolystudio__official/");
                      },
                      child: Image.asset("assets/icon/instagram.png", scale: 3),
                    ),

                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.youtube.com/user/tripolystudio");
                      },
                      child: Image.asset("assets/icon/youtube.png", scale: 3),
                    ),

                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.behance.net/Tripolystudio1717");
                      },
                      child: Image.asset("assets/icon/behance.png", scale: 4),
                    ),

                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://in.pinterest.com/studiotripoly/");
                      },
                      child: Image.asset("assets/icon/pinterest.png", scale: 3),
                    ),

                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.linkedin.com/company/tripoly-studio-private-limited/");
                      },
                      child: Image.asset("assets/icon/linkedin.png", scale: 3),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Digital Tripoly Studio", style: GoogleFonts.raleway(textStyle: colorFFFFFFw60025)),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    openSocialLinkIn("https://www.digitaltripolystudio.com/");
                  },
                  child: Row(
                    children: [
                      Image.asset("assets/icon/www.png", scale: 3),
                      SizedBox(width: 5),
                      Text("www.digitaltripolystudio.com", style: colorFFFFFFw40012),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.facebook.com/digitaltripolystudio/");
                      },
                      child: Image.asset("assets/icon/facebook.png", scale: 3),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.instagram.com/digitaltripolystudio/");
                      },
                      child: Image.asset("assets/icon/instagram.png", scale: 3),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        openSocialLinkIn("https://www.linkedin.com/company/digitaltripolystudio");
                      },
                      child: Image.asset("assets/icon/linkedin.png", scale: 3),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Contact Us", style: GoogleFonts.raleway(textStyle: colorFFFFFFw60025)),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
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
                Text("Email", style: GoogleFonts.raleway(textStyle: colorFFFFFFw60025)),
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
                SizedBox(height: 20),
                Text("Branches", style: GoogleFonts.raleway(textStyle: colorFFFFFFw60025)),
                SizedBox(height: 20),
                SizedBox(
                  height: 30,
                  child: Wrap(
                    spacing: 5, // horizontal gap
                    runSpacing: 5, // vertical gap
                    children: branchList.map((branch) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(branch, style: colorFF9800w40015),
                          SizedBox(width: 5),
                          Text("|", style: colorFFFFFFw40015),
                          SizedBox(width: 5),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
