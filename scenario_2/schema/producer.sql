DROP TABLE prod_item_type CASCADE CONSTRAINTS;
DROP TABLE prod_item_state CASCADE CONSTRAINTS;
DROP TABLE prod_item CASCADE CONSTRAINTS;
DROP TABLE prod_item_name_local CASCADE CONSTRAINTS;
DROP TABLE prod_product_name_list CASCADE CONSTRAINTS;
DROP SEQUENCE prod_item_type_id_seq;
DROP SEQUENCE prod_item_state_id_seq;
DROP SEQUENCE prod_item_name_local_id_seq;
DROP SEQUENCE prod_product_name_list_id_seq;
DROP SEQUENCE prod_item_id_seq;

CREATE TABLE PROD_ITEM_TYPE (
  item_type_id NUMBER,
  name         VARCHAR2(100),
  PRIMARY KEY (item_type_id)
);

CREATE TABLE PROD_ITEM_STATE (
  item_state_id NUMBER,
  name          VARCHAR2(100),
  PRIMARY KEY (item_state_id)
);

CREATE TABLE PROD_ITEM (
  item_id       NUMBER(8,0) NOT NULL,
  item_no       NUMBER(8,0),
  item_type_id  NUMBER(8,0),
  item_state_id NUMBER(8,0),
  register_date DATE,
  update_date   DATE,
  delete_date   DATE NULL,
  creation_date DATE,
  modified      TIMESTAMP(0) NOT NULL,
  PRIMARY KEY (item_id),
  CONSTRAINT item_type_fk
  FOREIGN KEY (item_type_id) REFERENCES PROD_ITEM_TYPE (item_type_id),
  CONSTRAINT item_state_fk
  FOREIGN KEY (item_state_id) REFERENCES PROD_ITEM_STATE (item_state_id)
);

CREATE TABLE PROD_ITEM_NAME_LOCAL (
  item_name_local_id      NUMBER,
  item_id                 NUMBER,
  item_name               VARCHAR2(1000),
  presentation_group_code VARCHAR2(1000) NULL,
  item_measurement_system VARCHAR2(1000),
  register_date           DATE,
  update_date             DATE,
  delete_date             DATE NULL,
  PRIMARY KEY (item_name_local_id),
  CONSTRAINT item_fk
  FOREIGN KEY (item_id) REFERENCES PROD_ITEM (item_id)
);

CREATE TABLE PROD_PRODUCT_NAME_LIST (
  product_name_list_id  NUMBER,
  item_id               NUMBER,
  product_name_no       NUMBER,
  product_name_en       VARCHAR2(1000),
  product_name_short_en VARCHAR2(1000) NULL,
  sort_no               VARCHAR2(1000),
  register_date         DATE,
  update_date           DATE,
  delete_date           DATE NULL,
  PRIMARY KEY (product_name_list_id),
  CONSTRAINT product_name_item_fk
  FOREIGN KEY (item_id) REFERENCES PROD_ITEM (item_id)
);

CREATE SEQUENCE prod_item_type_id_seq
  MINVALUE 0
  MAXVALUE 999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE prod_item_state_id_seq
  MINVALUE 0
  MAXVALUE 999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE prod_item_name_local_id_seq
  MINVALUE 0
  MAXVALUE 999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE prod_product_name_list_id_seq
  MINVALUE 0
  MAXVALUE 999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE prod_item_id_seq
  MINVALUE 0
  MAXVALUE 999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  NOCYCLE;