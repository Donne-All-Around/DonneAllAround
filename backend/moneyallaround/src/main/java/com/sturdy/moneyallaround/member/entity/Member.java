package com.sturdy.moneyallaround.member.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Getter
@Entity
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Member implements UserDetails {

    @Id
    @Column(name = "id", updatable = false, unique = true, nullable = false)
    private String id;

    @Column(name = "nickname")
    private String nickname;

    @Column(name = "profile_img")
    private String image;

    @Column(name = "point")
    private int point;

    @Column(name = "rating")
    private int rating;

    @Column(name = "phonenumber")
    private String tel;

//    @Column(name = "is_tel")
//    @ColumnDefault("false")
//    private Boolean isTel;


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @ElementCollection(fetch = FetchType.EAGER)
    @Builder.Default
    @Enumerated(EnumType.STRING)
    private List<Role> roles = new ArrayList<>(List.of(Role.ROLE_USER));

    //

    @Override
    public String getUsername() {
        return id;
    }

    @Override
    public String getPassword() {
        return tel;
    }
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
