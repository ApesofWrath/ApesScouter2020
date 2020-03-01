# Copyright 2020
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

Sequel.migration do
    change do
        create_table(:matches) do
            primary_key :id
            Integer :comp_id, :null => false
            Integer :team_number, :null => false
            Integer :match_number, :null => false
            String :name, :null => false
            String :preload, :null => false
            String :cross_line, :null => false
            Integer :auton_bottom, :null => false
            Integer :auton_top, :null => false
            Integer :auton_misses, :null => false
            Integer :tele_bottom, :null => false
            Integer :tele_top, :null => false
            Integer :tele_misses, :null => false
            String :control_panel, :null => false
            Integer :dropped_balls, :null => false
            String :climb, :null => false
            String :result, :null => false
            Integer :own_score, :null => false
            Integer :opp_score, :null => false
            Integer :ranking_points, :null => false
            String :buddy_climb, :null => false
            String :actively_balance, :null => false
            String :shooting_spot, :null => false
            String :camera, :null => false
            String :ball_ground_pickup, :null => false
            String :ball_human_intake, :null => false
            String :ball_capacity, :null => false
            String :driver_skill, :null => false
            String :played_defense, :null => false
            Text :notes
        end
    end
end

