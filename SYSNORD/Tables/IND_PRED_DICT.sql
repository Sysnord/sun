CREATE TABLE sysnord.ind_pred_dict (
  id_pred NUMBER NOT NULL,
  nm_pred VARCHAR2(200 BYTE),
  passport_pic BLOB,
  inn_pic BLOB,
  svidetelstvo_pic BLOB,
  sys_dt_ins DATE NOT NULL,
  sys_emp_ins NUMBER NOT NULL,
  sys_dt_upd DATE NOT NULL,
  sys_emp_upd NUMBER NOT NULL,
  CONSTRAINT pk_ind_pred_dict PRIMARY KEY (id_pred)
);