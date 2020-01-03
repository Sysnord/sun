CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_markup_h is

  procedure del(p_id markup_h.ID_MARKUP%type);

  procedure set(p_row in out markup_h%rowtype);

  function get(p_id markup_h.ID_MARKUP%type) return markup_h%rowtype;

end pck_api_markup_h;
/