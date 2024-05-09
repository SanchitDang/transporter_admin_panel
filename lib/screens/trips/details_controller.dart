import 'package:get/get.dart';

class DetailsController extends GetxController {
  RxList<dynamic> goodsList = RxList<dynamic>();

  void addGoodsFromList(List<dynamic> dataList) {
    goodsList.addAll(dataList);
    update();
  }
}