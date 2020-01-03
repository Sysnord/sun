CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_USER_ACCOUNT 
                BEFORE
                insert  on sysnord.USER_ACCOUNT 
                for each row
                begin
                select sq_USER_ACCOUNT.nextval into :NEW.ID from dual;
                end;
/