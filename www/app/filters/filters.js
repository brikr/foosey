angular
	.module('foosey')
	.filter('and', and)
	.filter('capitalize', capitalize)
	.filter('date', date)
	.filter('eloChange', eloChange)
	.filter('team', team)
	.filter('time', time)
	.filter('percentage', percentage);

// replace & with And
function and()
{
	return function(str)
	{
		return str.split('&').join(' & ');
	}
}

// capitalize the first letter of a word
function capitalize() 
{
  return function(input) {
    return !input ? '' : input.toLowerCase().replace( /\b\w/g, function (m) {
      return m.toUpperCase();
    });
  }
}

// format date
function date() 
{
  return function(input) {
    var day = moment(input);
  	var daysFromToday = moment().diff(day, 'days');
	  
    // Special cases
    if (daysFromToday === 0) return 'Today';
    if (daysFromToday === 1) return 'Yesterday';
    if (daysFromToday < 7) return day.format('dddd');

    return input;
  }
}

// format the elo change for the day
function eloChange()
{
	return function(input)
	{
		if (input === undefined || input === null) return '';
		plusOrMinus = input < 0 ? input : '+' + input
		return '(' + plusOrMinus + ')';
	}
}

// nice string for teams
function team()
{
	return function(players)
	{
		// for one or two players
		if (players.length === 1) return players[0].name;
		if (players.length === 2) return players[0].name + " and " + players[1].name;

		// else, comma seperated list
		var teamName = "";
		var i = 0;
		while(i < players.length)
		{
			// if last one, add and with no comma
			if (i + 1 === players.length)
				teamName += "and " + players[i].name;
			else
				teamName += players[i].name + ", ";
			i++;
		}
		return teamName;
	}
}

// convert from 24-hour to am/pm
function time()
{
	return function(input)
	{
		var day = moment.unix(input);
    var daysFromToday = moment().diff(day, 'days');

	}
}

function percentage($filter) {
  return function (input, decimals) 
  {
    return $filter('number')(input * 100, decimals) + '%';
  }
}