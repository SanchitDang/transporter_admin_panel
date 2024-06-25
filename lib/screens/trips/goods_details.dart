import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'details_controller.dart';

class GoodsDetailsPage extends StatefulWidget {
  const GoodsDetailsPage({Key? key}) : super(key: key);

  @override
  State<GoodsDetailsPage> createState() => _GoodsDetailsPageState();
}

class _GoodsDetailsPageState extends State<GoodsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    DetailsController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goods Details"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.goodsList.length,
                  itemBuilder: (context, index) {
                    final dimensionController =
                    controller.goodsList[index]['dimension'];
                    final weightController =
                    controller.goodsList[index]['weight'];
                    final imageFilePath =
                    controller.goodsList[index]['imageFileUrl'];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Row(
                            children: [
                              Text(
                                "Good: ${index + 1}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Builder(
                            builder: (BuildContext context) {
                              final file = imageFilePath;
                              if (file != null || file != '') {
                                return Image.network(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return const Text(
                                  'No image selected',
                                  style: TextStyle(
                                      color: Colors
                                          .red),
                                );
                              }
                            },
                          ),
                        ),
                        Text(
                          dimensionController,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          weightController,
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
