package com.sturdy.moneyallaround.domain.member.entity;

//import com.sturdy.moneyallaround.domain.member.dto.request.SignUpRequest;
import com.sturdy.moneyallaround.domain.member.dto.request.UpdateProfileRequest;
import com.sturdy.moneyallaround.domain.member.dto.request.UpdateTelRequest;
import jakarta.persistence.*;
import lombok.*;
//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Getter
@Entity
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
//public class Member implements UserDetails {
public class Member {
        @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, unique = true, nullable = false)
    private Long id;

    @Column(name = "nickname")
    private String nickname;

    private String imageUrl;

    @Column(name = "point")
    private int point;

    @Column(name = "rating")
    private int rating;

    @Column(name = "phonenumber")
    private String tel;


    //멤버 엔티티 내의 컬랙션 속성 매핑 (Role 컬렉션 로딩)
    @ElementCollection(fetch = FetchType.EAGER)
    @Builder.Default //Role_user 역할 가지도록 초기화
    @Enumerated(EnumType.STRING)
    private List<Role> roles = new ArrayList<>(List.of(Role.ROLE_USER));


    //사용자 역할 정의
//    @Override
//    public Collection<? extends GrantedAuthority> getAuthorities() {
//
//        return this.roles.stream()
//                .map(Role::name)
//                .map(SimpleGrantedAuthority::new) //문자열 SimpleGrantedAuthority로 변환
//                .toList();
//    }

    //Member Update
//    public static Member from(SignUpRequest request, PasswordEncoder encoder){
//        return Member.builder()
//                .nickname(request.nickname())
//                .imageUrl(request.imageUrl())
//                .tel(request.tel())
//                .build();
//    }

    public void update(UpdateProfileRequest request){
        this.nickname = request.nickname();
        this.imageUrl = request.imageUrl();
    }

    public void updateTel(UpdateTelRequest request){
        this.tel = request.telNew();
    }
//
//    @Override
//    public String getUsername() {
//        return nickname;
//    }
//
//    @Override
//    public String getPassword() {
//        return tel;
//    }
//    @Override
//    public boolean isAccountNonExpired() {
//        return true;
//    }
//
//    @Override
//    public boolean isAccountNonLocked() {
//        return true;
//    }
//
//    @Override
//    public boolean isCredentialsNonExpired() {
//        return true;
//    }
//
//    @Override
//    public boolean isEnabled() {
//        return true;
//    }

    public void updateRating(int reviewScore) {
        rating = (rating + (rating + reviewScore * 50) * 2) / 3;
    }

    public void remittance(Integer amount) {
        point -= amount;
    }

    public void deposit(Integer amount) {
        point += amount;
    }
}
