import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliveries Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Completed",
            amountOfFiles: "13",
            numOfFiles: null,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Out for Picking",
            amountOfFiles: "15",
            numOfFiles: null,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Out for Delivery",
            amountOfFiles: "18",
            numOfFiles: null,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "In Transit",
            amountOfFiles: "16",
            numOfFiles: null,
          ),
        ],
      ),
    );
  }
}
