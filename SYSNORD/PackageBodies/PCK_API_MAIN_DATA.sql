CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_main_data is

  function add(p_row in out main_data%rowtype)
    return main_data.ID_DATA%type is
  begin    
    insert into main_data
    values p_row
    returning ID_DATA into p_row.ID_DATA;
    return p_row.ID_DATA;
  end add;

  function edt(p_row in out main_data%rowtype) return main_data%rowtype is
  begin
    update main_data d set d.id_data     = p_row.id_data,
     where d.ID_DATA = p_row.ID_DATA;
    return p_row;
  end edt;
  
  procedure del(p_id main_data.ID_DATA%type) is
  begin
    delete from main_data where ID_DATA = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id main_data.ID_DATA%type) return main_data%rowtype is
    v_row main_data%rowtype;
  begin
    select * into v_row from main_data where ID_DATA = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out main_data%rowtype) is
  begin
    if p_row.ID_DATA is null then
      p_row.ID_DATA := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_main_data;
/