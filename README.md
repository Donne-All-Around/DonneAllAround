# 돈네한바퀴
### 국내/외에서 사용 가능한 외화 거래 어플리케이션
>  해외여행 후, 잔돈이 남은 경험이 있으신가요? 특히, 동전의 경우는 은행에서 환전하면 수수료가 50퍼센트라서 '다음 여행 때 쓰겠지~' 하고는 재사용을 안하는 경우가 많습니다. 그리하여 나타난 저희의 외화잔돈 거래 플랫폼 서비스. 바로 돈네한바퀴입니다. 
 사용자는 남은 외화를 사진과 함께 가격을 정하여 거래글을 올릴 수 있습니다. 실시간 환율 정보를 제공하여 판매자에게는 최고의 이익을 구매자에게는 최고의 절약을 할 수 있는 범위 또한 제공합니다. 채팅으로 안전하게 거래하세요.


<br>

## **목차**

### 1️⃣ [프로젝트 기획 의도](#1%EF%B8%8F⃣-프로젝트-기획-의도-1)
### 2️⃣ [주요 기능](#2%EF%B8%8F⃣-주요-기능-1)
### 3️⃣ [화면](#3%EF%B8%8F⃣-화면-1)
### 4️⃣ [기술 스택](#4%EF%B8%8F⃣-기술-스택-1)
### 5️⃣ [참여 인원 및 역할](#5%EF%B8%8F⃣-참여-인원-및-역할-1)

<br>

## 1️⃣ 프로젝트 기획 의도

- 엔데믹이후 **해외여행에 대한 대중의 관심**이 점점 증가하는 추세
- 여행 이후 큰 골칫거리 중 하나인 **잔액**을 해결할 수 있는 서비스의 필요성을 느낌
- **실시간 환율 비교** 서비스를 통해 **잔액**을 가장 효율적으로 처리할 수 있는 서비스 기획
- 더 나아가 **여러 환전 관련 정보** 등을 함께 제공

<br>

## 2️⃣ 주요 기능
|구분|기능|설명|
|:---|:---|:---|
|1|[거래 기능](#거래-기능)|사용자들끼리 외화를 거래할 수 있는 기능. 원하는 통화의 실시간 환율을 제공하는 "환율계산기", 원하는 지역과 통화를 선택해서 조회할 수 있는 "지역/통화 필터", 거래글을 올린 당사자와 쉽게 약속을 잡을 수 있는 "채팅 연동"기능 보유.|
|2|[채팅 기능](#채팅-기능)|채팅하면서 변경되는 다양한 사항을 실시간으로 반영하기 위해 파이어베이스를 사용. 스트림을 통해 채팅 메시지의 실시간 갱신이 가능. 거래글과 연동된 채팅방으로 거래를 희망할경우 약속잡기 버튼을 눌러 바로 거래 예약이 가능|
|3|[환율 정보 기능](#환율-정보-기능)|스프링 스케줄러를 사용해 매일 종가 환율을 저장, 제공. 은행별, 통화별 등 다양한 기준에서 환율정보를 제공|
|4|[환율 계산 기능](#환율-계산-기능)|환전을 최대한 효율적으로 하기위한 환율계산기능 제공. 단순한 환율계산부터, 통화를 두번거치는 이중환전기능까지 제공.|

<br>

## 3️⃣ 화면

### 피그마
[![figma](https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/48c0ef44-5eb5-4356-a1c0-53e507884210)](https://www.figma.com/file/mOK3HCg1Ux9OTorwEqosdo/%EB%8F%88%EB%84%A4%ED%95%9C%EB%B0%94%ED%80%B4?type=design&node-id=0-1&mode=design)

### 회원가입/로그인
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/e0c3ffba-6761-4663-a180-e1641a7bc5ee" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/c621eb86-8076-4e14-8a89-77c304a57bba" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/5fe521e1-7079-45e5-ae26-133cef4d611b" width="200">

### 거래 기능
거래글 목록 조회/거래글 등록  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/1381887c-a253-4ca9-b956-863eaa3686b4" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/bebec04e-4610-40c2-8f66-9783d3799a83" width="200">

거래글 조회  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/28801223-18ae-4d49-98c9-f7e986f8a55c" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/624b4aed-3fa7-43f8-9e6a-22c9aafcad6c" width="200">

### 채팅 기능
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/19c5c032-533e-4b4b-b354-7e927970fa9d" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/8e39046a-b3b2-4e1e-a4b1-e497e8c9bafd" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/d6f03d0e-4a83-4a1e-a61e-2907f953c39f" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/87d1cca9-b8dc-47cc-827e-c4ac8d69bfc3" width="200">

### 환율 정보 기능
실시간 환율 검색  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/813935f2-6b65-42bc-8a18-ae810bad69ae" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/1f95080e-fb57-45bc-897f-d1b483427e83" width="200">

은행별 환율 검색  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/27c251d7-6f86-4682-bb02-7ceeea35ef74" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/c640e256-140b-4ecb-b116-95b6df5700e3" width="200">

### 환율 계산 기능!
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/76c107fd-adcc-4d80-bb53-794162039ef1" width="200">

### 마이페이지
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/ed70cebd-1b08-4e5f-bfaa-011039986492" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/08d39394-561e-42c3-8ac4-d908f65bebaa" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/0bbd78d8-91ca-4335-bb21-acaec38bc1e5" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/94ab110d-1c57-4069-9778-b08fddf71396" width="200">

<br>

## 4️⃣ 기술 스택
|분야|사용 기술 스택|
|:---|:---|
|Backend|Spring Boot, JPA, JWT, Spring Security|
|Frontend|Flutter, Dart|
|CI/CD|Jenkins|
|Server|Nginx, Docker|
|DB|Firebase, Redis, MariaDB|
|API|Google Map, currencylayer API|
|Cloud|AWS S3, Firebase Storage|
|기타|Git, Jira, Notion, MatterMost, Figma|

<br>

## 5️⃣ 참여 인원 및 역할
|분야|인원|
|:---|:---|
|Backend|김령은, 한라연, 함소연|
|Frontend|문요환, [이정민](https://github.com/JisforJelly), [정현아](https://github.com/hhyeona), 함소연|
|CI/CD|김령은|

