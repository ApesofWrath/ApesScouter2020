# Copyright 2020
# The Apes of Wrath
#
# @author Cody King
# cking@apesofwrath668.org

Sequel.migration do
    change do
        create_table(:pit_scouting) do
            primary_key :id
            Integer :comp_id, :null => false
            String :scouter_name, :null => false
            String :team_name, :null => false
            Integer :team_number, :null => false
            String :camera, :null => false
            Text :camera_use, :null => false
            Text :auton_strategy, :null => false
            Text :game_strategy, :null => false
            String :climb, :null => false
            String :ball_intake, :null => false
            String :control_panel, :null => false
            Text :coolest_thing, :null => false
            Text :notes
        end
    end
end
