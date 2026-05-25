-- custom level that uses T-B1 as a base and makes it harder

local levelid = ''

return {

  -- called once when the game loads (or when your mod is marked 'active')
  load = function(mod_id)

    print('Hello world!', mod_id)

    -- register the level making it available to the player in the custom level world
    -- your level name in the game code will be referenced as mod_id + '_' + the id you register here
    -- in this case mod_id + '_' + custom1
    -- you could register more than one level here if you wanted, but should give them unique names to each other within your mod
    -- this function will return the level id for you to use later
    levelid = mod.register(mod_id, 'custom2',
      {
        -- level name for overworld
        name = 'I REALLY Know What I\'m Doing',

        -- the 3 beast slots shown in the overworld should match the beasts in your level
        -- in this case we just have 'beast2' in our level so only one entry
        beasts = {'beast0', '', ''},

        -- same for stars, beast id or 'secret' if you have a secret one
        -- in this case we work from the other side, 'secret' first if you have it, then the beast star
        -- this level has no secret star, so only star comes from the beast
        stars = {'', '', 'beast0'},

        -- then we need to define the 'progmap' for the level
        -- this allows you to define beast orders unlocking other beasts
        -- see the progmap definition in the globals.lua file to see how it's used for multi-beast levels
        progmap = {
          start = 'beast0', -- starting beast
          order1 = {'beast0', 'order1'}, -- first order is beast2's order1 as defined in Tiled
          finish = 'order1met' -- dialogue key to run when all beast+orders are done (see below)
        },

        -- now we need some custom dialogue for the bot!
        dialogue = {
          -- intiial dialogue automatically shown on level start
          intro = {
            "Good Morning Chef! As you whizzed through the training fast-track, the Head Chef felt you could do with a tougher challenge!",
            "This is a modified version of the same factory, but it'll require a lot more advanced tactics to beat...",
          },
          -- reminder prompt before orders are taken
          whatdoing = {
            "As you know what you're doing, I'll leave you to it!"
          },
          -- triggered when order1 (as mapped in progmap) is accepted
          order1got = {
            "Same order as last time, but 3x the rate! Plus a more difficult factory to work around...",
            "But, as you know what you're doing, I'll leave you to it!"
          },
          -- shown if talking to the bot while order is in the 60s timer
          order1meet = {
            "Great work Chef, keep it up for another minute and we'll be all done here!"
          },
          -- show if talking to the bot while order is met
          -- as we set it to 'finish' above, it will automatically show when the order is finished
          order1met = {
            "Excellent work Chef! I guess you really do know what you're doing huh!"
          }
        },

        -- add void pump and drizzler
        machines = {'pump2', 'drizzler'}


      })
    return true
  end,

  -- called when the player actually loads a custom level, and is now in the level
  -- here you can set what tools may be required, or run any special logic you might want
  start = function(mod_id)
    -- your custom level will be loaded as your mod_id + '_' + the level id you registered
    -- you should check that your level is the active level or your code will be run for any custom level!!
    if game.g.level == levelid then
      -- do something when your level loads!
    end
  end,

  -- if you want, you could also hook into any of the other event hooks
  -- just like a normal functionality mod!
  -- for this level, snacktorio doesn't actually have a kill plane at the bottom of levels becuase there's usually bedrock
  -- so every frame we check the player position and if they've fallen off and are heading towards the bottom
  -- we automatically respawn them back to their spawn point
  step = function()
    -- if it's my level
    if game.g.level == levelid then
      -- maps are 200x200 blocks, each block 17 pixels
      -- this level we built from 100y upwards so anything below 180 is likely you fell
      if game.g.player and game.g.player.y >= 180*17 then
        game.g.player.scripts.respawn()
      end
    end
  end

}