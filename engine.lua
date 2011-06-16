function update_options_file()
  local options = ""
  options = options .. "current_difficulty = " .. tostring(current_difficulty) .. "\n"
  love.filesystem.write("options.cfg", options, all)
end

function get_current_resolution()
  for i = 1, #resolutions do
    if resolutions[i].current == true then
      return resolutions[i]
    end
  end
end