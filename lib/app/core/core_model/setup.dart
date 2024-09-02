class SetUp {
  int? setupId;
  int? deviceId;
  String? uniqueCode;
  String? name;
  String? mobile;
  String? tawk;
  String? pixel;
  String? messenger;
  String? analytic;
  String? email;
  int? locationId;
  String? address;
  String? locationName;
  int? mainApp;
  String? mainAppName;
  String? appsManual;
  String? website;
  String? vatRegNo;
  int? vatPercentage;
  int? productColumn;
  int? productFeatureColumn;
  String? currency;
  int? preOrder;
  String? cartProcess;
  int? shippingCharge;
  int? cashOnDelivery;
  int? pickupLocation;
  String? poweredBy;
  String? introTitle;
  String? appHeaderBg;
  String? appPrimaryColor;
  String? appSecondaryColor;
  String? appBarColor;
  String? appTextTitle;
  String? appTextColor;
  String? appCartColor;
  String? appMoreColor;
  String? appBorderColor;
  String? appPositiveColor;
  String? appNegativeColor;
  String? appDiscountColor;
  String? appIconColor;
  String? appAnchorColor;
  String? appAnchorHoverColor;
  String? searchPageBgColor;
  String? morePageBgColor;
  String? logo;
  String? intro;
  int? homeFeatureCategory;
  int? homeFeatureBrand;
  int? homeFeatureDiscount;
  int? homeFeaturePromotion;
  String? appFooterBgColor;
  String? appFooterIconBgColor;
  String? appFooterIconColor;
  String? appBorderActiveColor;
  String? appBorderInactiveColor;
  String? appFooterIconColorHover;
  String? appSuccessColor;
  String? appNoticeColor;
  String? appCloseColor;
  String? bodyBg;
  String? inputBgColor;
  String? inputBgFocusColor;
  int? homeSlider;
  String? lang;
  String? printFooter;
  String? symbol;

  static SetUp? _instance;

  factory SetUp() => _instance ??= SetUp._internal();

  SetUp._internal();

  factory SetUp.fromJson(Map<String, dynamic> json) {
    return SetUp()
      ..setupId = json['setupId']
      ..deviceId = json['deviceId']
      ..uniqueCode = json['uniqueCode']
      ..name = json['name']
      ..mobile = json['mobile']
      ..tawk = json['tawk']
      ..pixel = json['pixel']
      ..messenger = json['messenger']
      ..analytic = json['analytic']
      ..email = json['email']
      ..locationId = json['locationId']
      ..address = json['address']
      ..locationName = json['locationName']
      ..mainApp = json['main_app']
      ..mainAppName = json['main_app_name']
      ..appsManual = json['appsManual']
      ..website = json['website']
      ..vatRegNo = json['vatRegNo']
      ..vatPercentage = json['vatPercentage']
      ..productColumn = json['productColumn']
      ..productFeatureColumn = json['productFeatureColumn']
      ..currency = json['currency']
      ..preOrder = json['preOrder']
      ..cartProcess = json['cartProcess']
      ..shippingCharge = json['shippingCharge']
      ..cashOnDelivery = json['cashOnDelivery']
      ..pickupLocation = json['pickupLocation']
      ..poweredBy = json['poweredBy']
      ..introTitle = json['introTitle']
      ..appHeaderBg = json['appHeaderBg']
      ..appPrimaryColor = json['appPrimaryColor']
      ..appSecondaryColor = json['appSecondaryColor']
      ..appBarColor = json['appBarColor']
      ..appTextTitle = json['appTextTitle']
      ..appTextColor = json['appTextColor']
      ..appCartColor = json['appCartColor']
      ..appMoreColor = json['appMoreColor']
      ..appBorderColor = json['appBorderColor']
      ..appPositiveColor = json['appPositiveColor']
      ..appNegativeColor = json['appNegativeColor']
      ..appDiscountColor = json['appDiscountColor']
      ..appIconColor = json['appIconColor']
      ..appAnchorColor = json['appAnchorColor']
      ..appAnchorHoverColor = json['appAnchorHoverColor']
      ..searchPageBgColor = json['searchPageBgColor']
      ..morePageBgColor = json['morePageBgColor']
      ..logo = json['logo']
      ..intro = json['intro']
      ..homeFeatureCategory = json['homeFeatureCategory']
      ..homeFeatureBrand = json['homeFeatureBrand']
      ..homeFeatureDiscount = json['homeFeatureDiscount']
      ..homeFeaturePromotion = json['homeFeaturePromotion']
      ..appFooterBgColor = json['appFooterBgColor']
      ..appFooterIconBgColor = json['appFooterIconBgColor']
      ..appFooterIconColor = json['appFooterIconColor']
      ..appBorderActiveColor = json['appBorderActiveColor']
      ..appBorderInactiveColor = json['appBorderInactiveColor']
      ..appFooterIconColorHover = json['appFooterIconColorHover']
      ..appSuccessColor = json['appSuccessColor']
      ..appNoticeColor = json['appNoticeColor']
      ..appCloseColor = json['appCloseColor']
      ..homeSlider = json['homeSlider']
      ..bodyBg = json['bodyBg']
      ..inputBgColor = json['inputBgColor']
      ..inputBgFocusColor = json['inputBgFocusColor']
      ..printFooter = json['printFooter']
      ..symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    return {
      'setupId': setupId,
      'deviceId': deviceId,
      'uniqueCode': uniqueCode,
      'name': name,
      'mobile': mobile,
      'tawk': tawk,
      'pixel': pixel,
      'messenger': messenger,
      'analytic': analytic,
      'email': email,
      'locationId': locationId,
      'address': address,
      'locationName': locationName,
      'main_app': mainApp,
      'main_app_name': mainAppName,
      'appsManual': appsManual,
      'website': website,
      'vatRegNo': vatRegNo,
      'vatPercentage': vatPercentage,
      'productColumn': productColumn,
      'productFeatureColumn': productFeatureColumn,
      'currency': currency,
      'preOrder': preOrder,
      'cartProcess': cartProcess,
      'shippingCharge': shippingCharge,
      'cashOnDelivery': cashOnDelivery,
      'pickupLocation': pickupLocation,
      'poweredBy': poweredBy,
      'introTitle': introTitle,
      'appHeaderBg': appHeaderBg,
      'appPrimaryColor': appPrimaryColor,
      'appSecondaryColor': appSecondaryColor,
      'appBarColor': appBarColor,
      'appTextTitle': appTextTitle,
      'appTextColor': appTextColor,
      'appCartColor': appCartColor,
      'appMoreColor': appMoreColor,
      'appBorderColor': appBorderColor,
      'appPositiveColor': appPositiveColor,
      'appNegativeColor': appNegativeColor,
      'appDiscountColor': appDiscountColor,
      'appIconColor': appIconColor,
      'appAnchorColor': appAnchorColor,
      'appAnchorHoverColor': appAnchorHoverColor,
      'searchPageBgColor': searchPageBgColor,
      'morePageBgColor': morePageBgColor,
      'logo': logo,
      'intro': intro,
      'homeFeatureCategory': homeFeatureCategory,
      'homeFeatureBrand': homeFeatureBrand,
      'homeFeatureDiscount': homeFeatureDiscount,
      'homeFeaturePromotion': homeFeaturePromotion,
      'appFooterBgColor': appFooterBgColor,
      'appFooterIconBgColor': appFooterIconBgColor,
      'appFooterIconColor': appFooterIconColor,
      'appBorderActiveColor': appBorderActiveColor,
      'appBorderInactiveColor': appBorderInactiveColor,
      'appFooterIconColorHover': appFooterIconColorHover,
      'appNoticeColor': appNoticeColor,
      'appSuccessColor': appSuccessColor,
      'appCloseColor': appCloseColor,
      'homeSlider': homeSlider,
      'bodyBg': bodyBg,
      'inputBgColor': inputBgColor,
      'inputBgFocusColor': inputBgFocusColor,
      'printFooter': printFooter,
      'symbol': symbol,
    };
  }
}
