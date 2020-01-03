CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_test is

  function add(p_row in out test%rowtype)
    return test.ID%type is
  begin
    p_row.sys_dt_ins:= sysdate;
    p_row.sys_emp_ins := pck_sess.g_sess;
    p_row.sys_dt_upd:=sysdate;
    p_row.sys_emp_upd:= pck_sess.g_sess;
    
    insert into test
    values p_row
    returning ID into p_row.ID;
    return p_row.ID;
  end add;

  function edt(p_row in out test%rowtype) return test%rowtype is
  begin
    update test d set d.id          = p_row.id,
                      d.nm          = p_row.nm,
                      d.sys_dt_ins  = p_row.sys_dt_ins,
                      d.sys_emp_ins = p_row.sys_emp_ins,
                      d.sys_dt_upd  = sysdate,
                      d.sys_emp_upd = PCK_SESS.g_sess
     where d.ID = p_row.ID;
    return p_row;
  end edt;
  
  procedure del(p_id test.ID%type) is
  begin
    delete from test where ID = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id test.ID%type) return test%rowtype is
    v_row test%rowtype;
  begin
    select * into v_row from test where ID = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out test%rowtype) is
  begin
    if p_row.ID is null then
      p_row.ID := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_test;
/