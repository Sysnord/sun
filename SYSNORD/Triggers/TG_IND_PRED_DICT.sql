CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_IND_PRED_DICT 
                BEFORE
                insert  on sysnord.IND_PRED_DICT 
                for each row
                begin
                select sq_IND_PRED_DICT.nextval into :NEW.ID_PRED from dual;
                end;
/