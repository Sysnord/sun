CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_ind_pred_dict is

  procedure del(p_id ind_pred_dict.ID_PRED%type);

  procedure set(p_row in out ind_pred_dict%rowtype);

  function get(p_id ind_pred_dict.ID_PRED%type) return ind_pred_dict%rowtype;

end pck_api_ind_pred_dict;
/