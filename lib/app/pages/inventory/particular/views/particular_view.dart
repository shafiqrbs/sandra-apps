import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/particular/controllers/particular_controller.dart';

//ignore: must_be_immutable
class ParticularView extends BaseView<ParticularController> {
  ParticularView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  