class MemberDto {
  final int id;
  final String tel;
  final String nickname;
  final int point;
  final int rating;
  final String profileImg;

  MemberDto({
    required this.id,
    required this.tel,
    required this.nickname,
    required this.point,
    required this.rating,
    required this.profileImg,
  });

  factory MemberDto.formJson(Map<String, dynamic> json) {
    return MemberDto(
        id: json['id'],
        tel: json['tel'],
        nickname: json['nickname'],
        point: json['point'],
        rating: json['rating'],
        profileImg: json['profileImg']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tel': tel,
      'nickname': nickname,
      'point': point,
      'rating': rating,
      'progileImg': profileImg,
    };
  }
}