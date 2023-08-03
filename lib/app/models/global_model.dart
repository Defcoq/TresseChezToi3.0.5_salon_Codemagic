import 'parents/model.dart';

class Global extends Model {

  String? mockBaseUrl;
  String? laravelBaseUrl;
  String? apiPath;
  int? received;
  int? accepted;
  int? onTheWay;
  int? ready;
  int? inProgress;
  int? done;
  int? failed;
  String laravelBaseUrlEuropa="";
  String laravelBaseUrlUsa="";
  String laravelBaseUrlCanada="";

  Global({this.mockBaseUrl, this.laravelBaseUrl, this.apiPath});

  Global.fromJson(Map<String, dynamic> json) {
    mockBaseUrl = json['mock_base_url'].toString();
    laravelBaseUrl = json['laravel_base_url'].toString();
    apiPath = json['api_path'].toString();
    received = intFromJson(json, 'received');
    accepted = intFromJson(json, 'accepted');
    onTheWay = intFromJson(json, 'on_the_way');
    ready = intFromJson(json, 'ready');
    inProgress = intFromJson(json, 'in_progress');
    done = intFromJson(json, 'done');
    failed = intFromJson(json, 'failed');
    laravelBaseUrlEuropa = json['laravel_base_url_europa'].toString();
    laravelBaseUrlUsa = json['laravel_base_url_usa'].toString();
    laravelBaseUrlCanada = json['laravel_base_url_canada'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mock_base_url'] = this.mockBaseUrl;
    data['laravel_base_url'] = this.laravelBaseUrl;
    data['api_path'] = this.apiPath;
    data['laravel_base_url_europa'] = this.laravelBaseUrlEuropa;
    data['laravel_base_url_usa'] = this.laravelBaseUrlUsa;
    data['laravel_base_url_canada'] = this.laravelBaseUrlCanada;
    return data;
  }
}
