CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_SALE_POINTS 
                BEFORE
                insert  on sysnord.SALE_POINTS 
                for each row
                begin
                select sq_SALE_POINTS.nextval into :NEW.ID_POINT from dual;
                end;
/