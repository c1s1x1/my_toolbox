// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CallerSeatBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallerSeatBean _$CallerSeatBeanFromJson(Map<String, dynamic> json) =>
    CallerSeatBean(
      json['code'] as int? ?? 0,
      json['message'] as String? ?? '',
      json['data'] == null
          ? null
          : CallerSeatData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallerSeatBeanToJson(CallerSeatBean instance) =>
    <String, dynamic>{
      'code': instance.callerSeatCode,
      'message': instance.callerSeatMessage,
      'data': instance.callerSeatData,
    };

CallerSeatData _$CallerSeatDataFromJson(Map<String, dynamic> json) =>
    CallerSeatData(
      json['caller'] as String? ?? '',
      json['password'] as String? ?? '',
      json['port'] as String? ?? '',
      json['host'] as String? ?? '',
      json['url'] as String? ?? '',
      json['account'] as String? ?? '',
      json['cid'] as String? ?? '',
    );

Map<String, dynamic> _$CallerSeatDataToJson(CallerSeatData instance) =>
    <String, dynamic>{
      'caller': instance.callerSeatCaller,
      'password': instance.callerSeatPassword,
      'port': instance.callerSeatPort,
      'host': instance.callerSeatHost,
      'url': instance.callerSeatUrl,
      'account': instance.callerSeatAccount,
      'cid': instance.callerSeatCid,
    };
