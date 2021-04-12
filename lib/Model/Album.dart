import 'Schedule.dart';

class Album {
  String id;
  String name;
  String image;
  bool isFavorite;
  String bio;
  String soundcloud;
  String facebook;
  String instagram;
  Schedule schedule;

  Album(
      {this.id,
        this.name,
        this.image,
        this.isFavorite,
        this.bio,
        this.soundcloud,
        this.facebook,
        this.instagram,
        this.schedule});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isFavorite = json['isFavorite'];
    bio = json['bio'];
    soundcloud = json['soundcloud'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['isFavorite'] = this.isFavorite;
    data['bio'] = this.bio;
    data['soundcloud'] = this.soundcloud;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    if (this.schedule != null) {
      data['schedule'] = this.schedule.toJson();
    }
    return data;
  }
}
