import 'dart:convert';

TermsData termsDataFromJson(String str) => TermsData.fromJson(json.decode(str));

String termsDataToJson(TermsData data) => json.encode(data.toJson());

class TermsData {
  TermsData({
    required this.terms1,
    required this.terms2,
    required this.terms3,
  });

  String terms1;
  String terms2;
  String terms3;

  factory TermsData.fromJson(Map<String, dynamic> json) => TermsData(
        terms1: json["terms1"],
        terms2: json["terms2"],
        terms3: json["terms3"],
      );

  Map<String, dynamic> toJson() => {
        "terms1": terms1,
        "terms2": terms2,
        "terms3": terms3,
      };
}
