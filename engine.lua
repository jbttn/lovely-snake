function update_options_file()
  local options = ""
  options = options .. "current_difficulty = " .. tostring(current_difficulty) .. "\n"
  love.filesystem.write("options.cfg", options, all)
end