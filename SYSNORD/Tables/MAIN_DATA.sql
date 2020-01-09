CREATE TABLE sysnord.main_data (
  id_data NUMBER NOT NULL,
  nn_naklad VARCHAR2(100 BYTE),
  nn_sum_nakl NUMBER,
  dt_nakl DATE,
  nn_return NUMBER,
  nm_descr VARCHAR2(500 BYTE),
  id_point NUMBER,
  id_markup NUMBER,
  id_provider NUMBER,
  sys_dt_ins DATE NOT NULL,
  sys_emp_ins NUMBER NOT NULL,
  sys_dt_upd DATE NOT NULL,
  sys_emp_upd NUMBER NOT NULL,
  CONSTRAINT pk_main_data PRIMARY KEY (id_data),
  CONSTRAINT fk_main_data_1 FOREIGN KEY (id_provider) REFERENCES sysnord.providers (id_provider),
  CONSTRAINT fk_main_data_2 FOREIGN KEY (id_point) REFERENCES sysnord.sale_points (id_point),
  CONSTRAINT fk_main_data_3 FOREIGN KEY (id_markup) REFERENCES sysnord.markup_h (id_markup)
);