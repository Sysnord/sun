CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_a_types is

  function f_l_res(p_code     number,
                   p_msg      varchar2,
                   p_ora_code varchar2 default null,
                   p_ora_msg  varchar2 default null)
    return pck_a_types.t_result is
    l_res pck_a_types.t_result;
  begin
    l_res.code     := p_code;
    l_res.msg      := p_msg;
    l_res.ora_code := p_ora_code;
    l_res.ora_msg  := p_ora_msg;
    return l_res;
  end f_l_res;

end pck_a_types;
/