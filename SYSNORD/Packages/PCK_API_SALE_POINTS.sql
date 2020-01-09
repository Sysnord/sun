CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_sale_points is

  procedure del(p_id sale_points.ID_POINT%type);

  procedure set(p_row in out sale_points%rowtype);

  function get(p_id sale_points.ID_POINT%type) return sale_points%rowtype;

end pck_api_sale_points;
/