CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_log is

  -- Author  : SYSNORD
  -- Created : 14-Dec-19 6:33:53 PM
  -- Purpose :

  procedure p_ins(p_va1     varchar2,
                  p_nm      varchar2 default null,
                  p_clb_val clob default null);

end pck_log;
/