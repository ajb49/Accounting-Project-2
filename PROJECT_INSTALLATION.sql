--changing date figure from asia to american style and OEHR_JOBS instead of HR.JOBS after insalling HR into Oracle Apex
CREATE TABLE COMPANY_DETAILS
(COMPANY_ID NUMBER PRIMARY KEY NOT NULL,
COMPANY_NAME VARCHAR2(70),
ADDRESS VARCHAR2(200),
PHONE varchar2(20),
FAX varchar2(20),
EMAIL VARCHAR2(50),
MIMETYPE VARCHAR2(100),
FILENAME VARCHAR2(200),
CREATED_DATE DATE);

BEGIN
INSERT INTO COMPANY_DETAILS (company_id, company_name, address, phone, fax, email)
VALUES (101,'Samsung Bangladesh Ltd.','47/2/H/F, East Monipur, Dhaka, Bangladesh','+8801511020007','478-7554','sbl@mail.com');
INSERT INTO COMPANY_DETAILS (company_id, company_name, address, phone, fax, email)
VALUES (201,'Singer Ltd.','12/7/A/R,Gulistan, Dhaka, Bangladesh','+88017XXXXXXXX','421-7004','singerbd@mail.com');
INSERT INTO COMPANY_DETAILS (company_id, company_name, address, phone, fax, email)
VALUES (301,'Taifun Limited.','11/2, Green Road, Dhaka-1215, Bangladesh','+88016XXXXXXXX','999-1674','taifun@mail.com');
COMMIT;
END;
/

CREATE TABLE jobs(
job_id VARCHAR2(20) NOT NULL PRIMARY KEY,
job_title VARCHAR2(35) NOT NULL,
company_id NUMBER CONSTRAINT com_job_fk REFERENCES company_details(company_id)
); 
BEGIN
INSERT INTO jobs(job_id,job_title)
SELECT job_id, job_title FROM OEHR_JOBS;
UPDATE jobs SET company_id = 101;
COMMIT;
END;
/

BEGIN
INSERT INTO jobs (job_id, job_title)
SELECT job_id||'_2', job_title||' II'
FROM jobs;
UPDATE jobs SET company_id = 201 WHERE company_id IS NULL;
INSERT INTO jobs (job_id, job_title)
SELECT job_id||'_3', job_title||' III'
FROM jobs where company_id = 101;
UPDATE jobs SET company_id = 301 WHERE company_id IS NULL;
COMMIT;
END;
/

CREATE TABLE user_table (
job_id        VARCHAR2(20) CONSTRAINT job_user_fk REFERENCES jobs(job_id),
user_id     VARCHAR2(30)  DEFAULT USER UNIQUE NOT NULL,
user_name    VARCHAR2(30),
passcode   VARCHAR2(10)
);

CREATE TABLE credit_tables (
cv_id      NUMBER(4) PRIMARY KEY NOT NULL,
date_of_transaction  DATE,
narration    VARCHAR2(255),
voucher_type    VARCHAR2(30),
voucher_no     VARCHAR2(30),
user_id      VARCHAR2(30) DEFAULT USER CONSTRAINT user_cr_fk REFERENCES user_table(user_id),
payment_mode     VARCHAR2(30),
bank_name      VARCHAR2(30),
bank_acc_no     VARCHAR2(30),
cheque_no       VARCHAR2(30),
cheque_date    DATE,
credit_card_no  VARCHAR2(16),
debit_card_no  VARCHAR2(16),
cardholder_name VARCHAR2(100),
job_id VARCHAR2(20)
);

CREATE TABLE debit_tables (
dv_id      NUMBER(4) PRIMARY KEY NOT NULL,
date_of_transaction   DATE,
narration    VARCHAR2(255),
voucher_type     VARCHAR2(30),
voucher_no     VARCHAR2(30),
user_id       VARCHAR2(30) DEFAULT USER CONSTRAINT user_dr_fk REFERENCES user_table(user_id),
payment_mode     VARCHAR2(30),
bank_name     VARCHAR2(30),
bank_acc_no     VARCHAR2(30),
cheque_no    VARCHAR2(30),
cheque_date     DATE,
credit_card_no VARCHAR2(16),
debit_card_no VARCHAR2(16),
cardholder_name VARCHAR2(100),
job_id VARCHAR2(20)
);

CREATE TABLE journal_tables (
jv_id    NUMBER(4) PRIMARY KEY NOT NULL,
date_of_transaction      DATE,
narration       VARCHAR2(255),
voucher_type   VARCHAR2(30),
voucher_no     VARCHAR2(30),
user_id     VARCHAR2(30) DEFAULT USER CONSTRAINT user_jv_fk REFERENCES user_table(user_id),
payment_mode    VARCHAR2(30),
job_id VARCHAR2(20)
);

CREATE TABLE chart_of_accounts (
coa_id   NUMBER(4) PRIMARY KEY NOT NULL,
accounts_head    VARCHAR2(30)
);

CREATE TABLE income_statements (
isid    NUMBER(4)  PRIMARY KEY NOT NULL,
coa_id NUMBER(4) CONSTRAINT coa_is_fk REFERENCES chart_of_accounts(coa_id),
description VARCHAR2(70)
);

CREATE TABLE categories (
c_id   NUMBER(4) PRIMARY KEY NOT NULL,
coa_id   NUMBER(4) CONSTRAINT coa_ct_fk REFERENCES chart_of_accounts(coa_id),
isid NUMBER(4) CONSTRAINT is_cat_fk REFERENCES income_statements(isid),
account_type VARCHAR2(70)
);

CREATE TABLE accounts (
acc_id    NUMBER(4) PRIMARY KEY NOT NULL,
c_id      NUMBER(4) CONSTRAINT ct_acc_fk REFERENCES categories(c_id) NOT NULL,
particulars   VARCHAR2(70) UNIQUE NOT NULL 
);

CREATE TABLE transaction_tables(
date_of_transaction  DATE,
particulars    VARCHAR2(70) CONSTRAINT acc_jvp_fk REFERENCES accounts(particulars),
debit     NUMBER(10,4),
credit     NUMBER(10,4),
cv_id      NUMBER(4) CONSTRAINT cr_v_fk REFERENCES credit_tables(cv_id),
dv_id      NUMBER(4) CONSTRAINT dr_v_fk REFERENCES debit_tables(dv_id),
jv_id      NUMBER(4) CONSTRAINT jv_v_fk REFERENCES journal_tables(jv_id),
acc_id     NUMBER(4) CONSTRAINT acc_jv_fk REFERENCES accounts(acc_id)
);

ALTER TABLE transaction_tables MODIFY(debit NUMBER(13,4), credit NUMBER(13,4));
--------------------------------------------------------------------------------------------

CREATE TABLE BANK_INFORMATION(
                              BANK_CODE NUMBER(10) CONSTRAINT bank_code_pk PRIMARY KEY,
                              BANK_NAME VARCHAR2(150)
                              );
CREATE TABLE BRANCH_INFORMATION(
                                BRANCH_CODE NUMBER(20) CONSTRAINT branch_code_pk PRIMARY KEY,
                                BANK_CODE NUMBER(10) CONSTRAINT bank_code_fk REFERENCES 								BANK_INFORMATION(BANK_CODE) NOT NULL,
                                BRANCH_NAME VARCHAR2(100),
                                DISTRICT_CODE NUMBER(10),
                                THANA_CODE NUMBER(10),
                                VILLAGE_CODE NUMBER(10),
                                BRANCH_ADDRESS VARCHAR2(200)
                                );


BEGIN
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (100,'Shonali Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (101,'Rupali Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (102,'Pubali Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (103,'Janata Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (104,'Agrani Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (105,'Union Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (106,'One Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (107,'Uttara Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (108,'Probashi Bank');
INSERT INTO BANK_INFORMATION (BANK_CODE,BANK_NAME)
VALUES (109,'ICB Bank');
COMMIT;
END;
/

CREATE TABLE BANK_NAME(NAME VARCHAR2(150),ID NUMBER(10));

BEGIN
INSERT INTO BANK_NAME (NAME,ID)
VALUES ('Shonali Bank',100);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('Rupali Bank',101);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('Pubali Bank',102);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('Janata Bank',103);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('Agrani Bank',104);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('Union Bank',105);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('One Bank',106);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('Uttara Bank',107);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('Probashi Bank',108);
INSERT INTO BANK_NAME(NAME,ID)
VALUES ('ICB Bank',109);
COMMIT;
END;
/

BEGIN
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1000,100,'Mirpur',10,'Kamal sarani,Concord Tower,2nd Floor,Mirpur-2');
-----------------------------------------------------------------------------------------------
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1001,100,'Kolabagan',10,'17/3,Neel road');
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1002,100,'Nilkhet',10,'12/9/7,Modhu bazar');
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1003,100,'New-Market',10,'14/9,Balaka Cinema Hall');
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1004,100,'Narayngonj',10,'Shanti Bazar');
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1005,100,'Technical',10,'Darussalam');
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1006,100,'Gaptoli',10,'45/9/C,Porbot');
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1007,100,'Banani',10,'Sky road');
INSERT INTO BRANCH_INFORMATION (BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (1008,100,'Gulshan',10,'Laxmipur bazar');
-----------------------------------------------------------------------------------------------
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2000,101,'Banani',10,'Kamal Avenue,Confidence Tower,3rd Floor,Banani');
-----------------------------------------------------------------------------------------------
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2001,101,'Cantontment',10,'Road-3,Puran bari road');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2002,101,'Uttara',10,'Sector 7');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2003,101,'Nabinagar',10,'Mach bazar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2004,101,'Gulshan',10,'78/6,abc tower');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2005,101,'Shyamoli',10,'Ring road');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2006,101,'Asad gate',10,'8/9,Mohammadpur');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2007,101,'Kollanpur',10,'14/b,darussalam');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2008,101,'Mirpur-2',10,'Stadium');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2009,101,'Mirpur-1',10,'Prince Tower');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2010,101,'Mirpur-10',10,'Chandra Market');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2011,101,'Mirpur-11',10,'12/3 pallabi');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2012,101,'Mirpur-12',10,'14/3 street');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2013,101,'Sadarghat',10,'Keranigonj');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (2014,101,'Gulistan',10,'Tatibazar');
----------------------------------------------------------------------------------------------

INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3000,102,'Mohammadpur',20,'Jamtala Circle,K Tower,2nd Floor,Chawkbazar');
----------------------------------------------------------------------------------------------
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3001,102,'Uttara',10,'Abdullapur');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3002,102,'Srinagar',10,'Kalshibazar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3003,102,'Savar',10,'Aminbazar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3004,102,'Shyamoli',10,'ASA tower');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3005,102,'Keranigonj',10,'fultola bazar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3006,102,'Mirpur-14',10,'47 avanue 4');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3007,102,'Sadarghat',10,'Tatibazar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3008,102,'Alamnagar',10,'zindapark');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3009,102,'Banani',10,'12/2,ful sharani');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3010,102,'Gulshan',10,'Rajbari');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3011,102,'Uttara',10,'Sector -10');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3012,102,'Uttara',10,'Sector-9');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3013,102,'Mirpur-1',10,'National zoo');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3014,102,'Science LAB',10,'Elephant road');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3015,102,'Dhanmondi',10,'Jhigatola');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3016,102,'Dhanmondi',10,'Metro plaza');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3017,102,'Mohammadpur',10,'Arong');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3018,102,'Shyamoli',10,'Shyamoli cinema hall');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3019,102,'Agargoan',10,'Taltola');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (3020,102,'Kajipara',10,'14/m, begum rokaya sharani');
---------------------------------------------------------------------------------------------

INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4000,103,'Muradpur',20,'R Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4001,103,'Muradpur',20,'TOP Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4002,103,'Muradpur',20,'N Complex,1st Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4003,103,'Muradpur',20,'MS Complex,4th Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4004,103,'Muradpur',20,'PDB Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4005,103,'Muradpur',20,'RDF Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4006,103,'Muradpur',20,'RP Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4007,103,'Muradpur',20,'RU Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4008,103,'Muradpur',20,'RS Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4009,103,'Muradpur',20,'SS Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4010,103,'Muradpur',20,'RW Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4011,103,'Muradpur',20,'RD Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4012,103,'Muradpur',20,'TR Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4013,103,'Muradpur',20,'XYZ Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4014,103,'Muradpur',20,'ABC Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4015,103,'Muradpur',20,'Y Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4016,103,'Muradpur',20,'J Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4017,103,'Muradpur',20,'E Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4018,103,'Muradpur',20,'D Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4019,103,'Muradpur',20,'C Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4020,103,'Muradpur',20,'B Complex,2nd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4021,103,'Muradpur',20,'T Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4022,103,'Muradpur',20,'S Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4023,103,'Muradpur',20,'O Complex,3rd Floor,Shulokbahar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (4024,103,'Muradpur',20,'P Complex,3rd Floor,Shulokbahar');
---------------------------------------------------------------------------------------------
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (5000,104,'Dhanmondi',30,'Khan Tower,2nd Floor,Jhigatala');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (6000,105,'Oxygen',30,'M Tower,2nd floor,NotunBazar');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (7000,106,'Badda',40,'F Mension,3rd floor,Kajipara');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (8000,107,'Kalshi',50,'G Tower,2nd Floor,GEC');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (9000,108,'Khulshi',60,'Khulshi Tower,3rd floor,Pahartali');
INSERT INTO BRANCH_INFORMATION(BRANCH_CODE,BANK_CODE,BRANCH_NAME,DISTRICT_CODE,BRANCH_ADDRESS)
VALUES (10000,109,'Gulshan',70,'Gulshan Tower,3rd floor,Gulshan-1');
COMMIT;
END;
/

Alter table BRANCH_INFORMATION
ADD (PHONE_NUMBER VARCHAR2(50), EMAIL VARCHAR2(100));
COMMIT;

BEGIN
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm@gmail.com')
WHERE BRANCH_CODE IN (1000);
--------------------------------------------------------------
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm34@gmail.com')
WHERE BRANCH_CODE IN (1001);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm245@gmail.com')
WHERE BRANCH_CODE IN (1002);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm345@gmail.com')
WHERE BRANCH_CODE IN (1003);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm1234@gmail.com')
WHERE BRANCH_CODE IN (1004);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm13@gmail.com')
WHERE BRANCH_CODE IN (1005);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm856@gmail.com')
WHERE BRANCH_CODE IN (1006);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm68@gmail.com')
WHERE BRANCH_CODE IN (1007);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('sbm365@gmail.com')
WHERE BRANCH_CODE IN (1008);
--------------------------------------------------------------
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb@gmail.com')
WHERE BRANCH_CODE IN (2000);
--------------------------------------------------------------

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb44@gmail.com')
WHERE BRANCH_CODE IN (2001);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb33@gmail.com')
WHERE BRANCH_CODE IN (2002);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb11@gmail.com')
WHERE BRANCH_CODE IN (2003);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb34@gmail.com')
WHERE BRANCH_CODE IN (2004);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb134@gmail.com')
WHERE BRANCH_CODE IN (2005);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb314@gmail.com')
WHERE BRANCH_CODE IN (2006);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb879@gmail.com')
WHERE BRANCH_CODE IN (2007);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb45@gmail.com')
WHERE BRANCH_CODE IN (2008);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb485@gmail.com')
WHERE BRANCH_CODE IN (2009);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb56@gmail.com')
WHERE BRANCH_CODE IN (2010);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb856@gmail.com')
WHERE BRANCH_CODE IN (2011);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb546@gmail.com')
WHERE BRANCH_CODE IN (2012);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb596@gmail.com')
WHERE BRANCH_CODE IN (2013);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kmb66@gmail.com')
WHERE BRANCH_CODE IN (2014);
-----------------------------------------------------------------
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb@gmail.com')
WHERE BRANCH_CODE IN (3000);
-----------------------------------------------------------------


update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb98@gmail.com')
WHERE BRANCH_CODE IN (3001);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb666@gmail.com')
WHERE BRANCH_CODE IN (3002);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb56@gmail.com')
WHERE BRANCH_CODE IN (3003);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb55@gmail.com')
WHERE BRANCH_CODE IN (3004);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb222@gmail.com')
WHERE BRANCH_CODE IN (3005);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb5632@gmail.com')
WHERE BRANCH_CODE IN (3006);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb56@gmail.com')
WHERE BRANCH_CODE IN (3007);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb566@gmail.com')
WHERE BRANCH_CODE IN (3008);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb22@gmail.com')
WHERE BRANCH_CODE IN (3009);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb4@gmail.com')
WHERE BRANCH_CODE IN (3010);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb5@gmail.com')
WHERE BRANCH_CODE IN (3011);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb6@gmail.com')
WHERE BRANCH_CODE IN (3012);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb425@gmail.com')
WHERE BRANCH_CODE IN (3013);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb3243@gmail.com')
WHERE BRANCH_CODE IN (3014);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb443@gmail.com')
WHERE BRANCH_CODE IN (3015);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb44@gmail.com')
WHERE BRANCH_CODE IN (3016);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb55@gmail.com')
WHERE BRANCH_CODE IN (3017);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb56@gmail.com')
WHERE BRANCH_CODE IN (3018);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb764@gmail.com')
WHERE BRANCH_CODE IN (3019);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('mb78@gmail.com')
WHERE BRANCH_CODE IN (3020);
--------------------------------------------------------------

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb@gmail.com')
WHERE BRANCH_CODE IN (4000);

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb113@gmail.com')
WHERE BRANCH_CODE IN (4001);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb111@gmail.com')
WHERE BRANCH_CODE IN (4002);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb6@gmail.com')
WHERE BRANCH_CODE IN (4003);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb969@gmail.com')
WHERE BRANCH_CODE IN (4004);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb44@gmail.com')
WHERE BRANCH_CODE IN (4005);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb45@gmail.com')
WHERE BRANCH_CODE IN (4006);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb99@gmail.com')
WHERE BRANCH_CODE IN (4007);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb853@gmail.com')
WHERE BRANCH_CODE IN (4008);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb39@gmail.com')
WHERE BRANCH_CODE IN (4009);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb7676@gmail.com')
WHERE BRANCH_CODE IN (4010);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb7806@gmail.com')
WHERE BRANCH_CODE IN (4011);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb987@gmail.com')
WHERE BRANCH_CODE IN (4012);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb789@gmail.com')
WHERE BRANCH_CODE IN (4013);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb08@gmail.com')
WHERE BRANCH_CODE IN (4014);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb98@gmail.com')
WHERE BRANCH_CODE IN (4015);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb23@gmail.com')
WHERE BRANCH_CODE IN (4016);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb5@gmail.com')
WHERE BRANCH_CODE IN (4017);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb6@gmail.com')
WHERE BRANCH_CODE IN (4018);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb345@gmail.com')
WHERE BRANCH_CODE IN (4019);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb22@gmail.com')
WHERE BRANCH_CODE IN (4020);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb765@gmail.com')
WHERE BRANCH_CODE IN (4021);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb56@gmail.com')
WHERE BRANCH_CODE IN (4022);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb33@gmail.com')
WHERE BRANCH_CODE IN (4023);
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('jb657@gmail.com')
WHERE BRANCH_CODE IN (4024);


-------------------------------------------------------------
update branch_information
set phone_number =('+8801711XXXXXX'),email = ('ob@gmail.com')
WHERE BRANCH_CODE IN (5000);

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('nbl@gmail.com')
WHERE BRANCH_CODE IN (6000);

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('pbl@gmail.com')
WHERE BRANCH_CODE IN (7000);

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('kbl@gmail.com')
WHERE BRANCH_CODE IN (8000);

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('abl@gmail.com')
WHERE BRANCH_CODE IN (9000);

update branch_information
set phone_number =('+8801711XXXXXX'),email = ('prbl@gmail.com')
WHERE BRANCH_CODE IN (10000);
COMMIT;
END;
/




create table ais_image
(image BLOB);







-------------------------------------------------------------------------------------------------------------
CREATE SEQUENCE coa_seq
START WITH 1000
INCREMENT BY 1000
MAXVALUE 99999
NOCACHE
NOCYCLE
ORDER;
----------------------------------------------------Inserting static data----------------------------------------------------
BEGIN
INSERT INTO chart_of_accounts (coa_id, accounts_head)
VALUES (coa_seq.NEXTVAL, 'Asset');
INSERT INTO chart_of_accounts (coa_id, accounts_head)
VALUES (coa_seq.NEXTVAL, 'Liability');
INSERT INTO chart_of_accounts (coa_id, accounts_head)
VALUES (coa_seq.NEXTVAL, 'Equity');
INSERT INTO chart_of_accounts (coa_id, accounts_head)
VALUES (coa_seq.NEXTVAL, 'Revenue');
INSERT INTO chart_of_accounts (coa_id, accounts_head)
VALUES (coa_seq.NEXTVAL, 'Expense');
COMMIT;
END;
/

BEGIN
INSERT INTO income_statements(isid, coa_id, description)
VALUES (1111,3000,'Net Income');
COMMIT;
END;
/

BEGIN
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (100,1000,'Current Asset',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (200,1000,'Fixed Asset',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (300,1000,'Contra Asset',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (400,2000,'Current Liabilities',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (500,2000,'Non-Current Liabilities',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (600,2000,'Contra Liabilities',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (700,3000,'Owner Equity',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (800,3000,'Contra Equity',NULL);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (900,4000,'Direct Revenue',1111);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (1000,4000,'Indirect Revenue',1111);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (1100,4000,'Contra Revenue',1111);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (1200,5000,'Direct Expense',1111);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (1300,5000,'Indirect Expense',1111);
INSERT INTO categories (c_id, coa_id, account_type, isid)
VALUES (1400,5000,'Contra Expense',1111);
COMMIT;
END;
/

BEGIN
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (10,100,'Cash');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (20,100,'Short-term investment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (30,100,'Account receivable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (40,100,'Allowance for doubtful accounts');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (50,100,'Interest receivable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (60,100,'Rent receivable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (70,100,'Notes receivable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (80,100,'Merchandise inventory');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (90,100,'Office supplies');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (100,100,'Prepaid insurance');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (110,100,'Prepaid rent');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (120,300,'Accumulate depreciation- Automobiles');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (130,300,'Accumulate depreciation - Trucks');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (140,300,'Accumulate depreciation- Library');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (150,300,'Accumulate depreciation- Furniture');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (160,300,'Accumulate depreciation- Office equipment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (170,300,'Accumulate depreciation- Machinery');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (180,300,'Accumulate depreciation- Building');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (190,300,'Accumulate depreciation- Land improvement');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (200,300,'Accumulate depreciation-Mineral deposit');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (210,300,'Accumulate amortization');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (220,100,'Prepaid interest');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (230,200,'Long-term investment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (240,200,'Automobiles');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (250,200,'Trucks');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (260,200,'Library');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (270,200,'Furniture');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (280,200,'Office equipment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (290,200,'Machinery');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (300,200,'Building');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (310,200,'Land improvement');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (320,200,'Land');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (330,200,'Mineral deposit');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (340,200,'Patents');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (350,200,'Leasehold');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (360,200,'Franchise');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (370,200,'Copyrights');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (380,200,'Leaseholds improvements');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (390,200,'License');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (400,400,'Accounts payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (410,400,'Insurance payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (420,400,'Interest payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (430,400,'Legal fees payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (440,400,'Office salaries payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (450,400,'Rent payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (460,400,'Salaries payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (470,400,'Wages payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (480,400,'Accrued payroll payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (490,400,'Estimated warranty liability');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (500,400,'Income taxes payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (510,400,'Common dividend payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (520,400,'Preferred dividend payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (530,400,'Unemployment tax payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (540,400,'Employee income taxes payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (550,400,'Employee medical insurance payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (560,400,'Employee retirement program payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (570,400,'Employee union dues payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (580,400,'IDRA tax payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (590,400,'Estimated vacation pay liability');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (600,400,'Unearned consulting fees');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (610,400,'Unearned legal fees');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (620,400,'Unearned property management fees');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (630,400,'Unearned janitorial fees');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (640,400,'Unearned rent');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (650,400,'Short-term notes payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (660,400,'Bonds payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (670,500,'Notes payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (680,500,'Long-term notes payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (690,500,'Long-term lease liability');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (700,500,'Deferred income tax liability');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (710,700,'Owner capital');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (720,800,'Owner withdrawals');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (730,700,'Preferred stock');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (740,700,'Retained earnings');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (750,700,'Cash dividends');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (760,700,'Stock dividends');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (770,700,'Treasury stock');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (780,700,'Unrealized gain-Equity');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (790,800,'Unrealized loss-Equity');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (800,700,'Share premium');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (810,900,'Service revenue');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (820,900,'Sales');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (830,1100,'Sales returns and allowance');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (840,1100,'Sales discounts');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (850,1000,'Commission earned');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (860,1000,'Rent revenue');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (870,1000,'Dividend revenue');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (880,1000,'Earnings from investment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (890,1000,'Interest revenue');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (900,1000,'Sinking fund earnings');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (910,1300,'Amortization expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (920,1300,'Depletion expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (930,1300,'Depreciation expense- Automobiles');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (940,1300,'Depreciation expense- Building');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (950,1300,'Depreciation expense- Furniture');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (960,1300,'Depreciation expense- Land improvements');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (970,1300,'Depreciation expense- Library');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (980,1300,'Depreciation expense- Machinery');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (990,1300,'Depreciation expense- Mineral deposit');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1000,1300,'Depreciation expense- Office equipment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1010,1300,'Depreciation expense- Trucks');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1020,1300,'Office salaries expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1030,1300,'Sales salaries expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1040,1300,'Salaries expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1050,1300,'Wages expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1060,1300,'Employee benefits expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1070,1300,'Payroll taxes expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1080,1300,'Cash over and short');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1090,1300,'Discount lost');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1100,1300,'Interest expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1110,1300,'Insurance expense- Delivery equipment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1120,1300,'Insurance expense- Office equipment');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1130,1300,'Rent expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1140,1300,'Press rental expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1150,1300,'Truck rental expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1160,1300,'Office supplies expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1170,1300,'Store supplies expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1180,1300,'Supplies expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1190,1300,'Advertising expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1200,1300,'Bad debts expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1210,1300,'Blueprinting expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1220,1300,'Boat expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1230,1300,'Collection expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1240,1300,'Concessions expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1250,1300,'Credit card expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1260,1300,'Delivery expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1270,1300,'Dumping expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1280,1300,'Equipment expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1290,1300,'Food and drinks expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1300,1300,'Gas and oil expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1310,1300,'General and administrative expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1320,1300,'Janitorial expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1330,1300,'Legal fees expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1340,1300,'Mileage expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1350,1300,'Miscellaneous expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1360,1300,'Tool expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1370,1300,'Permits expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1380,1300,'Postage expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1390,1300,'Property tax expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1400,1300,'Repairs expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1410,1300,'Telephone expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1420,1300,'Travel and entertainment expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1430,1300,'Utilities expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1440,1300,'Warranty expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1450,1200,'Income tax expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1460,1200,'Selling expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1470,1200,'Operating expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1480,1200,'Organization expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1490,1200,'Factoring fee expense');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1500,1200,'Purchase');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1510,1400,'Purchase return');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1520,1400,'Purchase discount');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1530,100,'Bank');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1540,100,'Cash in hand');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1550,100,'Cash at bank');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1560,400,'Short-term loan');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1570,500,'Long-term loan');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1580,600,'Discount on Notes Payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1590,1200,'Freight In');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1600,1200,'Freight Out');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1610,1300,'Compensation');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1620,1300,'Audit Fee');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1630,900,'Inward Commission Received');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1640,100,'Inward Commission Receivable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1650,400,'Inward Commission Received in Advanced');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1660,1200,'Outward Commission Paid');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1670,400,'Outward Commission Payable');
INSERT INTO accounts (acc_id, c_id, particulars)
VALUES (1680,100,'Outward Commission Paid in Advanced');


COMMIT;
END;
/

BEGIN
INSERT INTO user_table (job_id,user_name, passcode)
VALUES ('FI_ACCOUNT','Asif Jamil','ac');                        --job_id must be initially fixed for accounts software
COMMIT;
END;
/


----------------------------------------------------Inserting dynamic data----------------------------------------------------
BEGIN
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (1,'SEP-28-2021','Starting business with 100000','cr','202201000001','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (2,'OCT-01-2021','paid advanced rent 10000 (2 months)','dr','202201000001','Cheque','Rupali Bank','12345678','DO96Y064P','NOV-30-2021',NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO journal_tables(jv_id,date_of_transaction,narration,voucher_type,voucher_no,payment_mode,job_id)
VALUES (3,'OCT-07-2021','Purchase product on credit from Salsabil Traders 60000','jr','202201000001','Credit','FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (4,'OCT-09-2021','Sales of goods in cash 40000 (book value 25000)','cr','202201000002','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO journal_tables(jv_id,date_of_transaction,narration,voucher_type,voucher_no,payment_mode,job_id)
VALUES (5,'OCT-14-2021','Sales of goods on credit to Safin Enterprise 40000 (book value 20000)','jr','202201000002','Credit','FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (6,'OCT-20-2021','3/4 were paid to Salsabil Traders at 3% discount','dr','202201000002','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (7,'OCT-28-2021','Collect 19200 from Safin Enterprise at 4% discount ','cr','202201000003','Cheque','ABC Bank',NULL,'KPE296I3',NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (8,'NOV-02-2021','purchase in cash 90000','dr','202201000003','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (9,'NOV-05-2021','sales of goods in cash 105000 (book value 65000)','cr','202201000004','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO journal_tables(jv_id,date_of_transaction,narration,voucher_type,voucher_no,payment_mode,job_id)
VALUES (10,'NOV-11-2021','purchase product from Rahman on credit 80000','jr','202201000003','Credit','FI_ACCOUNT');
INSERT INTO journal_tables(jv_id,date_of_transaction,narration,voucher_type,voucher_no,payment_mode,job_id)
VALUES (11,'NOV-18-2021','sales of goods to Aziz on credit 120000 (book value 70000)','jr','202201000004','Credit','FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (12,'NOV-21-2021','purchase machine in cash 40000','dr','202201000004','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (13,'NOV-21-2021','take 120000 loan from bank for 2 years','cr','202201000005','Cheque','City Bank',NULL,'EOW4864KJ',NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (14,'NOV-24-2021','paid to accounts payable 50000','dr','202201000005','Cheque','Rupali Bank','12345678','LJU8480WQU',NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no,payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (15,'NOV-28-2021','cash withdraw 50000','dr','202201000006','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no,payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (16,'DEC-02-2021','owner invested 70000 in cash on business','cr','202201000006','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (17,'DEC-04-2021','owner invest 40000 in bank on business again','cr','202201000007','Cheque','Rupali Bank','12345678','896KBIUG34',NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (18,'DEC-09-2021','deposit 30000 in bank','dr','202201000007','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (19,'JAN-01-2022','buy a machine through both in cash and in bank','dr','202201000008','Cheque','Rupali Bank','12345678','D44454DA','JAN-30-2022',NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (20,'JAN-09-2022','get cash 50000 from account receivable, notes with interest expenses','cr','202201000008','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (21,'JAN-09-2022','an account recievable paid to bank account and some paid in cash directly','cr','202201000009','Cheque','Rupali Bank','12345678','DOI234239','MAR-01-2022',NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO journal_tables(jv_id,date_of_transaction,narration,voucher_type,voucher_no,payment_mode,job_id)
VALUES (22,'JAN-10-2022','issue notes 44000 (discount 2000)','jr','202201000005','Credit','FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (23,'JAN-15-2022','gave salaries to all employees','dr','202201000009','Cheque','Rupali Bank','12345678','R3678000','JAN-16-2022',NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (24,'JAN-15-2022','expense while selling product 7420','dr','202201000010','Cheque','Rupali Bank','12345678','PL00021Z','JAN-16-2022',NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO credit_tables (cv_id,date_of_transaction,narration,voucher_type,voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (25,'JAN-23-2022','receive a revenue from rent 24500','cr','202201000010','Cash',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FI_ACCOUNT');
INSERT INTO debit_tables(dv_id, date_of_transaction, narration, voucher_type, voucher_no, payment_mode, bank_name, bank_acc_no, 
cheque_no, cheque_date, credit_card_no, debit_card_no, cardholder_name,job_id)
VALUES (26,'JAN-28-2022','purchase goods with commission 57000','dr','202201000011','Cheque','Rupali Bank','12345678','PL06621Z','FEB-02-2022',NULL,NULL,NULL,'FI_ACCOUNT');



COMMIT;
END;
/

------------------------
BEGIN
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (1, 10, 'sep-28-2021','Cash',100000,0 );
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (1,710,'sep-28-2021','Owner capital',0,100000 );
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (4, 10,'oct-09-2021','Cash',40000,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (4, 820,'oct-09-2021','Sales',0,40000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (7, 1550,'oct-28-2021','Cash at bank',19200,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (7, 30,'oct-28-2021','Account receivable',0,19200);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (9, 10,'nov-05-2021','Cash',105000,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (9, 820,'nov-05-2021','Sales',0,105000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (13, 1550,'nov-21-2021','Cash at bank',120000,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (13, 500,'nov-21-2021','Long-term loan',0,120000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (16, 10,'dec-02-2021','Cash',70000,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (16, 710,'dec-02-2021','Owner capital',0,70000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (17, 1550,'dec-04-2021','Cash at bank',40000,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (17, 710,'dec-04-2021','Owner capital',0,40000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (20, 10,'JAN-09-2022','Cash',50000,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (20, 30,'JAN-09-2022','Account receivable',0,20000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (20, 70,'JAN-09-2022','Notes receivable',0,20000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (20, 890,'JAN-09-2022','Interest revenue',0,10000);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (21, 1540,'JAN-09-2022','Cash in hand',55200,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (21, 1550,'JAN-09-2022','Cash at bank',0,7800);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (21, 30,'JAN-09-2022','Account receivable',0,47400);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (25, 10,'JAN-23-2022','Cash',24500,0);
INSERT INTO transaction_tables (cv_id, acc_id, date_of_transaction, particulars, debit, credit )
VALUES (25, 860,'JAN-23-2022','Rent revenue',0,24500);


INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (2,110,'oct-01-2021','Prepaid rent',10000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (2,1550,'oct-01-2021','Cash at bank',0,10000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (6,400,'oct-20-2021','Accounts payable',43650,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (6,10,'oct-20-2021','Cash',0,43650 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (8,1500,'nov-02-2021','Purchase',90000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (8,10,'nov-02-2021','Cash',0,90000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (12,290,'nov-21-2021','Machinery',40000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (12,10,'nov-21-2021','Cash',0,40000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (14,400,'nov-24-2021','Accounts payable',50000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (14,1550,'nov-24-2021','Cash at bank',0,50000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (15,720,'nov-28-2021','Owner withdrawals',50000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (15,10,'nov-28-2021','Cash',0,50000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (18,1550,'dec-09-2021','Cash at bank',30000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (18,10,'dec-09-2021','Cash',0,30000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (19,290,'jan-01-2022','Machinery',150000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (19,10,'jan-01-2022','Cash',0,50000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (19,1550,'jan-01-2022','Cash at bank',0,100000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (23,1040,'jan-15-2022','Salaries expense',100000,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (23,10,'jan-15-2022','Cash',0,100000 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (24,1460,'jan-15-2022','Selling expense',7420,0 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (24,1550,'jan-15-2022','Cash at bank',0,7420 );
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (26,1500,'JAN-28-2022','Purchase',52000,0 );					
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (26,1590,'JAN-28-2022','Freight In',5000,0 );				
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (26,10,'JAN-28-2022','Cash',0,20000 );				
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (26,1550,'JAN-28-2022','Cash at bank',0,35000 );				
INSERT INTO transaction_tables(dv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (26,1630,'JAN-28-2022','Inward Commission Received',0,2000 );


INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (3,1500,'oct-07-2021' ,'Purchase',60000,0);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (3,400,'oct-07-2021' ,'Accounts payable',0,60000);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (5,30,'oct-14-2021' ,'Account receivable',40000,0);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (5,820,'oct-14-2021' ,'Sales',0,40000);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (10,1500,'nov-11-2021' ,'Purchase',80000,0);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (10,400,'nov-11-2021' ,'Accounts payable',0,80000);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (11,30,'nov-18-2021' ,'Account receivable',70000,0);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (11,820,'nov-18-2021' ,'Sales',0,70000);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (22,400,'JAN-10-2022' ,'Accounts payable',42000,0);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (22,1580,'JAN-10-2022' ,'Discount on Notes Payable',2000,0);
INSERT INTO transaction_tables (jv_id, acc_id, date_of_transaction, particulars, debit, credit)
VALUES (22,680,'JAN-10-2022' ,'Long-term notes payable',0,44000);


COMMIT;
END;
/


ALTER TABLE debit_tables MODIFY (job_id VARCHAR2(20) CONSTRAINT job_dbt_fk REFERENCES jobs(job_id));
ALTER TABLE credit_tables MODIFY (job_id VARCHAR2(20) CONSTRAINT job_cdt_fk REFERENCES jobs(job_id));
ALTER TABLE journal_tables MODIFY (job_id VARCHAR2(20) CONSTRAINT job_jrn_fk REFERENCES jobs(job_id));
COMMIT;

CREATE TABLE finances (
start_date DATE,
end_date DATE,
DPS NUMBER,
CMV NUMBER,
GRD NUMBER,
Tax NUMBER
);

BEGIN
INSERT INTO finances (start_date, end_date, dps, cmv, grd, tax)
VALUES ('JUL-1-2019','JUN-30-2020',10,20,0.05,0.02);

INSERT INTO finances (start_date, end_date, dps, cmv, grd, tax)
VALUES ('JUL-1-2020','JUN-30-2021',10,15,0.07,0.02);

INSERT INTO finances (start_date, end_date, dps, cmv, grd, tax)
VALUES ('JUL-1-2018','JUN-30-2019',15,20,0.04,0.03);

INSERT INTO finances (start_date, end_date, dps, cmv, grd, tax)
VALUES ('JUL-1-2017','JUN-30-2018',15,15,0.08,0.04);
COMMIT;
END;
/

ALTER TABLE chart_of_accounts ADD ( company_id NUMBER CONSTRAINT comp_coa_fk REFERENCES company_details(company_id));
COMMIT;
BEGIN
UPDATE chart_of_accounts
SET company_id = 101;
COMMIT;
END;
/

ALTER TABLE debit_tables ADD(
pay_to VARCHAR2(70),
phone VARCHAR2(30),
address VARCHAR2(500),
email VARCHAR2(255)
);

ALTER TABLE credit_tables ADD(
receive_from VARCHAR2(70),
phone VARCHAR2(30),
address VARCHAR2(500),
email VARCHAR2(255)
);

ALTER TABLE journal_tables ADD(
supplier_name VARCHAR2(70),
phone VARCHAR2(30),
address VARCHAR2(500),
email VARCHAR2(255)
);
COMMIT;
-----------------------------------------------------
BEGIN
UPDATE debit_tables
SET pay_to = 'Hafiz', phone = '+88017XXXXXXXX', address = '14/7, Chandpur', email = 'hafiz@sample.com' WHERE dv_id = 2;
UPDATE debit_tables
SET pay_to = 'Salsabil', phone = '+88017XXXXXXXX', address = '1/7T, Chandpur', email = 'salsabil@sample.com' WHERE dv_id = 6;
UPDATE debit_tables
SET pay_to = 'Karim', phone = '+88017XXXXXXXX', address = '17/Q, Laxmipur', email = 'karim@sample.com' WHERE dv_id = 8;
UPDATE debit_tables
SET pay_to = 'Walton', phone = '+88017XXXXXXXX', address = '14/Y, Polton', email = 'walton@sample.com' WHERE dv_id = 12;
UPDATE debit_tables
SET pay_to = 'Shofiq', phone = '+88017XXXXXXXX', address = '14/G, Karimgonj', email = 'shofiq@sample.com' WHERE dv_id = 14;
UPDATE debit_tables
SET pay_to = 'Owner X', phone = '+88017XXXXXXXX', address = '1/70, Chandpur', email = 'owner@sample.com' WHERE dv_id = 15;
UPDATE debit_tables
SET pay_to = 'Rupali Bank Ltd', phone = '+88017XXXXXXXX', address = '18/C/6, Shukrabad', email = 'rupalibankltd@sample.com' WHERE dv_id = 18;
UPDATE debit_tables
SET pay_to = 'Selim', phone = '+88018XXXXXXXX', address = 'Karwanbazar', email = 'selim@sample.com'
WHERE dv_id = 19;
UPDATE debit_tables
SET pay_to = 'Arafat', phone = '+88018XXXXXXXX', address = 'Nilkhet', email = 'arafat@sample.com'
WHERE dv_id = 23;
UPDATE debit_tables
SET pay_to = 'Rubaya', phone = '+88018XXXXXXXX', address = 'Mirpur-14', email = 'rubaya@sample.com'
WHERE dv_id = 24;
UPDATE debit_tables
SET pay_to = 'Akter', phone = '+88018XXXXXXXX', address = 'Mirpur-14', email = 'akt@sample.com'
WHERE dv_id = 26;
COMMIT;
END;
/
BEGIN
UPDATE credit_tables
SET receive_from = 'owner x', phone = '+88015XXXXXXXX', address ='1/H,Amin bazar', email = 'owner@sample.com' WHERE cv_id = 1; 
UPDATE credit_tables
SET receive_from = 'Shobuj', phone = '+88015XXXXXXXX', address ='1/H,Karwan bazar', email = 'shobuj@sample.com' WHERE cv_id = 4; 
UPDATE credit_tables
SET receive_from = 'Safin Enterprise', phone = '+88015XXXXXXXX', address ='1/7,Agargoan bazar', email = 'safin@sample.com' WHERE cv_id = 7; 
UPDATE credit_tables
SET receive_from = 'Udvash', phone = '+88015XXXXXXXX', address ='1/E,Shewarapara', email = 'udvash47@sample.com' WHERE cv_id = 9; 
UPDATE credit_tables
SET receive_from = 'City Bank', phone = '+88015XXXXXXXX', address ='15/3,Aftab Nagar', email = 'citybankltd@sample.com' WHERE cv_id = 13; 
UPDATE credit_tables
SET receive_from = 'owner x', phone = '+88015XXXXXXXX', address ='1/25,Mirpur', email = 'owner@sample.com' WHERE cv_id = 16; 
UPDATE credit_tables
SET receive_from = 'owner x', phone = '+88015XXXXXXXX', address ='1/9,Savar', email = 'owner@sample.com' WHERE cv_id = 17;
UPDATE credit_tables
SET receive_from = 'Taslima', phone = '+88015XXXXXXXX', address = '55/T,Shewrapara', email = 'tas@sample.com'
WHERE cv_id = 20;
UPDATE credit_tables
SET receive_from = 'Aminul', phone = '+88015XXXXXXXX', address = 'Mukti Housing', email = 'amn@sample.com'
WHERE cv_id = 21;
UPDATE credit_tables
SET receive_from = 'Hakim', phone = '+88015XXXXXXXX', address = 'Mirpur 11', email = 'hakim@sample.com'
WHERE cv_id = 25;
COMMIT;
END;
/
BEGIN
UPDATE journal_tables
SET supplier_name = 'Salsabil', phone = '018XXXXXXXX', address = '42/4,Kolabagan', email = 'salsabil@sample.com' WHERE jv_id = 3;
UPDATE journal_tables
SET supplier_name = 'Safin', phone = '018XXXXXXXX', address = 'Banani', email = 'safin@sample.com' WHERE jv_id = 5;
UPDATE journal_tables
SET supplier_name = 'Rahman', phone = '018XXXXXXXX', address = '42/4,Kolabagan', email = 'rahman@sample.com' WHERE jv_id = 10;
UPDATE journal_tables
SET supplier_name = 'Aziz', phone = '018XXXXXXXX', address = 'Mirpur 1', email = 'aziz@sample.com' WHERE jv_id = 11;
UPDATE journal_tables
SET supplier_name = 'Yakub', phone = '+88016XXXXXXXX', address = '4/5,Mirpur', email = 'yakub@sample.com'
WHERE jv_id = 22;
COMMIT;
END;
/
ALTER TABLE company_details ADD (logo BLOB);
COMMIT;
--------------------------------------------------------------------------------------------------------Function
CREATE FUNCTION  acc_currval RETURN NUMBER
AS
v_currval NUMBER;
BEGIN
SELECT GREATEST((SELECT MAX(dv_id) FROM debit_tables), 
              (SELECT MAX(cv_id) FROM credit_tables),
              (SELECT MAX(jv_id) FROM journal_tables)) + 1  voucher_sequence
INTO v_currval
              FROM dual;
RETURN v_currval;
END;
/

CREATE FUNCTION acc_currval2 RETURN NUMBER
AS
v_curr NUMBER;
BEGIN
SELECT MAX(ACC_ID) + 10
INTO v_curr
FROM accounts;
RETURN v_curr;
END;
/

CREATE FUNCTION dr_voucher_seq RETURN VARCHAR2 AS
    v_debit_vou_seq VARCHAR2(35);
		BEGIN
		SELECT 
		TO_CHAR(SYSDATE,'YYYYMM')||LPAD(NVL(MAX(SUBSTR(VOUCHER_NO,7)),0)+1,6,0) 
		INTO v_debit_vou_seq
		FROM DEBIT_TABLES; 
		RETURN v_debit_vou_seq;
    END;
/

CREATE FUNCTION cr_voucher_seq RETURN VARCHAR2 AS
    v_credit_vou_seq VARCHAR2(35);
		BEGIN
		SELECT 
		TO_CHAR(SYSDATE,'YYYYMM')||LPAD(NVL(MAX(SUBSTR(VOUCHER_NO,7)),0)+1,6,0) 
		INTO v_credit_vou_seq
		FROM CREDIT_TABLES; 
		RETURN v_credit_vou_seq;
    END;
/

 CREATE FUNCTION jr_voucher_seq RETURN VARCHAR2 AS
    v_journal_vou_seq VARCHAR2(35);
		BEGIN
		SELECT 
		TO_CHAR(SYSDATE,'YYYYMM')||LPAD(NVL(MAX(SUBSTR(VOUCHER_NO,7)),0)+1,6,0) 
		INTO v_journal_vou_seq
		FROM JOURNAL_TABLES; 
		RETURN v_journal_vou_seq;
    END;
/

CREATE FUNCTION debit_trial(p_ac NUMBER, p_from DATE, p_to DATE)
RETURN NUMBER
IS
v_acc NUMBER;
v_particulars VARCHAR2(200);
v_dr NUMBER;
v_cr NUMBER;
BEGIN
SELECT SUM(debit)-SUM(credit) DEBIT,NVL(NULL,0) CREDIT
INTO  v_dr, v_cr
FROM transaction_tables
WHERE date_of_transaction BETWEEN p_from AND p_to AND acc_id = p_ac  --must match with 2nd WHERE
GROUP BY  acc_id, particulars
HAVING acc_id IN(SELECT acc_id 
FROM accounts
JOIN categories
USING (c_id)
WHERE c_id IN (100,200,600,800,1100,1200,1300));
RETURN v_dr;
END;
/
----------------------------
CREATE FUNCTION credit_trial(p_ac NUMBER, p_from DATE, p_to DATE)
RETURN NUMBER
IS
v_acc NUMBER;
v_particulars VARCHAR2(200);
v_dr NUMBER;
v_cr NUMBER;
BEGIN
SELECT NVL(NULL,0),SUM(debit)-SUM(credit) CREDIT
INTO  v_dr, v_cr
FROM transaction_tables
WHERE date_of_transaction BETWEEN p_from AND p_to AND acc_id = p_ac  --must match with 2nd WHERE
GROUP BY  acc_id, particulars
HAVING acc_id IN(SELECT acc_id 
FROM accounts
JOIN categories
USING (c_id)
WHERE c_id IN (300,400,500,700,900,1000,1400));
RETURN v_cr;
END;
/


CREATE OR REPLACE FUNCTION equality RETURN BOOLEAN IS
--DECLARE
v_dr    number;
v_cr    number;
BEGIN
SELECT SUM(debit) INTO v_dr FROM transaction_tables;
--DBMS_OUTPUT.PUT_LINE(v_dr);
SELECT SUM(credit) INTO v_cr FROM transaction_tables;
--DBMS_OUTPUT.PUT_LINE(v_cr);
IF v_dr = v_cr THEN
RETURN TRUE;
--DBMS_OUTPUT.PUT_LINE('TRIGGER FIRE');
ELSE
RETURN FALSE;
--DBMS_OUTPUT.PUT_LINE('NO FIRE');
END IF;
END;
/

------------------------------------------------------------------- GROSS profit mergin
CREATE FUNCTION ratio_gross(p_id NUMBER) RETURN NUMBER IS
--DECLARE
v_sales number;
v_purchase number;
v_gross NUMBER;
v_sales_p VARCHAR2(100);
s_amount NUMBER;
v_gross_mergin NUMBER;
BEGIN
SELECT balanced  INTO v_sales 
FROM account_balanced ab, accounts acc, categories cat, chart_of_accounts coa, company_details comp 
WHERE   ab.acc_id = acc.acc_id AND acc.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND  comp.company_id = p_id AND  ab.particulars = 'Sales';
SELECT balanced INTO v_purchase 
FROM account_balanced ab, accounts acc, categories cat, chart_of_accounts coa, company_details comp
WHERE   ab.acc_id = acc.acc_id AND acc.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND  comp.company_id = p_id AND  ab.particulars = 'Purchase';
--:CTRL_BLOCK.GROSS_PROFIT := TO_CHAR(v_sales + v_purchase,'999G99G99G990D99PR');
v_gross := v_sales + v_purchase;
--DBMS_OUTPUT.PUT_LINE(v_gross);

SELECT ab.particulars, balanced
INTO v_sales_p, s_amount
FROM account_balanced ab, accounts acc, categories cat, chart_of_accounts coa, company_details comp
WHERE   ab.acc_id = acc.acc_id AND acc.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND  comp.company_id = p_id AND  ab.particulars = 'Sales';

v_gross_mergin := ROUND(v_gross / s_amount,2);
--DBMS_OUTPUT.PUT_LINE(v_gross_mergin);
RETURN v_gross_mergin;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN 0;
--MESSAGE('NO DATA FOR THIS COMPANY');

END;
/


CREATE FUNCTION ratio_net(p_id number) RETURN number is
-----------------------------------------------------------net profit margin
--DECLARE
v_net NUMBER;
v_sales_ps VARCHAR2(100);
s_amounts NUMBER;
v_net_p_margin NUMBER;
BEGIN
SELECT SUM(debit) - SUM(credit)
--INTO :CTRL_BLOCK.NET_INCOME
INTO v_net
FROM transaction_tables tr,accounts ac, categories cat,income_statements inc, chart_of_accounts coa, company_details comp 
WHERE tr.acc_id = ac.acc_id
AND ac.c_id = cat.c_id
AND cat.isid = inc.isid AND inc.coa_id = coa.coa_id AND comp.company_id = coa.company_id
AND inc.isid = 1111 AND comp.company_id = p_id;
--DBMS_OUTPUT.PUT_LINE(v_net);

SELECT ab.particulars, balanced
INTO v_sales_ps, s_amounts
FROM account_balanced ab, accounts acc, categories cat, chart_of_accounts coa, company_details comp
WHERE   ab.acc_id = acc.acc_id AND acc.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND  comp.company_id = p_id AND  ab.particulars = 'Sales';
v_net_p_margin := ROUND(v_net/ s_amounts,2);
--DBMS_OUTPUT.PUT_LINE(v_net_p_margin);
RETURN v_net_p_margin;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN 0;
--MESSAGE('NO DATA FOR THIS COMPANY');
END;
/


CREATE FUNCTION ratio_cash(p_id number) return number is
------------------------------------------------------------------------ Cash ratio
--DECLARE
v_cash_pc VARCHAR2(100);
v_cash_c NUMBER;
v_cash_hand_pc VARCHAR2(100);
v_cash_handc NUMBER;
v_curr_pc VARCHAR2(100);
v_currc NUMBER;
v_cash NUMBER;
BEGIN
SELECT ab.particulars, NVL(balanced,0)
INTO v_cash_pc, v_cash_c
FROM account_balanced ab, accounts acc, categories cat, chart_of_accounts coa, company_details comp
WHERE  ab.acc_id = acc.acc_id AND acc.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND  comp.company_id = p_id AND  ab.particulars = 'Cash';

SELECT NVL(ab.particulars,'N/A'), NVL(balanced,0)
INTO v_cash_hand_pc, v_cash_handc
FROM account_balanced ab, accounts acc, categories cat, chart_of_accounts coa, company_details comp
WHERE  ab.acc_id = acc.acc_id AND acc.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND  comp.company_id = p_id AND  ab.particulars = 'Cash in hand';   


SELECT account_type, NVL((SUM(debit)-SUM(credit)),0) amount
INTO v_curr_pc, v_currc
FROM transaction_tables tr , accounts ac , categories cat , chart_of_accounts coa, company_details comp 
WHERE tr.acc_id = ac.acc_id AND ac.c_id  = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND comp.company_id = p_id
GROUP BY account_type
HAVING account_type = 'Current Liabilities';

v_cash :=  NVL(ABS(ROUND((v_cash_c + v_cash_handc)  / v_currc,2)),0);
return v_cash;
EXCEPTION
WHEN NO_DATA_FOUND THEN
return 0;
--DBMS_OUTPUT.PUT_LINE('Please enter initial value for Cash, Cash in hand, Current Liabilities');
--MESSAGE('Please enter initial value for Cash, Cash in hand, Current Liabilities');
END;
/

create function ratio_current(p_id number) return number is
--------------------------------------------current ratio
--DECLARE
v_acc_type2 VARCHAR2(100);
v_curras_amount NUMBER;
v_acc_type3 VARCHAR2(100);
v_currli_amount NUMBER;
v_cur_ratio NUMBER;
BEGIN
SELECT account_type, SUM(debit)-SUM(credit) amount
INTO v_acc_type2, v_curras_amount
FROM transaction_tables tr , accounts ac , categories cat, chart_of_accounts coa, company_details comp  
WHERE tr.acc_id = ac.acc_id AND ac.c_id  = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND comp.company_id = p_id
GROUP BY account_type
HAVING account_type = 'Current Asset';

SELECT account_type, SUM(debit)-SUM(credit) amount
INTO v_acc_type3, v_currli_amount
FROM transaction_tables tr , accounts ac , categories cat , chart_of_accounts coa, company_details comp 
WHERE tr.acc_id = ac.acc_id AND ac.c_id  = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND comp.company_id = p_id
GROUP BY account_type
HAVING account_type = 'Current Liabilities';
v_cur_ratio := NVL( ABS(ROUND(v_curras_amount / v_currli_amount,2)),0);
return v_cur_ratio;
EXCEPTION
WHEN NO_DATA_FOUND THEN
return 0;
--MESSAGE('NO_DATA FOR THIS COMPANY');
--DBMS_OUTPUT.PUT_LINE(v_cur_ratio);
END;
/
---------------------------------------------------------------------------------------------------------View

CREATE OR REPLACE VIEW account_balanced AS
SELECT acc_id, particulars, SUM(debit)-SUM(credit) balanced
FROM transaction_tables
GROUP BY  acc_id, particulars;
/

CREATE OR REPLACE VIEW trial_balance AS
SELECT acc_id, particulars, SUM(debit)-SUM(credit) DEBIT,NVL(NULL,0) CREDIT
FROM transaction_tables
GROUP BY  acc_id, particulars
HAVING acc_id IN(SELECT acc_id 
FROM accounts
JOIN categories
USING (c_id)
WHERE c_id IN (100,200,600,800,1100,1200,1300))
UNION
SELECT acc_id, particulars,NVL(NULL,0),SUM(debit)-SUM(credit) CREDIT
FROM transaction_tables
GROUP BY  acc_id, particulars
HAVING acc_id IN(SELECT acc_id 
FROM accounts
JOIN categories
USING (c_id)
WHERE c_id IN(300,400,500,700,900,1000,1400));
/

create OR REPLACE view ledger as 
SELECT DISTINCT cv_id trans_id, date_of_transaction,particulars, narration, debit, credit, debit-credit balanced
FROM transaction_tables
NATURAL JOIN credit_tables
UNION
SELECT DISTINCT dv_id trans_id, date_of_transaction,particulars, narration, debit, credit, debit-credit balanced
FROM transaction_tables
NATURAL JOIN debit_tables
UNION
SELECT DISTINCT jv_id trans_id, date_of_transaction, particulars, narration, debit, credit, debit-credit balanced
FROM transaction_tables
NATURAL JOIN journal_tables
ORDER BY 1;
/


CREATE OR REPLACE VIEW acc_type_amount AS    
SELECT company_id,c_id, account_type, SUM(debit)-SUM(credit) amount
FROM transaction_tables
JOIN accounts
USING(acc_id)
JOIN categories
USING (c_id)
JOIN chart_of_accounts
USING (coa_id)
JOIN company_details
USING (company_id)
GROUP BY  company_id,c_id,account_type;
/

CREATE OR REPLACE VIEW inc_state AS
SELECT comp.company_id,inc.isid,description, SUM(debit) - SUM(credit) net_amount 
FROM transaction_tables tt, accounts acc, categories cat, income_statements inc, chart_of_accounts coa, company_details comp
WHERE tt.acc_id = acc.acc_id
AND acc.c_id = cat.c_id
AND cat.isid = inc.isid
AND inc.coa_id = coa.coa_id
AND coa.company_id = comp.company_id
GROUP BY comp.company_id,inc.isid,description;
/

CREATE OR REPLACE VIEW  equity_details AS          
SELECT company_id, c_id cat_inc_id, account_type, amount FROM acc_type_amount
WHERE account_type LIKE '%Equity%'
UNION
SELECT comp.company_id,inc.isid,description, SUM(debit) - SUM(credit) 
FROM transaction_tables tt, accounts acc, categories cat, income_statements inc, chart_of_accounts coa, company_details comp
WHERE tt.acc_id = acc.acc_id
AND acc.c_id = cat.c_id
AND cat.isid = inc.isid
AND inc.coa_id = coa.coa_id
AND coa.company_id = comp.company_id
GROUP BY comp.company_id,inc.isid,description;
/

CREATE OR REPLACE VIEW chart_of_acc AS
SELECT accounts_head, NVL(SUM(debit) - SUM(credit),0) amount
FROM transaction_tables
JOIN accounts
USING (acc_id)
JOIN categories
USING (c_id)
JOIN chart_of_accounts
USING (coa_id)
GROUP BY accounts_head
HAVING accounts_head != 'Equity'
UNION
SELECT  NVL(NULL,'Equity') , NVL(SUM(amount),0) amount
FROM equity_details;
/


CREATE OR REPLACE VIEW debit_voucher
AS
SELECT dr.date_of_transaction,voucher_no,narration,  particulars, debit, credit
FROM transaction_tables tr
JOIN debit_tables dr
USING (dv_id);
/

CREATE OR REPLACE VIEW credit_voucher
AS
SELECT cr.date_of_transaction,voucher_no,narration, particulars, debit, credit
FROM transaction_tables tr
JOIN credit_tables cr
USING (cv_id);
/

CREATE OR REPLACE VIEW journal_voucher
AS
SELECT jr.date_of_transaction,voucher_no,narration, particulars, debit, credit
FROM transaction_tables tr
JOIN journal_tables jr
USING (jv_id);
/
CREATE OR REPLACE VIEW current_asset
AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Current Asset';
/

CREATE OR REPLACE VIEW fixed_asset
AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Fixed Asset';
/

CREATE OR REPLACE VIEW contra_asset
AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Contra Asset';
/
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW current_liabilities
AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Current Liabilities';
/

CREATE OR REPLACE VIEW fixed_liabilities
AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Non-Current Liabilities';
/

CREATE OR REPLACE VIEW contra_liabilities
AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Contra Liabilities';
/

CREATE OR REPLACE VIEW owner_equity AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Owner Equity';
/

CREATE OR REPLACE VIEW contra_equity AS
SELECT ab.acc_id, ab.particulars, balanced 
FROM account_balanced ab, accounts ac, categories cat 
WHERE ac.acc_id = ab.acc_id
AND cat.c_id = ac.c_id
AND account_type = 'Contra Equity';
/

CREATE OR REPLACE VIEW accounts_view 
AS
SELECT acc_id , particulars , accounts_head
FROM accounts
JOIN categories
USING (c_id)
JOIN chart_of_accounts
USING (coa_id);
/

/* Formatted on 1/26/2022 11:57:24 AM (QP5 v5.318) */
CREATE OR REPLACE VIEW monthly_cash
AS
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-JAN-21') FROM DUAL)) Date_m,
             particulars,
             SUM (debit) - SUM (credit)                        amount --TO_DATE using from WHERE subquery
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-JAN-21'
                                         AND (SELECT LAST_DAY ('01-JAN-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540) --date are static, acc_id = CASH ONLY
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for all query
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-FEB-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-FEB-21'
                                         AND (SELECT LAST_DAY ('01-FEB-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-MAR-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-MAR-21'
                                         AND (SELECT LAST_DAY ('01-MAR-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-APR-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-APR-21'
                                         AND (SELECT LAST_DAY ('01-APR-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-MAY-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-MAY-21'
                                         AND (SELECT LAST_DAY ('01-MAY-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-JUN-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-JUN-21'
                                         AND (SELECT LAST_DAY ('01-JUN-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-JUL-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-JUL-21'
                                         AND (SELECT LAST_DAY ('01-JUL-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-AUG-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-AUG-21'
                                         AND (SELECT LAST_DAY ('01-AUG-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-SEP-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-SEP-21'
                                         AND (SELECT LAST_DAY ('01-SEP-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-OCT-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-OCT-21'
                                         AND (SELECT LAST_DAY ('01-OCT-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-NOV-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-NOV-21'
                                         AND (SELECT LAST_DAY ('01-NOV-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-DEC-21') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-DEC-21'
                                         AND (SELECT LAST_DAY ('01-DEC-21')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-JAN-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-JAN-22'
                                         AND (SELECT LAST_DAY ('01-JAN-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-FEB-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-FEB-22'
                                         AND (SELECT LAST_DAY ('01-FEB-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-MAR-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-MAR-22'
                                         AND (SELECT LAST_DAY ('01-MAR-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-APR-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-APR-22'
                                         AND (SELECT LAST_DAY ('01-APR-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-MAY-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-MAY-22'
                                         AND (SELECT LAST_DAY ('01-MAY-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300)) --enhancing monthly query by using UNION
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-JUN-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-JUN-22'
                                         AND (SELECT LAST_DAY ('01-JUN-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-JUL-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-JUL-22'
                                         AND (SELECT LAST_DAY ('01-JUL-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-AUG-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-AUG-22'
                                         AND (SELECT LAST_DAY ('01-AUG-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-SEP-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-SEP-22'
                                         AND (SELECT LAST_DAY ('01-SEP-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-OCT-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-OCT-22'
                                         AND (SELECT LAST_DAY ('01-OCT-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-NOV-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-NOV-22'
                                         AND (SELECT LAST_DAY ('01-NOV-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540)
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))
    ----------------------------------------------------------------------
    UNION
      ----------------------------------------------------------------------
      SELECT TO_DATE ((SELECT LAST_DAY ('01-DEC-22') FROM DUAL)),
             particulars,
             SUM (debit) - SUM (credit)                        --change MON-YY
        FROM transaction_tables
       WHERE     date_of_transaction BETWEEN '01-DEC-22'
                                         AND (SELECT LAST_DAY ('01-DEC-22')
                                                FROM DUAL)
             AND (acc_id = 10 OR acc_id = 1540) --change MON-YY as the same as SELEC line
    GROUP BY TO_DATE ('01-JAN-21'), acc_id, particulars --TO_DATE is same for each query to match data type only, no need to change
      HAVING acc_id IN (SELECT acc_id
                          FROM accounts JOIN categories USING (c_id)
                         WHERE c_id IN (100,
                                        200,
                                        600,
                                        800,
                                        1100,
                                        1200,
                                        1300))  --DEC 2022/cashandcash_in_hand
    ----------------------------------------------------------------------

    --add more monthly query before order by, using UNION and change only MON and YY
    --copy a set of a query and change MON-YY, acc_id manually;
/

CREATE OR REPLACE VIEW trial_balance_pro AS
SELECT comp.company_id,tb.acc_id, tb.particulars, debit, credit 	--view(pk/fk),table(pk/fk) include all key in SELECT clause where view and table is joined togather 
FROM trial_balance tb, accounts acc, categories cat, chart_of_accounts coa, company_details comp
WHERE tb.acc_id = acc.acc_id
AND acc.c_id = cat.c_id
AND cat.coa_id = coa.coa_id
AND coa.company_id = comp.company_id;
/

CREATE OR REPLACE VIEW current_asset_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM current_asset ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/


CREATE OR REPLACE VIEW fixed_asset_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM fixed_asset ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/


CREATE OR REPLACE VIEW contra_asset_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM contra_asset ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/

CREATE OR REPLACE VIEW fixed_liabilities_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM fixed_liabilities ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/


CREATE OR REPLACE VIEW contra_liabilities_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM contra_liabilities ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/


CREATE OR REPLACE VIEW owner_equity_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM owner_equity ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/


CREATE OR REPLACE VIEW contra_equity_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM contra_equity ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/

CREATE OR REPLACE VIEW current_liabilities_pro AS
SELECT comp.company_id, ac.acc_id, ac.particulars, balanced FROM current_liabilities ca, accounts ac, categories cat, chart_of_accounts coa, company_details comp
WHERE ca.acc_id = ac.acc_id AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id;
/
CREATE OR REPLACE VIEW ledger_pro AS
select distinct comp.company_id, lr.trans_id, lr.date_of_transaction, lr.particulars, lr.narration, lr.debit, lr.credit, lr.balanced
from ledger lr, debit_tables dr, credit_tables cr, journal_tables jr, jobs jb, company_details comp
where lr.trans_id in (dr.dv_id, cr.cv_id, jr.jv_id)
and jb.job_id in (dr.job_id, cr.job_id, jr.job_id)
and comp.company_id = jb.company_id;
/

CREATE OR REPLACE VIEW DEBIT_voucher_PRO
AS
SELECT COMP.COMPANY_ID,DR.DV_ID, DR.DATE_OF_TRANSACTION, DR.NARRATION, DR.VOUCHER_TYPE, DR.VOUCHER_NO, DR.USER_ID, DR.PAYMENT_MODE,DR.BANK_NAME,DR.BANK_ACC_NO, DR.CHEQUE_NO,
DR.CHEQUE_DATE, DR.CREDIT_CARD_NO, DR.DEBIT_CARD_NO,DR.CARDHOLDER_NAME,DR.JOB_ID, DR.PAY_TO, DR.PHONE, DR.ADDRESS, DR.EMAIL
FROM DEBIT_TABLES DR, JOBS J,COMPANY_DETAILS COMP
WHERE DR.JOB_ID=J.JOB_ID AND COMP.COMPANY_ID=J.COMPANY_ID;
/
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW credit_voucher_PRO
AS
SELECT COMP.COMPANY_ID,CR.CV_ID, CR.DATE_OF_TRANSACTION, CR.NARRATION, CR.VOUCHER_TYPE, CR.VOUCHER_NO, CR.USER_ID, CR.PAYMENT_MODE,CR.BANK_NAME,
CR.BANK_ACC_NO, CR.CHEQUE_NO, CR.CHEQUE_DATE, CR.CREDIT_CARD_NO, CR.DEBIT_CARD_NO,CR.CARDHOLDER_NAME,CR.JOB_ID, CR.RECEIVE_FROM, CR.PHONE, CR.ADDRESS, CR.EMAIL
FROM CREDIT_TABLES CR, JOBS J,COMPANY_DETAILS COMP
WHERE CR.JOB_ID=J.JOB_ID AND COMP.COMPANY_ID=J.COMPANY_ID;
/
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW JOURNAL_voucher_PRO
AS
SELECT COMP.COMPANY_ID,JR.JV_ID, JR.DATE_OF_TRANSACTION, JR.NARRATION, JR.VOUCHER_TYPE, JR.VOUCHER_NO, JR.USER_ID, JR.PAYMENT_MODE,JR.JOB_ID, JR.SUPPLIER_NAME, JR.PHONE, JR.ADDRESS, JR.EMAIL
FROM JOURNAL_TABLES JR, JOBS J,COMPANY_DETAILS COMP
WHERE JR.JOB_ID=J.JOB_ID AND COMP.COMPANY_ID=J.COMPANY_ID;
/

CREATE OR REPLACE VIEW asset AS
SELECT acc_id, particulars, NVL(SUM(balanced),0) amount
FROM fixed_asset
GROUP BY acc_id, particulars
UNION
SELECT acc_id, particulars, NVL(SUM(balanced),0)
FROM current_asset
GROUP BY acc_id, particulars
UNION
SELECT acc_id, particulars, NVL(SUM(balanced),0)
FROM contra_asset
GROUP BY acc_id, particulars;
/

CREATE OR REPLACE VIEW liability AS
SELECT cl.acc_id, cl.particulars, NVL(SUM(balanced),0) amount
FROM current_liabilities cl, transaction_tables tt
WHERE tt.acc_id = cl.acc_id
GROUP BY cl.acc_id, cl.particulars 
UNION
SELECT  con.acc_id, con.particulars, NVL(SUM(balanced),0)
FROM contra_liabilities con, transaction_tables tt
WHERE tt.acc_id = con.acc_id
GROUP BY  con.acc_id, con.particulars
UNION
SELECT  fl.acc_id, fl.particulars, NVL(SUM(balanced),0) amount
FROM fixed_liabilities fl, transaction_tables tt
WHERE fl.acc_id = tt.acc_id
GROUP BY  fl.acc_id, fl.particulars;
/

CREATE OR REPLACE VIEW equity AS
SELECT acc_id, particulars, NVL(balanced,0) amount FROM owner_equity
UNION
SELECT acc_id, particulars, NVL(balanced,0) FROM contra_equity
UNION
SELECT isid, description, NVL(net_amount,0) FROM inc_state;
/

CREATE OR REPLACE VIEW monthly_cash_pro AS
SELECT DISTINCT cd.company_id, date_m, mc.particulars, amount, ac.acc_id from monthly_cash mc, accounts ac, categories cat, chart_of_accounts coa, company_details cd
WHERE mc.particulars = ac.particulars AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = cd.company_id;
/
CREATE OR REPLACE VIEW monthly_cashatbank
AS
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JAN-21') FROM DUAL
    )) Date_m,
    particulars,
    SUM (debit) - SUM (credit) amount --TO_DATE using from WHERE subquery
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JAN-21' AND (SELECT LAST_DAY ('01-JAN-21') FROM DUAL)
  AND ( acc_id   = 1550) --date are static, acc_id = CASH ONLY
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for all query
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-FEB-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-FEB-21' AND (SELECT LAST_DAY ('01-FEB-21') FROM DUAL)
  AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAR-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAR-21' AND (SELECT LAST_DAY ('01-MAR-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-APR-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-APR-21' AND (SELECT LAST_DAY ('01-APR-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAY-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAY-21' AND (SELECT LAST_DAY ('01-MAY-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUN-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUN-21' AND (SELECT LAST_DAY ('01-JUN-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUL-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUL-21' AND (SELECT LAST_DAY ('01-JUL-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-AUG-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-AUG-21' AND (SELECT LAST_DAY ('01-AUG-21') FROM DUAL)
  AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-SEP-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-SEP-21' AND (SELECT LAST_DAY ('01-SEP-21') FROM DUAL)
  AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-OCT-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-OCT-21' AND (SELECT LAST_DAY ('01-OCT-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-NOV-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-NOV-21' AND (SELECT LAST_DAY ('01-NOV-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-DEC-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-DEC-21' AND (SELECT LAST_DAY ('01-DEC-21') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JAN-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JAN-22' AND (SELECT LAST_DAY ('01-JAN-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-FEB-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-FEB-22' AND (SELECT LAST_DAY ('01-FEB-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAR-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAR-22' AND (SELECT LAST_DAY ('01-MAR-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-APR-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-APR-22' AND (SELECT LAST_DAY ('01-APR-22') FROM DUAL)
  AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAY-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAY-22' AND (SELECT LAST_DAY ('01-MAY-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    ) --enhancing monthly query by using UNION
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUN-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUN-22' AND (SELECT LAST_DAY ('01-JUN-22') FROM DUAL)
  AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUL-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUL-22' AND (SELECT LAST_DAY ('01-JUL-22') FROM DUAL)
  AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-AUG-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-AUG-22' AND (SELECT LAST_DAY ('01-AUG-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-SEP-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-SEP-22' AND (SELECT LAST_DAY ('01-SEP-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-OCT-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-OCT-22' AND (SELECT LAST_DAY ('01-OCT-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-NOV-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-NOV-22' AND (SELECT LAST_DAY ('01-NOV-22') FROM DUAL)
  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-DEC-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit) --change MON-YY
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-DEC-22' AND (SELECT LAST_DAY ('01-DEC-22') FROM DUAL)
  AND ( acc_id   = 1550) --change MON-YY as the same as SELEC line
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only, no need to change
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    ) --DEC 2022/cashandcash_in_hand
    ----------------------------------------------------------------------
    --add more monthly query before order by, using UNION and change only MON and YY
    --copy a set of a query and change MON-YY, acc_id manually;
  /
CREATE OR REPLACE VIEW monthly_cashatbank_pro AS
SELECT DISTINCT cd.company_id, date_m, mc.particulars, amount, ac.acc_id from monthly_cashatbank mc, accounts ac, categories cat, chart_of_accounts coa, company_details cd
WHERE mc.particulars = ac.particulars AND ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = cd.company_id;
/

CREATE OR REPLACE VIEW as_month AS 
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JAN-21') FROM DUAL
    )) Date_m,
    particulars,
    SUM (debit) - SUM (credit) amount --TO_DATE using from WHERE subquery
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JAN-21' AND (SELECT LAST_DAY ('01-JAN-21') FROM DUAL)
 --- AND ( acc_id   = 1550) --date are static, acc_id = CASH ONLY
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for all query
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-FEB-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-FEB-21' AND (SELECT LAST_DAY ('01-FEB-21') FROM DUAL)
  ----AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAR-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAR-21' AND (SELECT LAST_DAY ('01-MAR-21') FROM DUAL)
 --- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-APR-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-APR-21' AND (SELECT LAST_DAY ('01-APR-21') FROM DUAL)
 ----- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAY-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAY-21' AND (SELECT LAST_DAY ('01-MAY-21') FROM DUAL)
 ----- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUN-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUN-21' AND (SELECT LAST_DAY ('01-JUN-21') FROM DUAL)
-----  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUL-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUL-21' AND (SELECT LAST_DAY ('01-JUL-21') FROM DUAL)
 ----- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-AUG-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-AUG-21' AND (SELECT LAST_DAY ('01-AUG-21') FROM DUAL)
 ----- AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-SEP-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-SEP-21' AND (SELECT LAST_DAY ('01-SEP-21') FROM DUAL)
  -----AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-OCT-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-OCT-21' AND (SELECT LAST_DAY ('01-OCT-21') FROM DUAL)
 ----- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-NOV-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-NOV-21' AND (SELECT LAST_DAY ('01-NOV-21') FROM DUAL)
  -----AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-DEC-21') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-DEC-21' AND (SELECT LAST_DAY ('01-DEC-21') FROM DUAL)
 ---- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JAN-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JAN-22' AND (SELECT LAST_DAY ('01-JAN-22') FROM DUAL)
 ---- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-FEB-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-FEB-22' AND (SELECT LAST_DAY ('01-FEB-22') FROM DUAL)
 ----- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAR-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAR-22' AND (SELECT LAST_DAY ('01-MAR-22') FROM DUAL)
 ---- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-APR-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-APR-22' AND (SELECT LAST_DAY ('01-APR-22') FROM DUAL)
----  AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-MAY-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-MAY-22' AND (SELECT LAST_DAY ('01-MAY-22') FROM DUAL)
 --- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    ) --enhancing monthly query by using UNION
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUN-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUN-22' AND (SELECT LAST_DAY ('01-JUN-22') FROM DUAL)
 --- AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-JUL-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-JUL-22' AND (SELECT LAST_DAY ('01-JUL-22') FROM DUAL)
 --- AND ( acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-AUG-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-AUG-22' AND (SELECT LAST_DAY ('01-AUG-22') FROM DUAL)
 --- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-SEP-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-SEP-22' AND (SELECT LAST_DAY ('01-SEP-22') FROM DUAL)
 --- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-OCT-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-OCT-22' AND (SELECT LAST_DAY ('01-OCT-22') FROM DUAL)
 --- AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-NOV-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit)
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-NOV-22' AND (SELECT LAST_DAY ('01-NOV-22') FROM DUAL)
---  AND (acc_id   = 1550)
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    )
  ----------------------------------------------------------------------
  UNION
  ----------------------------------------------------------------------
  SELECT TO_DATE (
    (SELECT LAST_DAY ('01-DEC-22') FROM DUAL
    )),
    particulars,
    SUM (debit) - SUM (credit) --change MON-YY
  FROM transaction_tables
  WHERE date_of_transaction BETWEEN '01-DEC-22' AND (SELECT LAST_DAY ('01-DEC-22') FROM DUAL)
 --- AND ( acc_id   = 1550) --change MON-YY as the same as SELEC line
  GROUP BY TO_DATE ('01-JAN-21'),
    acc_id,
    particulars --TO_DATE is same for each query to match data type only, no need to change
  HAVING acc_id IN
    (SELECT acc_id
    FROM accounts
    JOIN categories USING (c_id)
    WHERE c_id IN (100, 200, 600, 800, 1100, 1200, 1300)
    ) --DEC 2022/cashandcash_in_hand
    ----------------------------------------------------------------------
    --add more monthly query before order by, using UNION and change only MON and YY
    --copy a set of a query and change MON-YY, acc_id manually;
/
CREATE OR REPLACE VIEW bank_out AS
SELECT DISTINCT ab.acc_id, ab.particulars, dt.bank_name, ab.balanced from account_balanced ab, accounts ac, categories cat, chart_of_accounts coa, company_details comp, jobs jb, debit_tables dt
WHERE ac.acc_id = ab.acc_id AND  ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND jb.company_id = comp.company_id AND jb.job_id = dt.job_id
AND bank_name IS NOT NULL;
/
CREATE OR REPLACE VIEW bank_in AS
SELECT DISTINCT ab.acc_id, ab.particulars, dt.bank_name, ab.balanced from account_balanced ab, accounts ac, categories cat, chart_of_accounts coa, company_details comp, jobs jb, credit_tables dt
WHERE ac.acc_id = ab.acc_id AND  ac.c_id = cat.c_id AND cat.coa_id = coa.coa_id AND coa.company_id = comp.company_id AND jb.company_id = comp.company_id AND jb.job_id = dt.job_id
AND bank_name IS NOT NULL;
/

CREATE or replace VIEW income_statement AS
SELECT COMP.company_id, CAT.C_ID, ACC.ACC_ID, DATE_OF_TRANSACTION,TT.particulars, TT.debit, TT.credit 
FROM TRANSACTION_TABLES TT, ACCOUNTS ACC, CATEGORIES CAT, CHART_OF_ACCOUNTS COA, COMPANY_DETAILS COMP 
WHERE TT.acc_id=ACC.acc_id AND ACC.c_id=CAT.c_id AND COA.coa_id=CAT.coa_id AND COMP.company_id=COA.company_id AND CAT.c_id in (SELECT c_id FROM categories WHERE isid IS NOT NULL);
/

CREATE VIEW combine_table AS
SELECT dv_id id, date_of_transaction,narration,voucher_type,voucher_no,user_id,payment_mode,bank_name,bank_acc_no,cheque_no,cheque_date,credit_card_no,
debit_card_no,cardholder_name,job_id,pay_to as "Supplier/Customer",phone,address,email FROM debit_tables
UNION
SELECT cv_id, date_of_transaction,narration,voucher_type,voucher_no,user_id,payment_mode,bank_name,bank_acc_no,cheque_no,cheque_date,credit_card_no,
debit_card_no,cardholder_name,job_id,receive_from,phone,address,email FROM credit_tables
UNION
SELECT jv_id,date_of_transaction,narration,voucher_type,voucher_no,user_id,payment_mode,NULL,NULL,NULL,NULL,NULL,NULL,NULL,job_id,supplier_name,phone,address,email FROM journal_tables;
/

CREATE OR REPLACE VIEW DEBIT_BALANCE AS
SELECT dt.voucher_no, dt.dv_id, SUM(DEBIT) debit, SUM(CREDIT) credit FROM debit_tables dt, transaction_tables tt WHERE tt.dv_id=dt.dv_id GROUP BY dt.voucher_no, dt.dv_id;
/
CREATE or replace VIEW CREDIT_BALANCE AS
SELECT dt.voucher_no, dt.cv_id, SUM(DEBIT) debit, SUM(CREDIT) credit FROM credit_tables dt, transaction_tables tt WHERE tt.cv_id=dt.cv_id GROUP BY dt.voucher_no,dt.cv_id;
/
CREATE or replace VIEW JOURNAL_BALANCE AS
SELECT dt.voucher_no, dt.jv_id, SUM(DEBIT) debit, SUM(CREDIT) credit FROM journal_tables dt, transaction_tables tt WHERE tt.jv_id=dt.jv_id GROUP BY dt.voucher_no,dt.jv_id;
/

-----------------------------trigger
CREATE or replace TRIGGER filling_acc AFTER INSERT ON transaction_tables
DECLARE
v_accid number;
BEGIN
SELECT acc_id INTO v_accid FROM transaction_tables WHERE acc_id IS NULL FETCH FIRST 1 ROW ONLY;
IF v_accid IS NULL THEN
--dbms_output.put_line('FIRE TRIGGER');
DECLARE
CURSOR id_cursor IS
SELECT acc_id, particulars FROM accounts WHERE particulars IN (SELECT particulars FROM transaction_tables WHERE acc_id IS NULL);
v_acc transaction_tables.acc_id%TYPE;
v_particulars transaction_tables.particulars%TYPE;
BEGIN
OPEN id_cursor;
LOOP
FETCH id_cursor INTO v_acc,v_particulars;
EXIT WHEN id_cursor%NOTFOUND;
--DBMS_OUTPUT.PUT_LINE(v_particulars);
--DBMS_OUTPUT.PUT_LINE(v_acc);
UPDATE transaction_tables SET acc_id = v_acc WHERE particulars = v_particulars;
END LOOP;
CLOSE id_cursor;
END;
ELSE
--dbms_output.put_line('NO FIRE');
NULL;
END IF;
END;
/

COMMIT;


DISC;
CONN;
