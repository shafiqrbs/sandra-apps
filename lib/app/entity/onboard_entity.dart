import 'package:sandra/app/entity/business_type.dart';

class OnboardEntity {
  List<BusinessType>? demo;
  String? videoUrl;
  String? termsCondition;
  String? aboutus;
  int? onboard;

  OnboardEntity({
    this.demo,
    this.videoUrl,
    this.termsCondition,
    this.aboutus,
    this.onboard,
  });

  factory OnboardEntity.fromJson(Map<String, dynamic> json) {
    return OnboardEntity(
      demo: json['demo'] != null
          ? (json['demo'] as List).map((i) => BusinessType.fromJson(i)).toList()
          : null,
      onboard: json['onboard'] as int?,
      videoUrl: json['video_url'] as String?,
      termsCondition: json['terms_condition'] as String?,
      aboutus: json['aboutus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_type_list': demo?.map((e) => e.toJson()).toList(),
      'onboard': onboard,
      'video_url': videoUrl,
      'terms_condition': termsCondition,
      'aboutus': aboutus,
    };
  }
}
