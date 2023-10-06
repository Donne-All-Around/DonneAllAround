// 회원가입 DTO
class SignUpDto {
  final String tel;
  final String nickname;
  final String imageUrl;
  final String uid;

  SignUpDto({
    required this.tel,
    required this.nickname,
    required this.imageUrl,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'tel': tel,
      'nickname': nickname,
      'imageUrl': imageUrl,
      'uid': uid,
    };
  }
}

// 닉네임 중복 체크
class NicknameCheckDto {
  final String nickname;

  NicknameCheckDto({required this.nickname});

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
    };
  }
}