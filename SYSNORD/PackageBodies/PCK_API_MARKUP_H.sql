CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_markup_h is

  function add(p_row in out markup_h%rowtype)
    return markup_h.ID_MARKUP%type is
  begin    
    insert into markup_h
    values p_row
    returning ID_MARKUP into p_row.ID_MARKUP;
    return p_row.ID_MARKUP;
  end add;

  function edt(p_row in out markup_h%rowtype) return markup_h%rowtype is
  begin
    update markup_h d set d.id_markup   = p_row.id_markup,                      d.id_provider = p_row.id_provider,                      d.markup      = p_row.markup,                      d.dt_st       = p_row.dt_st,                      d.dt_end      = p_row.dt_end,                      d.is_active   = p_row.is_active
     where d.ID_MARKUP = p_row.ID_MARKUP;
    return p_row;
  end edt;
  
  procedure del(p_id markup_h.ID_MARKUP%type) is
  begin
    delete from markup_h where ID_MARKUP = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id markup_h.ID_MARKUP%type) return markup_h%rowtype is
    v_row markup_h%rowtype;
  begin
    select * into v_row from markup_h where ID_MARKUP = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out markup_h%rowtype) is
  begin
    if p_row.ID_MARKUP is null then
      p_row.ID_MARKUP := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_markup_h;
/