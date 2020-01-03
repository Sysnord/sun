CREATE OR REPLACE NONEDITIONABLE package body sysnord.pck_util is

  function f_check_tbl(p_nm_tbl varchar2) return boolean is
    l_tbl_nm number;
  begin
    select count(t.TABLE_NAME)
      into l_tbl_nm
      from all_tables t
     where t.TABLE_NAME = upper(p_nm_tbl);
    return l_tbl_nm = 1;
  end f_check_tbl;

  procedure p_create_sq(p_nm_tbl varchar2) is
    l_stmnt clob;
    sq_ex exception;
  begin
    l_stmnt := 'create sequence SQ_' || p_nm_tbl || ' 
                minvalue 1
                maxvalue 9999999999999999999999999999
                start with 1
                increment by 1
                nocache';
    EXECUTE immediate l_stmnt;
  exception
    when others then
      g_err_msg  := sqlerrm;
      g_err_code := sqlcode;
      g_msg      := 'Ошибка при генерации SQ';
      raise sq_ex;
  end p_create_sq;

  function f_get_pk(p_tbl_nm varchar2)
    return USER_CONS_COLUMNS.COLUMN_NAME%type is
    l_pk USER_CONS_COLUMNS.COLUMN_NAME%type;
  begin
    SELECT ucc.COLUMN_NAME
      into l_pk
      FROM USER_CONS_COLUMNS ucc
     WHERE TABLE_NAME = upper(p_tbl_nm)
       and ucc.CONSTRAINT_NAME like 'PK_%';
    return l_pk;
  end f_get_pk;

  procedure p_create_tg_bir(p_nm_tbl varchar2) is
    l_stmnt clob;
    tg_ex exception;
    l_pk USER_CONS_COLUMNS.COLUMN_NAME%type;
  begin
    l_pk    := f_get_pk(p_nm_tbl);
    l_stmnt := 'CREATE OR REPLACE NONEDITIONABLE TRIGGER TG_' ||
               upper(p_nm_tbl) || ' 
                BEFORE
                insert  on ' || upper(p_nm_tbl) || ' 
                for each row
                begin
                select sq_' || upper(p_nm_tbl) ||
               '.nextval into :NEW.' || l_pk || ' from dual;
                end;';
    EXECUTE immediate l_stmnt;
  exception
    when others then
      g_err_msg  := sqlerrm;
      g_err_code := sqlcode;
      g_msg      := 'Ошибка при генерации TG bir';
      raise tg_ex;
  end p_create_tg_bir;

  procedure p_create_tg_user(p_nm_tbl varchar2) is
    l_stmnt clob;
    tg_ex exception;
  begin
    l_stmnt := 'CREATE OR REPLACE NONEDITIONABLE TRIGGER TG_' ||
               upper(p_nm_tbl) ||
               '_USER
                BEFORE insert or update or delete on ' ||
               upper(p_nm_tbl) || '
                for each row
              begin
                if pck_sess.g_sess is null then
                  pck_sess.p_createSession(p_emp => pck_sess.f_get_user_id(v(''APP_USER'')));
                end if;
                if INSERTING then
                  :new.sys_dt_ins  := sysdate;
                  :new.sys_emp_ins := pck_sess.g_sess;
                  :new.sys_dt_upd  := sysdate;
                  :new.sys_emp_upd := pck_sess.g_sess;
                end if;
                if UPDATING then
                  :new.sys_dt_upd  := sysdate;
                  :new.sys_emp_upd := pck_sess.g_sess;
                end if;
              end;';
    EXECUTE immediate l_stmnt;
  exception
    when others then
      g_err_msg  := sqlerrm;
      g_err_code := sqlcode;
      g_msg      := 'Ошибка при генерации TG user';
      raise tg_ex;
  end p_create_tg_user;

  procedure p_create_api_pck(p_nm_tbl varchar2) is
    l_pk      USER_CONS_COLUMNS.COLUMN_NAME%type;
    l_stmnt   clob;
    l_upd_str clob;
    function f_upd_str(p_tbl_nm varchar2) return clob is
      l_out      clob;
      l_cnt      number := 1;
      l_cnt_rows number;
    begin
      select count(*)
        into l_cnt_rows
        FROM USER_TAB_COLUMNS u
       WHERE table_name = upper(p_tbl_nm)
         and u.COLUMN_NAME not in
             (upper('sys_dt_ins'),
              upper('sys_emp_ins'),
              upper('sys_dt_upd'),
              upper('sys_emp_upd'));
    
      for x in (select rpad(nm, mx, ' ') || ' = p_row.' || lower(nms) as nm_frm
                  from (SELECT 'd.' || lower(column_name) as nm,
                               lower(column_name) as nms,
                               length('d.' || lower(column_name)) as lngt,
                               max(length(u.COLUMN_NAME)) over(partition by u.TABLE_NAME) + 2 as mx
                          FROM USER_TAB_COLUMNS u
                         WHERE table_name = upper(p_tbl_nm)
                           and u.COLUMN_NAME not in
                               (upper('sys_dt_ins'),
                                upper('sys_emp_ins'),
                                upper('sys_dt_upd'),
                                upper('sys_emp_upd'))
                         order by u.COLUMN_ID)) loop
        if l_cnt = 1 then
          l_out := 'set ' || x.nm_frm || ',';
          l_cnt := l_cnt + 1;
          continue;
        end if;
        l_out := l_out || chr(13) || '                      ' || x.nm_frm || case
                   when l_cnt = l_cnt_rows then
                    ''
                   else
                    ','
                 end;
        l_cnt := l_cnt + 1;
      end loop;
      return l_out;
    end f_upd_str;
  begin
    l_pk      := f_get_pk(p_nm_tbl);
    l_upd_str := f_upd_str(p_nm_tbl);
    l_stmnt   := 'create or replace package pck_api_' || p_nm_tbl || ' is

  procedure del(p_id ' || p_nm_tbl || '.' || l_pk ||
                 '%type);

  procedure set(p_row in out ' || p_nm_tbl ||
                 '%rowtype);

  function get(p_id ' || p_nm_tbl || '.' || l_pk ||
                 '%type) return ' || p_nm_tbl || '%rowtype;

end pck_api_' || p_nm_tbl || ';';
    execute immediate l_stmnt;
    l_stmnt := 'create or replace package body  pck_api_' || p_nm_tbl || ' is

  function add(p_row in out ' || p_nm_tbl || '%rowtype)
    return ' || p_nm_tbl || '.' || l_pk || '%type is
  begin    
    insert into ' || p_nm_tbl || '
    values p_row
    returning ' || l_pk || ' into p_row.' || l_pk || ';
    return p_row.' || l_pk || ';
  end add;

  function edt(p_row in out ' || p_nm_tbl ||
               '%rowtype) return ' || p_nm_tbl || '%rowtype is
  begin
    update ' || p_nm_tbl || ' d ' || l_upd_str || '
     where d.' || l_pk || ' = p_row.' || l_pk || ';
    return p_row;
  end edt;
  
  procedure del(p_id ' || p_nm_tbl || '.' || l_pk ||
               '%type) is
  begin
    delete from ' || p_nm_tbl || ' where ' || l_pk ||
               ' = p_id;
  exception
    when others then
      null;
  end del;
  
  function get(p_id ' || p_nm_tbl || '.' || l_pk ||
               '%type) return ' || p_nm_tbl || '%rowtype is
    v_row ' || p_nm_tbl || '%rowtype;
  begin
    select * into v_row from ' || p_nm_tbl || ' where ' || l_pk ||
               ' = p_id;
    return v_row;
  exception
    when no_data_found then
      return null;
  end get;
  
  procedure set(p_row in out ' || p_nm_tbl || '%rowtype) is
  begin
    if p_row.' || l_pk || ' is null then
      p_row.' || l_pk || ' := add(p_row);
    else
      p_row := edt(p_row);
    end if;
  end set;
  
end pck_api_' || p_nm_tbl || ';
';
    execute immediate l_stmnt;
  end;

  procedure p_init_table(p_nm_tbl varchar2) is
    l_stmnt clob;
  begin
    l_stmnt := 'alter table ' || p_nm_tbl ||
               ' add SYS_DT_INS date not null';
    execute immediate l_stmnt;
    l_stmnt := 'alter table ' || p_nm_tbl ||
               ' add SYS_EMP_INS number not null';
    execute immediate l_stmnt;
    l_stmnt := 'alter table ' || p_nm_tbl ||
               ' add SYS_DT_UPD date not null';
    execute immediate l_stmnt;
    l_stmnt := 'alter table ' || p_nm_tbl ||
               ' add SYS_EMP_UPD number not null';
    execute immediate l_stmnt;
  end p_init_table;

  function f_create_api(p_nm_tbl varchar2, p_init boolean default true)
    return pck_a_types.t_result is
    l_res pck_a_types.t_result;
    l_msg varchar2(1000);
    no_tbl exception;
  begin
    --Проверка наличия в БД таблицы
    if not f_check_tbl(p_nm_tbl => p_nm_tbl) then
      raise no_tbl;
    end if;
    --Добавление системных полей в таблицу
    if p_init then
      p_init_table(p_nm_tbl);
    end if;
    --Cоздание сиквенса
    p_create_sq(p_nm_tbl);
    --Создание BIR триггера
    p_create_tg_bir(p_nm_tbl);
    --Создание USER триггера
    p_create_tg_user(p_nm_tbl);
    --Создание API пакета
    p_create_api_pck(p_nm_tbl);
    --Возвращаем результат
    l_msg := 'Успешная генерации API';
    l_res := pck_a_types.f_l_res(p_code => -1, p_msg => l_msg);
    return l_res;
  exception
    when no_tbl then
      l_msg := 'в БД нет такой таблицы';
      l_res := pck_a_types.f_l_res(p_code => -1, p_msg => l_msg);
      return l_res;
    when others then
      l_msg := 'Ошибка при генерации API';
      l_res := pck_a_types.f_l_res(p_code     => -1,
                                   p_msg      => l_msg || '; ' || g_msg,
                                   p_ora_code => g_err_code,
                                   p_ora_msg  => g_err_msg);
      return l_res;
  end f_create_api;

  procedure p_drop_sq(p_nm_tbl varchar2) is
    l_stmnt clob;
    sq_ex exception;
  begin
    l_stmnt := 'drop sequence SQ_' || p_nm_tbl;
    execute immediate l_stmnt;
  exception
    when others then
      g_err_msg  := sqlerrm;
      g_err_code := sqlcode;
      g_msg      := 'Ошибка при удалении SQ';
      raise sq_ex;
  end p_drop_sq;

  procedure p_drop_tg(p_nm_tbl varchar2) is
    l_stmnt clob;
    tg_ex exception;
  begin
    l_stmnt := 'drop trigger TG_' || p_nm_tbl;
    execute immediate l_stmnt;
    l_stmnt := 'drop trigger TG_' || p_nm_tbl || '_USER';
    execute immediate l_stmnt;
  exception
    when others then
      g_err_msg  := sqlerrm;
      g_err_code := sqlcode;
      g_msg      := 'Ошибка при удалении TG';
      raise tg_ex;
  end p_drop_tg;

  procedure p_drop_api_pck(p_nm_tbl varchar2) is
    l_stmnt clob;
  begin
    l_stmnt := 'DROP PACKAGE PCK_API_' || p_nm_tbl;
    execute immediate l_stmnt;
  end;

  function f_drop_api(p_nm_tbl varchar2) return pck_a_types.t_result is
    l_res pck_a_types.t_result;
    l_msg varchar2(1000);
    no_tbl exception;
  begin
    --Проверка наличия в БД таблицы
    if not f_check_tbl(p_nm_tbl => p_nm_tbl) then
      raise no_tbl;
    end if;
    --DROP сиквенса
    p_drop_sq(p_nm_tbl);
    --DROP триггера    
    p_drop_tg(p_nm_tbl);
    --DROP API пакета
    p_drop_api_pck(p_nm_tbl);
    --Возвращаем результат
    l_msg := 'Успешное удаление API';
    l_res := pck_a_types.f_l_res(p_code => -1, p_msg => l_msg);
    return l_res;
  exception
    when no_tbl then
      l_msg := 'в БД нет такой таблицы';
      l_res := pck_a_types.f_l_res(p_code => -1, p_msg => l_msg);
      return l_res;
    when others then
      l_msg := 'Ошибка при удалении API';
      l_res := pck_a_types.f_l_res(p_code     => -1,
                                   p_msg      => l_msg || '; ' || g_msg,
                                   p_ora_code => g_err_code,
                                   p_ora_msg  => g_err_msg);
      return l_res;
  end f_drop_api;

  function get_query(pr_table        varchar2,
                     pr_column       varchar2,
                     pr_id           varchar2,
                     pr_id_is_number boolean default true,
                     pr_nm_dt_beg    varchar2,
                     pr_nm_dt_end    varchar2,
                     pr_dt           date) return clob is
    l_query     clob;
    l_id        varchar2(4000);
    l_dt_format varchar2(40) := q'['dd.mm.yyyy']';
  begin
    if pr_id_is_number then
      l_id := pr_id;
    else
      l_id := 'to_char(' || pr_id || ')';
    end if;
    l_query := 'select count(*) from ' || pr_table || ' t where t.' ||
               pr_column || ' = ' || l_id || ' and to_date(''' || pr_dt ||
               ''',' || l_dt_format || ')  between t.' || pr_nm_dt_beg ||
               ' and t.' || pr_nm_dt_end;
    return l_query;
  end;

  function check_dates(pr_table        varchar2,
                       pr_column       varchar2 default null,
                       pr_id           varchar2,
                       pr_id_is_number boolean default true,
                       pr_nm_dt_beg    varchar2,
                       pr_nm_dt_end    varchar2,
                       pr_dt_beg       date,
                       pr_dt_end       date) return boolean is
    no_table_exists exception;
    no_column       exception;
    dt_wrong        exception;
    l_pk    VARCHAR2(4000);
    l_cnt   number;
    l_query clob;
  begin
    --check on exist table
    if not f_check_tbl(pr_table) then
      raise no_table_exists;
    end if;
    --if column not in params then check and get primary key
    if pr_column is null then
      l_pk := f_get_pk(pr_table);
      if l_pk is null then
        raise no_column;
      end if;
    else
      l_pk := pr_column;
    end if;
    --Check for cross dates
    --Create query for begin date
    l_query := pck_util.get_query(pr_table        => pr_table,
                                  pr_column       => l_pk,
                                  pr_id           => pr_id,
                                  pr_id_is_number => pr_id_is_number,
                                  pr_nm_dt_beg    => pr_nm_dt_beg,
                                  pr_nm_dt_end    => pr_nm_dt_end,
                                  pr_dt           => pr_dt_beg);
    pck_log.p_ins(p_va1 => 'query1', p_clb_val => l_query);
    execute immediate l_query
      into l_cnt;
    if l_cnt > 0 then
      raise dt_wrong;
    end if;
    --Create query for end date
    l_query := pck_util.get_query(pr_table        => pr_table,
                                  pr_column       => l_pk,
                                  pr_id           => pr_id,
                                  pr_id_is_number => pr_id_is_number,
                                  pr_nm_dt_beg    => pr_nm_dt_beg,
                                  pr_nm_dt_end    => pr_nm_dt_end,
                                  pr_dt           => pr_dt_end);
    pck_log.p_ins(p_va1 => 'query2', p_clb_val => l_query);
    execute immediate l_query
      into l_cnt;
    if l_cnt > 0 then
      raise dt_wrong;
    end if;
    return true;
  exception
    when no_table_exists then
      return false;
    when no_column then
      return false;
    when dt_wrong then
      return false;
  end check_dates;

end pck_util;
/