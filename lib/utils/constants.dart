import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color scaffoldColor = Color(0xFFFFFFFF);
const Color primaryColor = Color(0xFF3A3A3A);
const Color secondaryColor = Color(0xFFFCC97C);
const Color neutralColor = Color(0xFFEDEEF0);
const Color fillColor = Color(0xFFFFFFFF);
const Color secondaryButtonTextColor = Color(0xFF1D2125);
const Color arrowBackColor = Color(0xFF0C192C);
const Color navigationIconColor = Color(0xFFC2C5CA);
const Color yellowColor = Color(0xFFED8E00);
const Color secondaryFocusColor = Color(0xFFF69400);
const Color redColor = Color(0xFFF83B00);
const Color whiteColor = Color(0xFFFFFFFF);
const Color successColor = Color(0xFF00CF39);
const Color primarySurfaceColor = Color(0xFFF3F3F3);

final heading1 = GoogleFonts.plusJakartaSans(
  fontSize: 32,
  fontWeight: FontWeight.w700,
  color: const Color(0xFF160D07),
);
final heading2 = GoogleFonts.plusJakartaSans(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: const Color(0xFF160D07),
);

final descriptionStyle = GoogleFonts.plusJakartaSans(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF767D88),
);

final largeTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: const Color(0xFF160D07),
);
final smallTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: const Color(0xFF160D07),
);
final mediumTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: const Color(0xFF160D07),
);
final xSmallTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF767D88),
);
final xXSmallTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 10,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF767D88),
);
final hintTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: const Color(0xFF9FA4AB),
);

final inputTextStyle = GoogleFonts.plusJakartaSans(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: const Color(0xFF160D07),
);

List<BoxShadow> kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 0,
    blurRadius: 16,
    offset: const Offset(0, -4),
  ),
];
List<BoxShadow> kYellowBoxShadow = [
  BoxShadow(
    color: Colors.amber.withOpacity(0.8),
    spreadRadius: 0,
    blurRadius: 16,
    offset: const Offset(0, -4),
  ),
];

const listViewSeparator = Divider(
  color: Color(0xFFEDEEF0),
  height: 2,
);

// Global
// ignore_for_file: constant_identifier_names

const String BASE_API_URL = "https://devapi.pixelone.app/ems/api/v2";

// Signup page

const String HT_FULL_NAME = "Your full name";
const String HT_EMAIL_ADDRESS = "Email address";
const String HT_BUSINESS_NAME = "Business name";
const String HT_PASSWORD = "Password";
const String HT_PHONE_NO = "Phone Number";
const String LABEL_REGISTER = "Register";

const String SH_FULL_NAME_ERROR = "Please Enter Your Full Name";
const String SH_BUSINESS_ERROR = "Please Enter Your Business";
const String SH_EMAIL_ERROR = "Please Enter Email Address";
const String SH_PASSWORD_ERROR = "Please Enter Password";
const String SH_PHONENO_ERROR = "Please Enter Phone Number";

// Authentication Errors
const String HT_ERROR = "Could not authenticate you. Please try again later.";

// Empty Product Errors
const String T_ERROR = "There is No Product To Show Try TO Add From PixelOne ";
const String SCAFFOLD_ERROR = "No Product On PixelOne Try TO Add Some Product";
