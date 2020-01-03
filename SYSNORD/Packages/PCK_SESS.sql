CREATE OR REPLACE NONEDITIONABLE package sysnord.PCK_SESS is

  g_sess number;

  procedure p_createSession(p_emp number);
  
  function f_get_user_id(p_User_Name varchar2) return number;

end PCK_SESS;
/