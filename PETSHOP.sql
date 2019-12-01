/* 드랍문 */
drop table member_flag cascade constraints;

drop table member_authKey cascade constraints;

drop table member_info cascade constraints;

drop table member_auth cascade constraints;

drop sequence seq_member;

drop table member cascade constraints;

drop sequence seq_reviews;

drop table products_reviews cascade constraints;

drop table products_attach cascade constraints;

drop sequence seq_products;

alter table products drop primary key;

drop table products cascade constraints;

/* products 테이블 생성 */
create table products (
    productsNo number(10, 0) not null,
    productsName varchar2(100) not null,
    price varchar2(50) not null,
    explain varchar2(1000),
    animalType varchar2(50),
    productsType varchar2(50),
    brand varchar2(50)
    );
    
/* products 테이블 프라이머리키 생성 */
alter table products add constraint pk_products primary key (productsNo);

/* products 테이블 시퀀스 생성 */
create sequence seq_products start with 1 increment by 1;

alter sequence seq_products increment by -1 minvalue 0;

alter sequence seq_products increment by 1 minvalue 0;

/* 인덱스 조회 */
SELECT * FROM USER_INDEXES
WHERE TABLE_NAME='/*products_reviews*/ ' ;

/* products_attach */
create table products_attach (
    uuid varchar2(100) not null,
    uploadPath varchar2(200) not null,
    fileName varchar2(100) not null,
    imageType char(1) default '1',
    productsNo number(10, 0)
);

/* products_attach 프라이머리키 추가 */
alter table products_attach add constraint pk_attach primary key (uuid);

/* products_attach 포링키 추가*/
alter table products_attach add constraint fk_products_attach foreign key (productsNo) references products(productsNo);

/* products_review */
create table products_reviews (
    reviewsNo number(10, 0) not null,
    reviews varchar2(1000) not null,
    reviewer varchar2(100) not null,
    reviewDate date default sysdate,
    reviewUpdate date default sysdate,
    productsNo number(10, 0)
);

/* products_review_sequence */
create sequence seq_reviews start with 1 increment by 1;

alter sequence seq_reviews increment by -1 minvalue 0;

alter sequence seq_reviews increment by 1 minvalue 0;

/* products_reviews 프라이머리키 추가 */
alter table products_reviews add constraint pk_reviews primary key (reviewsNo);

/* products_reviews 포링키 추가 */
alter table products_reviews add constraint fk_reviews_products foreign key (productsNo) references products(productsNo);

/* member 테이블 */
create table member (
    memberNo number(10, 0) not null,
    email varchar2(100) not null unique,
    password varchar2(100) not null,
    enabled char(1) default '0'
);

/* member 프라이머리키 생성 */
alter table member add constraint pk_member primary key (memberNo);

/* member 시퀀스 생성 */
create sequence seq_member start with 1 increment by 1;

alter sequence seq_member increment by -1 minvalue 0;

alter sequence seq_member increment by 1 minvalue 0;

/* member_auth 테이블 */
create table member_auth (
    memberNo number(10, 0) not null,
    authority varchar2(100) not null
);

/* member_auth 포링키 생성 */
alter table member_auth add constraint fk_member_auth foreign key (memberNo) references member (memberNo);

/* unique index */
create unique index ix_auth_memberNo on member_auth (memberNo, authority);

/* member_authkey */
create table member_authKey (
    memberNo number(10, 0) not null unique,
    authKey varchar2(100) not null
);

/* member_authkey 포링키 생성 */
alter table member_authKey add constraint fk_member_authKey foreign key (memberNo) references member (memberNo);

/* member_info */
create table member_info (
    name varchar2(100) not null,
    postCode varchar2(100) not null,
    address varchar2(500) not null,
    detailAddress varchar2(500),
    phoneNumber varchar2(100) not null,
    regDate date default sysdate not null,
    updateDate date default sysdate not null,
    memberNo number(10, 0) not null
);

/* member_info 포링키 생성 */
alter table member_info add constraint fk_member_info foreign key (memberNo) references member (memberNo);

/* 로그인 실패 카운터 테이블 */
create table member_flag (
    email varchar2(100) not null,
    failCounter number(10, 0),
    pwChangeFlag varchar2(100)
);

/* 포링키 */
alter table member_flag add constraint fk_member_flag foreign key (email) references member (email);

/* remember me 기능용 테이블 생성 */
create table persistent_logins (
    username varchar(64) not null,
    series varchar(64) primary key,
    token varchar(64) not null,
    last_used timestamp not null
);

create table cart (
    cartNo number not null primary key,
    mNo number not null,
    pNo number not null,
    amount number default 0
);

create sequence seq_cart start with 1 increment by 1;

alter table cart add constraint fk_cart_mNo foreign key (mNo) references member (memberNo);
alter table cart add constraint fk_cart_pNo foreign key (pNo) references products (productsNo);

create table order_log(
    logNo number not null primary key,
    pno number not null,
    mno number not null,
    payAmount number not null,
    payPrice number not null,
    payMethod varchar2(100) not null,
    payStatus varchar2(100) not null,
    payDate date default sysdate not null,
    renewalDate date default sysdate,
    expressStatus varchar2(100) not null
);

create sequence seq_order start with 1 increment by 1;

alter table order_log add constraint fk_log_mno foreign key (mno) references member (memberNo);
alter table order_log add constraint fk_log_pno foreign key (pno) references products (productsNo);