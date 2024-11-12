import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:resturant_delivery_boy/helper/location_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/features/order/providers/order_provider.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/common/providers/tracker_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/features/home/widgets/order_widget.dart';
import 'package:resturant_delivery_boy/features/language/screens/choose_language_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).getAllOrders(context);
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    LocationHelper.checkPermission(context);    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leadingWidth: 0,
        actions: [
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              if(orderProvider.currentOrders.isNotEmpty) {
                for(OrderModel order in orderProvider.currentOrders) {
                  if(order.orderStatus == 'out_for_delivery') {
                    Provider.of<TrackerProvider>(context, listen: false).setOrderID(order.id!);
                    Provider.of<TrackerProvider>(context, listen: false).startLocationService();
                    break;
                  }
                }
              }
              return orderProvider.currentOrders.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(icon: Icon(Icons.refresh, color: Theme.of(context).textTheme.bodyLarge!.color),
                  onPressed: () {
                    orderProvider.refresh(context);
                  });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'language':
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChooseLanguageScreen(fromHomeScreen: true)));
              }
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'language',
                child: Row(
                  children: [
                    Icon(Icons.language, color: Theme.of(context).textTheme.bodyLarge!.color),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    Text(
                      getTranslated('change_language', context)!,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
        leading: const SizedBox.shrink(),
        title: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => profileProvider.userInfoModel != null
              ? Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomImageWidget(
                          placeholder: Images.placeholderUser, width: 40, height: 40, fit: BoxFit.fill,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${profileProvider.userInfoModel!.image}',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel?.lName ?? ''}',
                      style:
                          Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                    )
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) => Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getTranslated('active_order', context)!, style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    )),
                    const SizedBox(height: 10),

                    Expanded(
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        displacement: 0,
                        color: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        onRefresh: () {
                          return orderProvider.refresh(context);
                        },
                        child: orderProvider.currentOrders.isNotEmpty
                            ? orderProvider.currentOrders.isNotEmpty
                                ? ListView.builder(
                                    itemCount: orderProvider.currentOrders.length,
                                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    itemBuilder: (context, index) => OrderWidget(
                                      orderModel: orderProvider.currentOrders[index],
                                      index: index,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      getTranslated('no_order_found', context)!,
                                      style: Theme.of(context).textTheme.displaySmall,
                                    ),
                                  )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
