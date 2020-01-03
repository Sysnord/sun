CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_providers_info is

  function add(p_row in out providers_info%rowtype)
    return providers_info.ID_PR_INFO%type is
  begin    
    insert into providers_info
    values p_row
    returning ID_PR_INFO into p_row.ID_PR_INFO;
    return p_row.ID_PR_INFO;
  end add;

  function edt(p_row in out providers_info%rowtype) return providers_info%rowtype is
  begin
    update providers_info d set d.id_pr_info  = p_row.id_pr_info,                      d.id_provider = p_row.id_provider,                      d.phone       = p_row.phone,                      d.descr       = p_row.descr
     where d.ID_PR_INFO = p_row.ID_PR_INFO;
    return p_row;
  end edt;
  
  procedure del(p_id providers_info.ID_PR_INFO%type) is
  begin
    delete from providers_info where ID_PR_INFO = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id providers_info.ID_PR_INFO%type) return providers_info%rowtype is
    v_row providers_info%rowtype;
  begin
    select * into v_row from providers_info where ID_PR_INFO = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out providers_info%rowtype) is
  begin
    if p_row.ID_PR_INFO is null then
      p_row.ID_PR_INFO := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_providers_info;
/