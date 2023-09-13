package com.sturdy.moneyallaround.member.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;

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


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

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
