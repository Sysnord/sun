CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_user_account is

  function add(p_row in out user_account%rowtype)
    return user_account.ID%type is
  begin    
    insert into user_account
    values p_row
    returning ID into p_row.ID;
    return p_row.ID;
  end add;

  function edt(p_row in out user_account%rowtype) return user_account%rowtype is
  begin
    update user_account d set d.id        = p_row.id,                      d.user_name = p_row.user_name,                      d.password  = p_row.password,                      d.user_type = p_row.user_type,                      d.active    = p_row.active,                      d.email     = p_row.email,                      d.full_name = p_row.full_name
     where d.ID = p_row.ID;
    return p_row;
  end edt;
  
  procedure del(p_id user_account.ID%type) is
  begin
    delete from user_account where ID = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id user_account.ID%type) return user_account%rowtype is
    v_row user_account%rowtype;
  begin
    select * into v_row from user_account where ID = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out user_account%rowtype) is
  begin
    if p_row.ID is null then
      p_row.ID := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_user_account;
/