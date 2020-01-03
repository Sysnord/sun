CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_user_account is

  procedure del(p_id user_account.ID%type);

  procedure set(p_row in out user_account%rowtype);

  function get(p_id user_account.ID%type) return user_account%rowtype;

end pck_api_user_account;
/