CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_providers_info is

  procedure del(p_id providers_info.ID_PR_INFO%type);

  procedure set(p_row in out providers_info%rowtype);

  function get(p_id providers_info.ID_PR_INFO%type) return providers_info%rowtype;

end pck_api_providers_info;
/