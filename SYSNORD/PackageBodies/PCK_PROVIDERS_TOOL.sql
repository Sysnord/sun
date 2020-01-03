CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_providers_tool is

  function f_get_info_id_by_prov(pr_id providers.id_provider%type)
    return providers_info.id_pr_info%type is
    l_id number;
  begin
    select pi.id_pr_info
      into l_id
      from providers_info pi
     where pi.id_provider = pr_id;
    return l_id;
  exception
    when no_data_found then
      return null;
  end f_get_info_id_by_prov;

  procedure p_del_markup_id_by_prov(pr_id providers.id_provider%type) is
  begin
    for x in (select h.id_markup from markup_h h where h.id_provider = pr_id) loop
      pck_api_markup_h.del(p_id => x.id_markup);
    end loop;
  exception
    when no_data_found then
      null;
  end p_del_markup_id_by_prov;

  function f_del_soft(pr_id providers.id_provider%type)
    return pck_a_types.t_result is
    l_pi_id number;
    l_res   pck_a_types.t_result;
  begin
    --Ищем инфо по поставщику
    l_pi_id := f_get_info_id_by_prov(pr_id => pr_id);
    --Удаляем инфо
    pck_api_providers_info.del(p_id => l_pi_id);
    --Ищем наценки поставщика и удаляем их
    p_del_markup_id_by_prov(pr_id => pr_id);
    --Удаляем поставщика
    pck_api_providers.del(p_id => pr_id);
    --delete from providers where ID_PROVIDER = pr_id;
    l_res := pck_a_types.f_l_res(p_msg  => 'Поставщик удален',
                                 p_code => 1);
    return l_res;
  exception
    when others then
      pck_log.p_ins(p_va1 => 'id provider ' || pr_id,
                    p_nm  => 'Ошибка при удалении поставщика ' || sqlerrm);
      rollback;
      apex_error.add_error(p_message          => 'Ошибка при удалении поставщика',
                           p_display_location => apex_error.c_inline_in_notification);
      l_res := pck_a_types.f_l_res(p_msg  => 'Ошибка при удалении поставщика. ' ||
                                             sqlerrm,
                                   p_code => -1);
      return l_res;
  end f_del_soft;

  procedure p_provider_upd(pr_prov_id   providers.id_provider%type,
                           pr_nm        providers.nm_provider%type,
                           pr_parent_id providers.id_parent%type,
                           pr_phone     providers_info.phone%type,
                           pr_descr     providers_info.descr%type) is
    l_prov_rw      providers%rowtype;
    l_prov_info_rw providers_info%rowtype;
    l_prov_info_id providers_info.id_pr_info%type;
  begin
    l_prov_rw             := pck_api_providers.get(p_id => pr_prov_id);
    l_prov_rw.nm_provider := pr_nm;
    l_prov_rw.id_parent   := pr_parent_id;
    l_prov_info_id        := f_get_info_id_by_prov(pr_id => pr_prov_id);
    if l_prov_info_id is not null then
      l_prov_info_rw := pck_api_providers_info.get(p_id => l_prov_info_id);
    else
      l_prov_info_rw.id_provider := pr_prov_id;
    end if;
    l_prov_info_rw.phone := pr_phone;
    l_prov_info_rw.descr := pr_descr;
    pck_api_providers.set(p_row => l_prov_rw);
    pck_api_providers_info.set(p_row => l_prov_info_rw);
  exception
    when others then
      apex_error.add_error(p_message          => 'Ошибка при изменении поставщика',
                           p_display_location => apex_error.c_inline_in_notification);
  end p_provider_upd;
end pck_providers_tool;
/