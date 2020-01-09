CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_MAIN_DATA 
                BEFORE
                insert  on sysnord.MAIN_DATA 
                for each row
                begin
                select sq_MAIN_DATA.nextval into :NEW.ID_DATA from dual;
                end;
/