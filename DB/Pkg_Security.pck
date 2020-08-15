CREATE OR REPLACE NONEDITIONABLE Package Pkg_Security Is
  Function Hash_MD5(p_msisdn IN VARCHAR2, p_pass IN VARCHAR2) RETURN VARCHAR2;

  Function Check_role(p_user_name in varchar2, p_role in varchar2)
    return boolean;

  Function Authenticate_User(p_User_Name Varchar2, p_Password Varchar2)
    Return Boolean;

  Procedure Process_Login(p_User_Name Varchar2,
                          p_Password  Varchar2,
                          p_App_Id    Number);

End Pkg_Security;
/
CREATE OR REPLACE NONEDITIONABLE Package Body Pkg_Security Is

  Function Hash_MD5(p_msisdn IN VARCHAR2, p_pass IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN(sys.DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_pass || p_msisdn,
                                                       'AL32UTF8'),
                                DBMS_CRYPTO.HASH_MD5));
  END Hash_MD5;

  Function Check_role(p_user_name in varchar2, p_role in varchar2)
    return boolean is
    v_role user_account.user_type%type;
  begin
    select u.user_type
      into v_role
      from user_account u
     where lower(u.user_name) = lower(p_user_name);
    if v_role = p_role then
      return true;
    else
      return false;
    end if;
  end Check_role;

  Function Authenticate_User(p_User_Name Varchar2, p_Password Varchar2)
    Return Boolean As
    v_Password User_Account.Password%Type;
    v_Active   User_Account.Active%Type;
    v_Email    User_Account.Email%Type;
  Begin
    If p_User_Name Is Null Or p_Password Is Null Then
    
      -- Write to Session, Notification must enter a username and password
      Apex_Util.Set_Session_State('LOGIN_MESSAGE',
                                  'Please enter Username and password.');
      Return False;
    End If;
    ----
    Begin
      Select u.Active, u.Password, u.Email
        Into v_Active, v_Password, v_Email
        From User_Account u
       Where u.User_Name = p_User_Name;
    Exception
      When No_Data_Found Then
      
        -- Write to Session, User not found.
        Apex_Util.Set_Session_State('LOGIN_MESSAGE', 'User not found');
        Return False;
    End;
    If v_Password <>
       pkg_security.Hash_MD5(p_msisdn => '333', p_pass => p_Password) Then
    
      -- Write to Session, Password incorrect.
      Apex_Util.Set_Session_State('LOGIN_MESSAGE', 'Password incorrect');
      Return False;
    End If;
    If v_Active <> 'Y' Then
      Apex_Util.Set_Session_State('LOGIN_MESSAGE',
                                  'User locked, please contact admin');
      Return False;
    End If;
    ---
    -- Write user information to Session.
    --
    Apex_Util.Set_Session_State('SESSION_USER_NAME', p_User_Name);
    Apex_Util.Set_Session_State('SESSION_EMAIL', v_Email);
    ---
    ---
    Return True;
  End;

  --------------------------------------
  Procedure Process_Login(p_User_Name Varchar2,
                          p_Password  Varchar2,
                          p_App_Id    Number) As
    v_Result Boolean := False;
  Begin
  
    v_Result := Authenticate_User(p_User_Name, p_Password);
    If v_Result = True Then
      -- Redirect to Page 1 (Home Page).
      Wwv_Flow_Custom_Auth_Std.Post_Login(p_User_Name -- p_User_Name
                                         ,
                                          p_Password -- p_Password
                                         ,
                                          v('APP_SESSION') -- p_Session_Id
                                         ,
                                          p_App_Id || ':1' -- p_Flow_page
                                          );
    Else
      -- Login Failure, redirect to page 101 (Login Page).
      Owa_Util.Redirect_Url('f?p=&APP_ID.:101:&SESSION.');
    End If;
  
  End;

End Pkg_Security;
/
