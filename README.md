# 돈네한바퀴
### 국내/외에서 사용 가능한 외화 거래 어플리케이션
>
> 

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
[![figma](https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/93dbae8f-fcd2-4690-aad7-9d6f35d2e58e)](https://www.figma.com/file/mOK3HCg1Ux9OTorwEqosdo/%EB%8F%88%EB%84%A4%ED%95%9C%EB%B0%94%ED%80%B4?type=design&node-id=0-1&mode=design)

### 회원가입/로그인
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/68723cb0-a777-4bc6-8596-d00d01714d90" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/6add72de-cc0a-4bf4-a004-e3237c9e6deb" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/67baa309-b3cf-4de1-894c-208e112762e7" width="200">

### 거래 기능
거래글 목록 조회/거래글 등록  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/45ddb826-97f5-4f05-be02-01581a46bd5c" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/5974af11-8ea8-4981-8818-33782dec1746" width="200">

거래글 조회  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/7d5c85eb-4fe1-48f0-a425-337fa22afa4a" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/bccc3483-935f-4731-9443-f2de344f9cff" width="200">

### 채팅 기능
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/700892d9-6797-48d6-ac95-fd84f109bd7c" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/d866c1f9-50f4-4958-9627-e79637e2c698" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/be49467c-406a-4242-9156-938b736565d2" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/10db1c46-8ae8-4d25-9dd6-47ee6a396316" width="200">

### 환율 정보 기능
실시간 환율 검색  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/0e159dbc-e77e-49bc-a8c4-aa7e14729c85" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/6fd0cce8-7125-43c0-a785-372de251432d" width="200">

은행별 환율 검색  
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/943db234-2e3e-4053-824a-898a1a0e24bb" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/41688550-a81c-4900-a9cf-de1f244945fb" width="200">

### 환율 계산 기능
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/19ea9f4f-053d-45e4-9db0-e0423d4ddbf4" width="200">

### 마이페이지
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/fbe9d3b6-6952-41c9-856b-df1c512193dd" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/4b86de7a-6b62-4ea5-a849-376e70db48f8" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/e1b3b841-1000-4b76-9386-17148ecd928c" width="200">
<img src = "https://github.com/Donne-All-Around/DonneAllAround/assets/90131462/789d057d-9505-4985-aa20-47fb628a43aa" width="200">

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

