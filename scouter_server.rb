# Copyright 2020
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

require 'sinatra/base'

require './models.rb'

module ApesScouter
    class Server < Sinatra::Base

        get '/' do
            erb :competitions
        end

        # Competitions
        get '/competitions' do
            erb :competitions
        end

        # Create new competition
        get '/new_comp' do
            erb :new_competition
        end

        # Delete Competition
        get '/delete_comp' do
            erb :delete_comp
        end

        get '/competitions/:id/delete' do
            erb :delete_confirm
        end
        
        post '/competitions/:id/delete' do
            @competition.delete
            redirect "/competitions"
        end

        # List of competitions to choose from
        post '/competitions' do
            # Check for duplicate entry
            begin
                competition = Competition.create(:name => params[:name], :year => params[:year])
                competition.save
                rescue Sequel::UniqueConstraintViolation
                    halt(400, "Competition already exists.")
            end

            redirect "/competitions/#{competition.id}"
        end

        # Check that it is a valid project id
        before '/competitions/:id*' do
            @competition = Competition[params[:id]]
            halt(400, "Invalid competition (id).") if @competition.nil?
        end

        # Competition page with match entries
        get '/competitions/:id' do
            # Sorting 
            cols = [] 
            DB.fetch("SHOW COLUMNS FROM matches;").each do |col|
                cols.push(col[:Field])
            end
            if cols.include?(params[:sort])
                @match_sort = params[:sort].to_sym
            else
                @match_sort = :team_number
            end
            
            erb :competition
        end

        # Competition Stats
        get '/competitions/:id/stats' do
            @competition = Competition[params[:id]]
            erb :stats
        end

        # New Pit Scouting
        get '/competitions/:id/new_pit_scout' do
            if Competition[params[:id]].name == "SFR"
                halt(400, "I think you've taken a wrong turn...");
            end
            erb :new_pit_scout
        end

        post '/pit_scouting' do
            # Check if entry exists for team
            if DB.fetch("SELECT COUNT(*) FROM pit_scouting WHERE comp_id = ? AND team_number = ?;", 
                        params[:comp_id], params[:team_number]).first[:"COUNT(*)"].to_i != 0
                halt(400, "Entry found with same team number. Please check your values.")
            end

            # Write image file
            @filename = params[:file][:filename]
            file = params[:file][:tempfile]
            File.open("./public/robots/#{params[:team_number]}_#{params[:comp_id]}", 'wb') do |f|
                f.write(file.read)
            end
           
            # Check if it is the first entry for this team. If so, create entry in teams table.
            if Team.where(:number => params[:team_number]).all.length == 0
                Team.create(:number => params[:team_number])
            end


            halt(400, "Did you make a selection for intake?") if params[:ball_intake].nil?

            team_data = Pit_Scouting.create(:comp_id => params[:comp_id], :scouter_name => params[:scouter_name],
                                            :team_name => params[:team_name], :team_number => params[:team_number],
                                            :camera => params[:camera], :camera_use => params[:camera_use],
                                            :auton_strat => params[:auton_strat], :game_strat => params[:game_strat],
                                            :ball_intake => params[:ball_intake].join(', '),
                                            :climb => params[:climb], :control_panel => params[:control_panel],
                                            :notes => params[:notes])
           
            redirect "/competitions/#{team_data.comp_id}/teams/#{team_data.team_number}"
        end
        
        # Add new match entry
        get '/competitions/:id/new_match' do
            erb :new_match
        end

        # Add new match data to database
        post '/matches' do
            # Check if entry exists for team with same match number
            if DB.fetch("SELECT COUNT(*) FROM matches WHERE comp_id = ? AND team_number = ? AND match_number = ?;", 
                        params[:comp_id], params[:team_number], params[:match_number]).first[:"COUNT(*)"].to_i != 0
                halt(400, "Entry found with same team number and match number. Please check your values.")
            end

            # Check if it is the first entry for this team. If so, create entry in teams table.
            if Team.where(:number => params[:team_number]).all.length == 0
                Team.create(:number => params[:team_number])
            end

            match = Match.create(:comp_id => params[:comp_id], :team_number => params[:team_number], 
                                 :match_number => params[:match_number], 
                                 :name => params[:name], :preload => params[:preload], 
                                 :cross_line => params[:cross_line], :auton_bottom => params[:auton_bottom],
                                 :auton_top => params[:auton_top], :auton_misses => params[:auton_misses],
                                 :tele_bottom => params[:tele_bottom], :tele_top => params[:tele_top],
                                 :tele_misses => params[:tele_misses], :control_panel => params[:control_panel],
                                 :dropped_balls => params[:dropped_balls], :climb => params[:climb],
                                 :result => params[:result], :own_score => params[:own_score], 
                                 :opp_score => params[:opp_score], 
                                 :ranking_points => params[:ranking_points],
                                 :buddy_climb => params[:buddy_climb], :actively_balance => params[:actively_balance], 
                                 :camera => params[:camera],:shooting_spot => params[:shooting_spot],
                                 :ball_ground_pickup => params[:ball_ground_pickup], 
                                 :ball_human_intake => params[:ball_human_intake],
                                 :ball_capacity => params[:ball_capacity],
                                 :driver_skill => params[:driver_skill], 
                                 :played_defense => params[:played_defense], :notes => params[:notes])
       
            redirect "/competitions/#{match.comp_id}"
        end

        # Check that it is a valid project id
        before '/matches/:id*' do
            @match = Match[params[:id]]
            halt(400, "Invalid match (id).") if @match.nil?
        end
        
        get '/matches/:id/edit' do
            erb :match_edit
        end

        post "/matches/:id/edit" do
            @match = Match[params[:id]]
            @match.team_number = params[:team_number]
            @match.match_number = params[:match_number]
            @match.preload = params[:preload]
            @match.cross_line = params[:cross_line]
            @match.auton_bottom = params[:auton_bottom]
            @match.auton_top = params[:auton_top]
            @match.auton_misses = params[:auton_misses]
            @match.tele_bottom = params[:tele_bottom]
            @match.tele_top = params[:tele_top]
            @match.tele_misses = params[:tele_misses]
            @match.control_panel = params[:control_panel]
            @match.dropped_balls = params[:dropped_balls]
            @match.climb = params[:climb]
            @match.result = params[:result]
            @match.own_score = params[:own_score]
            @match.opp_score = params[:opp_score]
            @match.ranking_points = params[:ranking_points]
            @match.buddy_climb = params[:buddy_climb]
            @match.actively_balance = params[:actively_balance]
            @match.camera = params[:camera]
            @match.shooting_spot = params[:shooting_spot]
            @match.ball_ground_pickup = params[:ball_ground_pickup]
            @match.ball_human_intake = params[:ball_human_intake]
            @match.ball_capacity = params[:ball_capacity]
            @match.driver_skill = params[:driver_skill]
            @match.notes = params[:notes]
            @match.save

            redirect "/competitions/#{@match.comp_id}"
        end

        # Check that it is a valid team
        before '/competitions/:id/teams/:number*' do
            @team = Team[params[:number]]
            halt(400, "Team \"#{params[:number]}\" was not found.") if @team.nil?
        end

        # Team page (with stats)
        get '/competitions/:id/teams/:number' do
            # Sorting 
            cols = [] 
            DB.fetch("SHOW COLUMNS FROM matches;").each do |col|
                cols.push(col[:Field])
            end
            if cols.include?(params[:sort])
                @match_sort = params[:sort].to_sym
            else
                @match_sort = :match_number
            end

            erb :team
        end

        # Change Team Picture
        post '/change_picture' do
            @filename = params[:file][:filename]
            file = params[:file][:tempfile]
            File.open("./public/robots/#{params[:team_number]}_#{params[:comp_id]}", 'wb') do |f|
                f.write(file.read)
            end

            redirect "/competitions/#{params[:comp_id]}/teams/#{params[:team_number]}"
        end
        
        # Teams List
        get '/teams' do
            erb :teams
        end

        get '/competitions/:id/teams_list' do
            erb :teams_list
        end
    end
end
