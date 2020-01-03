CREATE OR REPLACE NONEDITIONABLE package sysnord.pck_api_test is

  procedure del(p_id test.ID%type);

  procedure set(p_row in out test%rowtype);

  function get(p_id test.ID%type) return test%rowtype;

end pck_api_test;
/