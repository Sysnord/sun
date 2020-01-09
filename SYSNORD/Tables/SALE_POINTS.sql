CREATE TABLE sysnord.sale_points (
  id_point NUMBER NOT NULL,
  nm_point VARCHAR2(200 BYTE),
  id_pred NUMBER,
  sys_dt_ins DATE NOT NULL,
  sys_emp_ins NUMBER NOT NULL,
  sys_dt_upd DATE NOT NULL,
  sys_emp_upd NUMBER NOT NULL,
  CONSTRAINT pk_sale_points PRIMARY KEY (id_point),
  CONSTRAINT fk_sale_point_1 FOREIGN KEY (id_pred) REFERENCES sysnord.ind_pred_dict (id_pred)
);