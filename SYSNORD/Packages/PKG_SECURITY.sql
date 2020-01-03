CREATE OR REPLACE NONEDITIONABLE Package sysnord.Pkg_Security Is

  Function Authenticate_User(p_User_Name Varchar2, p_Password Varchar2)
    Return Boolean;

  -----
  Procedure Process_Login(p_User_Name Varchar2,
                          p_Password  Varchar2,
                          p_App_Id    Number);

End Pkg_Security;
/