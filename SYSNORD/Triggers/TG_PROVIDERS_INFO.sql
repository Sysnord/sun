CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_PROVIDERS_INFO 
                BEFORE
                insert  on sysnord.PROVIDERS_INFO 
                for each row
                begin
                select sq_PROVIDERS_INFO.nextval into :NEW.ID_PR_INFO from dual;
                end;
/