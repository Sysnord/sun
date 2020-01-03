CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_test 
                BEFORE
                insert  on sysnord.test 
                for each row
                begin
                select sq_test.nextval into :NEW.ID from dual;
                end;
/