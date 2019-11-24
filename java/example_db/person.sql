--sqlplus SYSTEM/monday1@localhost:1521
--select banner from v$version where rownum = 1;

create table person (
  person_id NUMBER,
  first_name VARCHAR2(10)
  CONSTRAINT person_pk PRIMARY KEY (person_id)
);

CREATE SEQUENCE person_id_seq START WITH 1001;

CREATE OR REPLACE TRIGGER person_tr
BEFORE INSERT ON person
FOR EACH ROW

BEGIN
  SELECT person_id_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;


CREATE TABLE customers (
  customer_id number(10) NOT NULL,
  customer_name varchar2(50) NOT NULL,
  city varchar2(50),
  CONSTRAINT customers_pk PRIMARY KEY (customer_id)
);

CREATE TABLE persons(
    person_Id NUMBER(19,0) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
);

    person_id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    PRIMARY KEY(person_id)

CREATE TABLE AUTH_PERMISSION
(
  ID NUMBER(19,0) GENERATED BY DEFAULT ON NULL AS IDENTITY,
  -- ID NUMBER(19,0) PRIMARY KEY NOT NULL,
  NAME VARCHAR2(50) UNIQUE NOT NULL,
  ACTION_ID NUMBER(19,0) NOT NULL,
  RESOURCE_ID NUMBER(19,0) NOT NULL,
  ENVIRONMENT_ID NUMBER(19,0) NOT NULL
);
