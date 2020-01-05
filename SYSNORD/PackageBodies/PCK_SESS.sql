CREATE OR REPLACE NONEDITIONABLE package body sysnord.PCK_SESS is

  procedure p_createSession(p_emp number) is
  begin
    PCK_SESS.g_sess := p_emp;
  end p_createSession;
  
  function f_get_user_id(p_User_Name varchar2) return number is
    l_usr_id number;
  begin
    select u.id
      into l_usr_id
      from user_account u
     where lower(u.user_name) = lower(p_User_Name);
     return l_usr_id;
  end f_get_user_id;
end PCK_SESS;
/