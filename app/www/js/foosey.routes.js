(function()
{
  angular
    .module('foosey')
    .config(config);

  function config($urlRouterProvider, SettingsServiceProvider) 
  { 
    // If they're logged in, default to leaderboard
    if (SettingsServiceProvider.$get().loggedIn)
    {
      $urlRouterProvider.otherwise('/app/scorecard/' + SettingsServiceProvider.$get().playerID);
    } 
    // Otherwise, send them to the login page
    else 
    {
      $urlRouterProvider.otherwise('/login');   
    }
  }
})();