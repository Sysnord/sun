CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_MARKUP_H 
                BEFORE
                insert  on sysnord.MARKUP_H 
                for each row
                begin
                select sq_MARKUP_H.nextval into :NEW.ID_MARKUP from dual;
                end;
/