DROP TABLE cons_item;
DROP SEQUENCE cons_item_id_seq;

CREATE TABLE CONS_ITEM (
  item_id                      NUMBER,
  source_item_id               NUMBER,
  item_no                      NUMBER,
  item_type_name               NUMBER,
  item_state_name              NUMBER,
  register_date                DATE,
  update_date                  DATE,
  delete_date                  DATE NULL,
  pinl_item_name_local_id      NUMBER,
  pinl_item_name               VARCHAR2(1000),
  pinl_presentation_group_code VARCHAR2(1000) NULL,
  pinl_item_measurement_system VARCHAR2(1000),
  pinl_register_date           DATE,
  pinl_update_date             DATE,
  pinl_delete_date             DATE NULL,
  ppnlproduct_name_list_id     NUMBER,
  ppnl_product_name_no         NUMBER,
  ppnl_product_name_en         VARCHAR2(1000),
  ppnl_product_name_short_en   VARCHAR2(1000) NULL,
  ppnl_sort_no                 VARCHAR2(1000),
  ppnl_register_date           DATE,
  ppnl_update_date             DATE,
  ppnl_delete_date             DATE NULL,
  creation_date                DATE,
  source_creation_date         DATE,
  PRIMARY KEY (item_id)
);

CREATE SEQUENCE cons_item_id_seq
  MINVALUE 0
  MAXVALUE 999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  NOCYCLE;