import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/features/profile/widgets/theme_status_widget.dart';
import 'package:resturant_delivery_boy/features/html/screens/html_viewer_screen.dart';
import 'package:resturant_delivery_boy/features/profile/widgets/profile_button_widget.dart';

import '../widgets/sign_out_dialog_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => profileProvider.isLoading ? const Center(child: CircularProgressIndicator()) :
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(
                        getTranslated('my_profile', context)!,
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CustomImageWidget(
                              placeholder: Images.placeholderUser,
                              width: 80, height: 80, fit: BoxFit.fill,
                              image: '${splashProvider.baseUrls?.deliveryManImageUrl}/${profileProvider.userInfoModel?.image}',
                            )),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Text(
                       '${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel?.lName ?? ''}',
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('theme_style', context)!,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                          const ThemeStatusWidget()
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel!.fName),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel!.lName),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel!.phone),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      ProfileButtonWidget(icon: Icons.privacy_tip, title: getTranslated('privacy_policy', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: true)));
                      }),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      ProfileButtonWidget(icon: Icons.list, title: getTranslated('terms_and_condition', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: false)));
                      }),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      ProfileButtonWidget(icon: Icons.logout, title: getTranslated('logout', context), onTap: () {
                        showDialog(context: context, barrierDismissible: false, builder: (context) => const SignOutDialogWidget());
                      }),


                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _userInfoWidget({String? text, required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: Theme.of(context).canvasColor,
          border: Border.all(color: const Color(0xFFDCDCDC)),
      ),
      child: Text(
        text ?? '',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
