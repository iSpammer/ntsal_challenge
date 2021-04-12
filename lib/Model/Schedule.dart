class Schedule {
  String day;
  String date;
  String time;

  Schedule({this.day, this.date, this.time});

  Schedule.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
