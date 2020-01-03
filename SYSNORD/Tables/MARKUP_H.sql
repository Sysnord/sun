CREATE TABLE sysnord.markup_h (
  id_markup NUMBER NOT NULL,
  id_provider NUMBER,
  markup NUMBER,
  dt_st DATE,
  dt_end DATE,
  is_active NUMBER,
  sys_dt_ins DATE NOT NULL,
  sys_emp_ins NUMBER NOT NULL,
  sys_dt_upd DATE NOT NULL,
  sys_emp_upd NUMBER NOT NULL,
  CONSTRAINT pk_markup_h PRIMARY KEY (id_markup),
  CONSTRAINT fk_markup_h_1 FOREIGN KEY (id_provider) REFERENCES sysnord.providers (id_provider)
);