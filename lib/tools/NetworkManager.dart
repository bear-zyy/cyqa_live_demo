import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:xml2json/xml2json.dart';

class NetworkManager {


  BaseOptions _options;

  factory NetworkManager() {
    return _getManger();
  }

  static NetworkManager _instance;

  NetworkManager._internal() {

    _options = new BaseOptions(
      followRedirects: true,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    );

  }

  static _getManger(){
    if(_instance == null) {
      _instance = NetworkManager._internal();
    }
    return _instance;
  }

  postRequest(String functionName , var params ) async {

    _options.contentType = ContentType.parse("text/xml");
    _options.responseType = ResponseType.plain;

    var dio = new Dio(_options);

    Response response;

    try{
      response = await dio.post("http://192.168.10.168:8088/ws/IWsResourceService?wsdl" , data: getDataInfo(functionName, params));

    }
    on DioError catch(e){

      print('post请求发生错误：$e');

      return "网络错误";
    }

    print(response.data);

    final Xml2Json myTransformer = Xml2Json();

    myTransformer.parse(response.data);

    String json = myTransformer.toParker();

    Map<String,dynamic> map = jsonDecode(json);

    Map<String , dynamic> dataMap = jsonDecode(map["soap:Envelope"]["soap:Body"]["ns2:uplodaResourceMoreResponse"]["return"]);

    return dataMap;

  }

  Future getRequest() async {

  }



  String getDataInfo(String functionName , var params ){

    return '''<?xml version="1.0"?>
    <soapevn:Envelope xmlns:soapevn="http://schemas.xmlsoap.org/soap/envelope/" xmlns:test="http://adapter.wsServer.easySec.com/">
　    <soapevn:Body>
　　    <test:${functionName}>
　　      <jsonString>${getParamsInfo(params)}</jsonString>
　　    </test:${functionName}>
　    </soapevn:Body>
    </soapevn:Envelope>
    ''';
  }

  String getParamsInfo(var params){
    return '''{"accessToken": "eed87be55d4bbb022c6198a1932476f4","Account_Name":"zyy" , ${params}}''';
  }

}