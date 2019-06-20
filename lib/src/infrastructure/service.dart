class Service {
  String value;
  int counter;
  int length;
  bool lower;
  bool upper;
  bool number;
  bool special;

  Service({
    this.value,
    this.counter,
    this.length,
    this.lower,
    this.upper,
    this.number,
    this.special,
  });

  Service.byDefault() {
    this.value = '';
    this.counter = 0;
    this.length = 18;
    this.lower = true;
    this.upper = true;
    this.number = true;
    this.special = true;
  }


  Service copyWith({
    String value,
    int counter,
    int length,
    bool lower,
    bool upper,
    bool number,
    bool special,
  }) {
    return Service(
      value: value ?? this.value,
      counter: counter ?? this.counter,
      length: length ?? this.length,
      lower: lower ?? this.lower,
      upper: upper ?? this.upper,
      number: number ?? this.number,
      special: special ?? this.special,
    );
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      value: json['value'],
      counter: json['counter'],
      length: json['length'],
      lower: json['lower'],
      upper: json['upper'],
      number: json['number'],
      special: json['special'],
    );
  }
  
  Map<String, dynamic> toJson() => {
        'value': value,
        'counter': counter,
        'length': length,
        'lower': lower,
        'upper': upper,
        'number': number,
        'special': special,
      };
}
