import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFields = [
  CloudStorageInfo(
    title: "Users",
    numOfFiles: null,
    svgSrc: "assets/icons/menu_profile.svg",
    totalStorage: "300",
    color: primaryColor,
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Drivers",
    numOfFiles: null,
    svgSrc: "assets/icons/menu_doc.svg",
    totalStorage: "20",
    color: Color(0xFFFFA113),
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Warehouses",
    numOfFiles: null,
    svgSrc: "assets/icons/menu_store.svg",
    totalStorage: "40",
    color: Color(0xFFA4CDFF),
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Deliveries",
    numOfFiles: null,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "110",
    color: Color(0xFF007EE5),
    percentage: 100,
  ),
];
