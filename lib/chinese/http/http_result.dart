
class HttpResult {

	 static toJson(int code,dynamic data,dynamic headers,String message){
	 	final Map<String,dynamic> data=new Map();
	 	data["code"]=code;
	 	data["data"]=data;
	 	data["headers"]=headers;
	 	data["message"]=message;
	 	return data;
	 }

}


