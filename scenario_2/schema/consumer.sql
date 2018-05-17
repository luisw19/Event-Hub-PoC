DROP TABLE cons_item;
DROP SEQUENCE cons_item_id_seq;

CREATE TABLE CONS_ITEM (
  cons_item_id                 NUMBER,
  source_item_id               NUMBER,
  item_no                      NUMBER,
  item_type_id                 NUMBER,
  item_state_id                NUMBER,
  register_date                DATE,
  update_date                  DATE,
  delete_date                  DATE,
  modified                     TIMESTAMP(0),
  source_creation_date         DATE,
  sink_receive_date            DATE,
  sink_creation_date           DATE,
  PRIMARY KEY (cons_item_id)
);

CREATE SEQUENCE cons_item_id_seq
  MINVALUE 0
  MAXVALUE 999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  NOCYCLE;