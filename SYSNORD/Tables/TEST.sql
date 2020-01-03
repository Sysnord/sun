CREATE TABLE sysnord."TEST" (
  "ID" NUMBER NOT NULL,
  nm VARCHAR2(100 BYTE),
  sys_dt_ins DATE NOT NULL,
  sys_emp_ins NUMBER NOT NULL,
  sys_dt_upd DATE NOT NULL,
  sys_emp_upd NUMBER NOT NULL,
  CONSTRAINT pk_test PRIMARY KEY ("ID")
);