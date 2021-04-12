class ArtistSchedule {
  String time;
  String duration;
  String artistId;

  ArtistSchedule({this.time, this.duration, this.artistId});

  ArtistSchedule.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    duration = json['duration'];
    artistId = json['artist_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['duration'] = this.duration;
    data['artist_id'] = this.artistId;
    return data;
  }
}
