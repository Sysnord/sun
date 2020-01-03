CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_log is

  procedure p_ins(p_va1     varchar2,
                  p_nm      varchar2 default null,
                  p_clb_val clob default null) is
    pragma autonomous_transaction;
  begin
    if p_va1 is not null then
      insert into ilog
        (val, nm, clb, dt)
      values
        (p_va1, p_nm, p_clb_val, sysdate);
    end if;
    commit;
  end p_ins;

end pck_log;
/