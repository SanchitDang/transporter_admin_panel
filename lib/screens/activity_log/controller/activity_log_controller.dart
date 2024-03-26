import 'package:get/get.dart';

class ActivityLogController extends GetxController {
  //* current step
  RxInt currentStep = 0.obs;

  RxString selectedFieldName = ''.obs;

  //* change selected field name
  void changeSelectedFieldName(String field){
    selectedFieldName = field.obs;
  }

  //* get selected field name
  String getSelectedFieldName(){
    return selectedFieldName.value;
  }

  //* next step
  void continueStep() {
    if (currentStep.value < 6) {
      currentStep.value++;
    }
  }

  //* previous step
  void cancelStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}
