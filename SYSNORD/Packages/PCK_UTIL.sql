CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_util is

  -- Author  : SYSNORD
  -- Created : 14.12.2019 19:39:04
  -- Purpose : 
  g_msg      varchar2(4000);
  g_err_msg  varchar2(4000);
  g_err_code varchar2(4000);

  function f_create_api(p_nm_tbl varchar2, p_init boolean default true)
    return pck_a_types.t_result;

  function f_drop_api(p_nm_tbl varchar2) return pck_a_types.t_result;

  procedure p_create_api_pck(p_nm_tbl varchar2);

  function get_query(pr_table        varchar2,
                     pr_column       varchar2,
                     pr_id           varchar2,
                     pr_id_is_number boolean default true,
                     pr_nm_dt_beg    varchar2,
                     pr_nm_dt_end    varchar2,
                     pr_dt           date) return clob;

  function check_dates(pr_table        varchar2,
                       pr_column       varchar2 default null,
                       pr_id           VARCHAR2,
                       pr_id_is_number boolean default true,
                       pr_nm_dt_beg    varchar2,
                       pr_nm_dt_end    varchar2,
                       pr_dt_beg       date,
                       pr_dt_end       date) return boolean;
end pck_util;
/