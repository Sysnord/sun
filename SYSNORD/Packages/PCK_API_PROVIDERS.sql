CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_providers is

  procedure del(p_id providers.ID_PROVIDER%type);

  procedure set(p_row in out providers%rowtype);

  function get(p_id providers.ID_PROVIDER%type) return providers%rowtype;

end pck_api_providers;
/