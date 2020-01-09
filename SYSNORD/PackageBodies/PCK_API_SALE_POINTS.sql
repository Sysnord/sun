CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_sale_points is

  function add(p_row in out sale_points%rowtype)
    return sale_points.ID_POINT%type is
  begin    
    insert into sale_points
    values p_row
    returning ID_POINT into p_row.ID_POINT;
    return p_row.ID_POINT;
  end add;

  function edt(p_row in out sale_points%rowtype) return sale_points%rowtype is
  begin
    update sale_points d set d.id_point = p_row.id_point,                      d.nm_point = p_row.nm_point,                      d.id_pred  = p_row.id_pred
     where d.ID_POINT = p_row.ID_POINT;
    return p_row;
  end edt;
  
  procedure del(p_id sale_points.ID_POINT%type) is
  begin
    delete from sale_points where ID_POINT = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id sale_points.ID_POINT%type) return sale_points%rowtype is
    v_row sale_points%rowtype;
  begin
    select * into v_row from sale_points where ID_POINT = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out sale_points%rowtype) is
  begin
    if p_row.ID_POINT is null then
      p_row.ID_POINT := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_sale_points;
/