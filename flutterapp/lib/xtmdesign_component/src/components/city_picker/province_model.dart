/// 地址选择器 Model
class ProvinceModel {
  String provinceName;
  int provinceID;
  List<CityModel> city;

  ProvinceModel({this.provinceName, this.provinceID, this.city});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      provinceName: json['provinceName'],
      provinceID: json['provinceID'],
      city: json['city'] == null
          ? []
          : List.from(json['city'].map((item) => CityModel.fromJson(item))),
    );
  }

  @override
  String toString() {
    return 'ProvinceModel{provinceName: $provinceName, provinceID: $provinceID, city: $city}';
  }
}

class CityModel {
  String cityName;
  int cityID;
  List<CountryModel> county;

  CityModel({this.cityName, this.cityID, this.county});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityName: json['cityName'],
      cityID: json['cityID'],
      county: json['county'] == null
          ? []
          : List.from(json['county'].map((item) => CountryModel.fromJson(item))),
    );
  }

  @override
  String toString() {
    return 'CityModel{cityName: $cityName, cityID: $cityID, county: $county}';
  }
}

class CountryModel {
  String countryName;
  int countryID;

  CountryModel({this.countryName, this.countryID});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      countryName: json['countyName'],
      countryID: json['countyID'],
    );
  }

  @override
  String toString() {
    return 'CountryModel{countryName: $countryName, countryID: $countryID}';
  }
}
