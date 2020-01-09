CREATE OR REPLACE NONEDITIONABLE package sysnord.PCK_MARKUP_TOOL is

  function f_end_markup(pr_provider_id markup_h.id_provider%type)
    return pck_a_types.t_result;

end PCK_MARKUP_TOOL;


 
/