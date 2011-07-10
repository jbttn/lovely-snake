function load_files()
  if love.filesystem.exists("options.cfg") then
    love.filesystem.load("options.cfg")()
    love.graphics.setMode(max_width, max_height, false, true, 0)
  else
    current_difficulty = difficulty.normal
    max_width = 800
    max_height = 600
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
  options = options .. "max_width = " .. tostring(max_width) .. "\n"
  options = options .. "max_height = " .. tostring(max_height) .. "\n"
  love.filesystem.write("options.cfg", options, all)
end

function update_high_score_file()
  local file_string = "high_score = " .. score .. "\n"
  love.filesystem.write("high_score.cfg", file_string, all)
  print("Wrote ", file_string, " to high score file.")
end

function get_current_resolution()
  return {width = max_width, height = max_height}
end

-- checks to see if the mosue is clicked or hovered inside a rectangle
function mouse_inside(checking, x_mouse, y_mouse, x_pos, y_pos, width, height)
  local valid_x = false
  local valid_y = false

  if x_mouse >= x_pos and x_mouse < x_pos + width then
    valid_x = true
  end
  if y_mouse >= y_pos and y_mouse < y_pos + height then
    valid_y = true
  end
  
  if checking == "x_only" then
    return valid_x
  elseif checking == "y_only" then
    return valid_y
  elseif checking == "both" then
    if valid_x == true and valid_y == true then
      return true
    else
      return false
    end
  end
end

-- string, y position
function print_centered(s, y)
  love.graphics.printf(s, 0, y, max_width, 'center')
end