function click_event(item)
  -- Main Menu
  if item == "New Game" then
    game_state = "running"
    snake:init() -- need to reset camera position...might need the idea of a spawn point on levels
  elseif item == "Options" then
    game_state = "options_menu"
  elseif item == "Quit" then
    love.event.push('q')
  end

  -- Options Menu
  if item == "Difficulty" then
    game_state = "difficulty_menu" --not yet implemented
  elseif item == "Back" then
    game_state = "main_menu"
  end

  -- Difficulty Menu
  for key, value in ipairs(ui.difficulty_menu) do
    if item == value.label then
      current_difficulty = value.option
      update_options_file()
    end
  end

  -- Game Over Menu
  if item == "Try Again" then
    game_state = "running"
    snake:init() -- need to reset camera position...might need the idea of a spawn point on levels
  elseif item == "Main Menu" then
    game_state = "main_menu"
  end
end