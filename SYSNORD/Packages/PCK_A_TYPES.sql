CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_a_types is

  -- Author  : SYSNORD
  -- Created : 14.12.2019 19:42:22
  -- Purpose : 

  type t_result is record(
    code     number,
    msg      varchar2(4000),
    ora_code number,
    ora_msg  varchar2(4000));

  function f_l_res(p_code     number,
                   p_msg      varchar2,
                   p_ora_code varchar2 default null,
                   p_ora_msg  varchar2 default null)
    return pck_a_types.t_result;

end pck_a_types;
/