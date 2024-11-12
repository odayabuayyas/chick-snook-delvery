import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/common/models/config_model.dart';
import 'package:resturant_delivery_boy/common/models/policy_model.dart';
import 'package:resturant_delivery_boy/features/splash/domain/reposotories/splash_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker_helper.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  PolicyModel? _policyModel;


  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  PolicyModel? get policyModel => _policyModel;


  Future<bool> initConfig(BuildContext context) async {
    ApiResponseModel apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      ApiCheckerHelper.checkApi(apiResponse);
    }
    return isSuccess;
  }

  Future<bool> getPolicyPage() async {
    ApiResponseModel apiResponse = await splashRepo!.getPolicyPage();
    bool isSuccess;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _policyModel = PolicyModel.fromJson(apiResponse.response!.data);
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      ApiCheckerHelper.checkApi(apiResponse);
    }

    return isSuccess;
  }


  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }


}