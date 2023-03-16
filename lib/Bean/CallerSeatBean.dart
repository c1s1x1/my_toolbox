import 'package:json_annotation/json_annotation.dart';

part 'CallerSeatBean.g.dart';


@JsonSerializable()
class CallerSeatBean extends Object {

  @JsonKey(name: 'code',defaultValue: 0)
  int callerSeatCode;

  @JsonKey(name: 'message',defaultValue: "")
  String callerSeatMessage;

  @JsonKey(name: 'data')
  CallerSeatData? callerSeatData;

  CallerSeatBean(this.callerSeatCode,this.callerSeatMessage,this.callerSeatData,);

  factory CallerSeatBean.fromJson(Map<String, dynamic> srcJson) => _$CallerSeatBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CallerSeatBeanToJson(this);

}


@JsonSerializable()
class CallerSeatData extends Object {

  @JsonKey(name: 'caller',defaultValue: "")
  String callerSeatCaller;

  @JsonKey(name: 'password',defaultValue: "")
  String callerSeatPassword;

  @JsonKey(name: 'port',defaultValue: "")
  String callerSeatPort;

  @JsonKey(name: 'host',defaultValue: "")
  String callerSeatHost;

  @JsonKey(name: 'url',defaultValue: "")
  String callerSeatUrl;

  @JsonKey(name: 'account',defaultValue: "")
  String callerSeatAccount;

  @JsonKey(name: 'cid',defaultValue: "")
  String callerSeatCid;

  CallerSeatData(this.callerSeatCaller,this.callerSeatPassword,this.callerSeatPort,this.callerSeatHost,this.callerSeatUrl,this.callerSeatAccount,this.callerSeatCid,);

  factory CallerSeatData.fromJson(Map<String, dynamic> srcJson) => _$CallerSeatDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CallerSeatDataToJson(this);

}


