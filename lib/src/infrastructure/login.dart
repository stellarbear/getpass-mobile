class Login {
  String value;

  Login({this.value});

  Login.byDefault(){
    this.value ='';
  }

  Login copyWith({
    String value,
  }) {
    return Login(
      value: value ?? this.value,
    );
  }

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(value: json['value']);
  }

  Map<String, dynamic> toJson() => {
        'value': value,
      };
}
