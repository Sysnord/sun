CREATE TABLE sysnord.providers_info (
  id_pr_info NUMBER NOT NULL,
  id_provider NUMBER,
  phone VARCHAR2(50 BYTE),
  descr VARCHAR2(200 CHAR),
  sys_dt_ins DATE NOT NULL,
  sys_emp_ins NUMBER NOT NULL,
  sys_dt_upd DATE NOT NULL,
  sys_emp_upd NUMBER NOT NULL,
  CONSTRAINT pk_providers_info PRIMARY KEY (id_pr_info),
  CONSTRAINT fk_providers_info_1 FOREIGN KEY (id_provider) REFERENCES sysnord.providers (id_provider)
);