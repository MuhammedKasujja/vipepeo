class BaseResponse {
  String message;
  bool success;
  String error;

  BaseResponse({this.message, this.success, this.error});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
        success: json["success"],
        message: json["message"],
        error: json['error']);
  }
}

// server response for list
// {
//   "data": []
//   "message": null,
//   "success": true,
// }

class ListResponse<T> extends BaseResponse {
  List<T> data;

  ListResponse({
    String message,
    bool success,
    this.data,
  }) : super(
          message: message,
          success: success,
        );

  factory ListResponse.fromJson(json, Function(Map<String, dynamic>) create) {
    final data = List<T>.from(json['data'].map((v) => create(v)));
    return ListResponse<T>(
        success: json["success"] ?? false,
        message: json["message"],
        data: json["success"] ? data : null);
  }
}

// server response for single object
// {
//   "data": {}
//   "message": null,
//   "success": true,
// }

class SingleResponse<T> extends BaseResponse {
  T data;

  SingleResponse({
    String message,
    bool success,
    String error,
    this.data,
  }) : super(message: message, success: success, error: error);

  factory SingleResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return SingleResponse<T>(
        success: json["success"] ?? false,
        message: json["message"],
        error: json['error'],
        data: json["success"] ? create(json['data']) : null);
  }
}

// Example

// final value = SingleResponse<Comment>.fromJson(
//       response.data,
//       (json) => Comment.fromJson(json),
//     );
