# foosey API calls
# for more information see API.md

# returns an api object for game with id game_id
def api_game(game_id)
  db = SQLite3::Database.new 'foosey.db'

  db.results_as_hash = true
  game = db.execute 'SELECT * FROM Game
                     JOIN (
                       SELECT DisplayName, PlayerID FROM Player
                     )
                     USING (PlayerID)
                     WHERE GameID = :id
                     ORDER BY Score;', game_id

  return {
    error: true,
    message: "Invalid game ID: #{game_id}"
  } if game.nil?

  response = {
    gameID: game.first['GameID'],
    timestamp: game.first['Timestamp'],
    teams: []
  }

  game.each do |player|
    i = response[:teams].index { |t| t[:score] == player['Score'] }
    if i
      # team exists in hash
      response[:teams][i][:players] << player['DisplayName']
    else
      # team doesn't exist in hash
      response[:teams] << {
        players: [player['DisplayName']],
        score: player['Score'],
        delta: elo_change(player['PlayerID'], game_id)
      }
    end
  end

  response
rescue SQLite3::Exception => e
  puts e
  500 # Internal server error
ensure
  db.close if db
end

# returns an api object for player with id player_id
def api_player(player_id)
  db = SQLite3::Database.new 'foosey.db'

  db.results_as_hash = true
  player = db.execute('SELECT * FROM Player
                       WHERE PlayerID = :id', player_id).first

  return {
    error: true,
    message: "Invalid player ID: #{player_id}"
  } if player.nil?

  {
    playerID: player['PlayerID'],
    displayName: player['DisplayName'],
    elo: player['Elo'],
    winRate: player['WinRate'],
    gamesPlayed: player['GamesPlayed'],
    admin: player['Admin'] == 1,
    active: player['Active'] == 1
  }
rescue SQLite3::Exception => e
  puts e
  500 # Internal server error
ensure
  db.close if db
end

namespace '/v1' do
  # Player Information
  # All Players / Multiple Players
  get '/players' do
    # set ids to params, or all player ids
    ids = params['ids'].split ',' if params['ids']
    ids ||= player_ids
    json ids.collect { |id| api_player id }
  end

  # One Player
  get '/players/:id' do
    id = params['id'].to_i
    json api_player id
  end

  # Game Information
  # Games a Player Has Played In
  get '/players/:id/games' do
    id = params['id'].to_i

    ids = games_with_player id

    json ids.collect { |i| api_game i }
  end

  # All Games / Multiple Games
  get '/games' do
    # set params and their defaults1
    ids = params['ids'].split ',' if params['ids']
    limit = params['limit'].to_i if params['limit']
    offset = params['offset'].to_i if params['offset']
    ids ||= game_ids
    limit ||= ids.length
    offset ||= 0

    ids = ids[offset, limit]
    # fix if offset is too high, return empty array
    ids ||= []

    json ids.collect { |id| api_game id }
  end

  # One Game
  get '/games/:id' do
    id = params['id'].to_i
    json api_game id
  end

  # Statistics
  # Player Elo History
  get '/stats/elo/:id' do
    id = params['id'].to_i

    501 # Not yet implemented
  end

  # Player Win Rate History
  get '/stats/winrate/:id' do
    id = params['id'].to_i

    501 # Not yet implemented
  end

  # Adding Objects
  # Add Game
  post '/add/game' do
    body = JSON.parse request.body.read

    501 # Not yet implemented
  end

  # Add Player
  post '/add/player' do
    body = JSON.parse request.body.read

    501 # Not yet implemented
  end

  # Editing Objects
  # Edit Game
  post '/edit/game' do
    body = JSON.parse request.body.read

    501 # Not yet implemented
  end

  # Edit Player
  post '/edit/player' do
    body = JSON.parse request.body.read

    501 # Not yet implemented
  end

  # Removing Objects
  # Remove Game
  delete '/remove/game/:id' do
    id = params['id'].to_i

    501 # Not yet implemented
  end

  # Remove Player
  delete '/remove/player/:id' do
    id = params['id'].to_i

    501 # Not yet implemented
  end
end