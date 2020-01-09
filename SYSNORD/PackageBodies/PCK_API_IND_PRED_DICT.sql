CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_api_ind_pred_dict is

  function add(p_row in out ind_pred_dict%rowtype)
    return ind_pred_dict.ID_PRED%type is
  begin    
    insert into ind_pred_dict
    values p_row
    returning ID_PRED into p_row.ID_PRED;
    return p_row.ID_PRED;
  end add;

  function edt(p_row in out ind_pred_dict%rowtype) return ind_pred_dict%rowtype is
  begin
    update ind_pred_dict d set d.id_pred          = p_row.id_pred,                      d.nm_pred          = p_row.nm_pred,                      d.passport_pic     = p_row.passport_pic,                      d.inn_pic          = p_row.inn_pic,                      d.svidetelstvo_pic = p_row.svidetelstvo_pic
     where d.ID_PRED = p_row.ID_PRED;
    return p_row;
  end edt;
  
  procedure del(p_id ind_pred_dict.ID_PRED%type) is
  begin
    delete from ind_pred_dict where ID_PRED = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id ind_pred_dict.ID_PRED%type) return ind_pred_dict%rowtype is
    v_row ind_pred_dict%rowtype;
  begin
    select * into v_row from ind_pred_dict where ID_PRED = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out ind_pred_dict%rowtype) is
  begin
    if p_row.ID_PRED is null then
      p_row.ID_PRED := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_ind_pred_dict;
/