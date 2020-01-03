CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_providers_tool is

  function f_get_info_id_by_prov(pr_id providers.id_provider%type)
    return providers_info.id_pr_info%type;

  procedure p_del_markup_id_by_prov(pr_id providers.id_provider%type);

  function f_del_soft(pr_id providers.id_provider%type)
    return pck_a_types.t_result;

  procedure p_provider_upd(pr_prov_id   providers.id_provider%type,
                           pr_nm        providers.nm_provider%type,
                           pr_parent_id providers.id_parent%type,
                           pr_phone     providers_info.phone%type,
                           pr_descr     providers_info.descr%type);
end pck_providers_tool;
/