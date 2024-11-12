import 'dart:io';
import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_alert_dialog_widget.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';

class CustomPopScopeWidget extends StatefulWidget {
  final Widget child;
  final Function()? onPopInvoked;
  const CustomPopScopeWidget({Key? key, required this.child, this.onPopInvoked}) : super(key: key);

  @override
  State<CustomPopScopeWidget> createState() => _CustomPopScopeWidgetState();
}

class _CustomPopScopeWidgetState extends State<CustomPopScopeWidget> {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (didPop) {
        if(widget.onPopInvoked != null) {
          widget.onPopInvoked!();
        }

        if(!didPop) {
          showModalBottomSheet(backgroundColor: Colors.transparent, isScrollControlled: false, context: context, builder: (ctx)=> CustomAlertDialogWidget(
            title: getTranslated('close_the_app', context),
            subTitle: getTranslated('do_you_want_to_close_and', context),
            rightButtonText: getTranslated('exit', context),
            iconWidget: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Icon(Icons.logout, color: Colors.white, size: 40),
              ),
            ),
            onPressRight: (){
              exit(0);
            },

          ));
        }
      },
      child: widget.child,
    );
  }
}
