CREATE OR REPLACE NONEDITIONABLE package body sysnord.PCK_MARKUP_TOOL is

  function f_end_markup(pr_provider_id markup_h.id_provider%type)
    return pck_a_types.t_result is
    l_markup_rw markup_h%rowtype;
    l_res       pck_a_types.t_result;
  begin    
    for x in (select m.id_markup
                from markup_h m
               where m.id_provider = pr_provider_id
                 and m.is_active = 1) loop                
      l_markup_rw           := pck_api_markup_h.get(p_id => x.id_markup);
      l_markup_rw.is_active := 0;
      l_markup_rw.dt_end    := trunc(sysdate);
      pck_api_markup_h.set(l_markup_rw);
    end loop;
    l_res := pck_a_types.f_l_res(p_code => 1,
                                 p_msg  => 'Изменение произведено успешно');
    return l_res;
  exception
    when others then
      l_res := pck_a_types.f_l_res(p_code     => -1,
                                   p_msg      => 'Ошибка при изменении',
                                   p_ora_code => sqlcode,
                                   p_ora_msg  => sqlerrm);
      return l_res;
  end f_end_markup;

end PCK_MARKUP_TOOL;
/