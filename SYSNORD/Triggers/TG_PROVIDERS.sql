CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_PROVIDERS 
                BEFORE
                insert  on sysnord.PROVIDERS 
                for each row
                begin
                select sq_PROVIDERS.nextval into :NEW.ID_PROVIDER from dual;
                end;
/