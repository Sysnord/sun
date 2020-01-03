CREATE TABLE sysnord.providers (
  id_provider NUMBER NOT NULL,
  nm_provider VARCHAR2(200 CHAR),
  id_parent NUMBER,
  is_active NUMBER,
  sys_dt_ins DATE NOT NULL,
  sys_emp_ins NUMBER NOT NULL,
  sys_dt_upd DATE NOT NULL,
  sys_emp_upd NUMBER NOT NULL,
  CONSTRAINT pk_provider PRIMARY KEY (id_provider)
);
COMMENT ON TABLE sysnord.providers IS 'Поставщики';
COMMENT ON COLUMN sysnord.providers.nm_provider IS 'Наименование поставщика';
COMMENT ON COLUMN sysnord.providers.id_parent IS 'Родитель';
COMMENT ON COLUMN sysnord.providers.is_active IS 'активный (1 активный/2 не активный)';