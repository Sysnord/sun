CREATE OR REPLACE NONEDITIONABLE TRIGGER sysnord.TG_SALE_POINTS_USER
                BEFORE insert or update or delete on sysnord.SALE_POINTS
                for each row
              begin
                if pck_sess.g_sess is null then
                  pck_sess.p_createSession(p_emp => pck_sess.f_get_user_id(v('APP_USER')));
                end if;
                if INSERTING then
                  :new.sys_dt_ins  := sysdate;
                  :new.sys_emp_ins := pck_sess.g_sess;
                  :new.sys_dt_upd  := sysdate;
                  :new.sys_emp_upd := pck_sess.g_sess;
                end if;
                if UPDATING then
                  :new.sys_dt_upd  := sysdate;
                  :new.sys_emp_upd := pck_sess.g_sess;
                end if;
              end;
/