/// <summary>
/// We have set the following in the Web.Config:
/// <add key="NonProductionActionUrlRedirectOverride" value="Redirect.aspx"/>
/// This means that any time we go to the shell, it will redirect back to this 
/// page once it handles our request. The shell will attach a target parameter
/// in the URL that we can use to determine which page in our application we
/// want to redirect to. Microsoft.Health.Web.HealthServiceActionPage (which
/// this page extends) automatically handles processing the target param
/// in the URL. It uses keys (WCPage_ActionXXX) set in the Web.Config file 
/// to look up where to redirect based on the target param.
/// </summary>
public partial class Redirect : Microsoft.Health.Web.HealthServiceActionPage
{
    //We don't want this page to require log on because when we sign out, 
    //we still want this page to read the WCPage_ActionSignOut key in the
    //Web.Config and redirect us to the proper page on sign out
    protected override bool LogOnRequired
    {
        get
        {
            return false;
        }
    }
}