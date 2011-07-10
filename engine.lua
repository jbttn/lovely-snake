function load_files()
  if love.filesystem.exists("options.cfg") then
    love.filesystem.load("options.cfg")()
  else
    current_difficulty = difficulty.normal
    update_options_file()
  end
  
  score = 0
  if love.filesystem.exists("high_score.cfg") then
    love.filesystem.load("high_score.cfg")()
  else
    high_score = 0
    update_high_score_file()
  end
end

function update_options_file()
  local options = ""
  options = options .. "current_difficulty = " .. tostring(current_difficulty) .. "\n"
  love.filesystem.write("options.cfg", options, all)
end

function update_high_score_file()
  local file_string = "high_score = " .. score .. "\n"
  love.filesystem.write("high_score.cfg", file_string, all)
  print("Wrote ", file_string, " to high score file.")
end

function get_current_resolution()
  for i = 1, #resolutions do
    if resolutions[i].current == true then
      return resolutions[i]
    end
  end
end