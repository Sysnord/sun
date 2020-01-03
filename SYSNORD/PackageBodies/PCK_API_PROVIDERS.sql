CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_providers is

  function add(p_row in out providers%rowtype)
    return providers.ID_PROVIDER%type is
  begin    
    insert into providers
    values p_row
    returning ID_PROVIDER into p_row.ID_PROVIDER;
    return p_row.ID_PROVIDER;
  end add;

  function edt(p_row in out providers%rowtype) return providers%rowtype is
  begin
    update providers d set d.id_provider = p_row.id_provider,                      d.nm_provider = p_row.nm_provider,                      d.id_parent   = p_row.id_parent,                      d.is_active   = p_row.is_active
     where d.ID_PROVIDER = p_row.ID_PROVIDER;
    return p_row;
  end edt;
  
  procedure del(p_id providers.ID_PROVIDER%type) is
  begin
    delete from providers where ID_PROVIDER = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id providers.ID_PROVIDER%type) return providers%rowtype is
    v_row providers%rowtype;
  begin
    select * into v_row from providers where ID_PROVIDER = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out providers%rowtype) is
  begin
    if p_row.ID_PROVIDER is null then
      p_row.ID_PROVIDER := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_providers;
/