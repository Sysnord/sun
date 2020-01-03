CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.tg_ilog_bir
BEFORE
insert  on sysnord.ilog
for each row
begin
select sq_ilog.nextval into :NEW.ID from dual;
end;
/