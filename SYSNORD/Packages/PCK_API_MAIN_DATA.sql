CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_main_data is

  procedure del(p_id main_data.ID_DATA%type);

  procedure set(p_row in out main_data%rowtype);

  function get(p_id main_data.ID_DATA%type) return main_data%rowtype;

end pck_api_main_data;
/