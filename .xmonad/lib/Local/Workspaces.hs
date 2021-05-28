module Local.Workspaces (myWorkspaces, scratchPads, viewPrevWS) where

import XMonad
import Control.Monad (unless)
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import qualified XMonad.StackSet as StackSet

ws1 = "1"
ws2 = "2"
ws3 = "3"
ws4 = "4"
ws5 = "5"
ws6 = "6"
ws7 = "7"
ws8 = "8"
ws9 = "9"
ws0 = "0"
-- data MyWorkspace = WebWorkspace
--                  | MailWorkspace
--                  | CodeWorkspace
--                  | ChatWorkspace
--                  | WinWorkspace
--                  | MusicWorkspace
--                  deriving (Enum, Bounded)

-- myWorkspaces :: [MyWorkspace]
-- myWorkspaces = enumFrom minBound

-- toWorkspaceId :: MyWorkspace -> WorkspaceId
-- toWorkspaceId WebWorkspace = "web"
-- toWorkspaceId MailWorkspace = "mail"
-- toWorkspaceId CodeWorkspace = "code"
-- toWorkspaceId ChatWorkspace = "chat"
-- toWorkspaceId WinWorkspace = "win"
-- toWorkspaceId MusicWorkspace = "music"

myWorkspaces :: [String]
myWorkspaces = [ws1, ws2, ws3, ws4, ws5, ws6, ws7, ws8, ws9, ws0]

    -- tmux1 = NS name' cmd' query' floatingHook
    --     where
    --       name' = "tmux"
    --       cmd' = myTerm ++ " -t tmux_nsp -e tmux new-session -A -s scratch"
    --       query' = title =? "tmux_nsp"

scratchPads :: [NamedScratchpad]
scratchPads = [   NS "terminal" spawnTerm findTerm manageTerm
                , NS "discord" spawnDiscord findDiscord manageDiscord
                -- , NS "tmux" spawnTmux findTmux manageTmux
                , tmux1
                , NS "keepassxc" "keepassxc" (className =? "KeePassXC") (customFloating $ W.RationalRect 0.50 0.05 0.4 0.87)
                , NS "vlc" "vlc" (className =? "vlc") (customFloating $ W.RationalRect 0.50 0.05 0.4 0.87)
              ]
    where
    full = customFloating $ W.RationalRect 0.05 0.05 0.9 0.9
    top = customFloating $ W.RationalRect 0.0 0.0 1.0 0.5
    h = 0.9
    w = 0.9
    t = 0.95 - h
    l = 0.95 - w
    spawnTerm = "st" ++  " -n suckless-terminal"
    findTerm = resource =? "suckless-terminal"
    manageTerm = customFloating $ W.RationalRect l t w h
    spawnTmux = "st -t tmux-nsp -e tmux new-session -A -s scratch"
    findTmux = title =? "tmux"
    manageTmux = customFloating $ W.RationalRect l t w h
    spawnDiscord = "discord-flatpak"
    findDiscord = resource =? "discord"
    manageDiscord = customFloating $ W.RationalRect l t w h
    tmux1 = NS name' cmd' query' manageTmux
        where
          name' = "tmux"
          cmd' = "st -t tmux_nsp -e tmux new-session -A -s scratch"
          query' = title =? "tmux_nsp"

viewPrevWS :: X ()
viewPrevWS = do
  ws <- gets windowset
  let hs = filter (\w -> StackSet.tag w /= "NSP") $ StackSet.hidden ws
  unless (null hs) (windows . StackSet.view . StackSet.tag $ head hs)

-- clickableWorkspaces  = clickable
--   ["^i(me.xbm) me"
--   ,"^i(shell.xbm) code"
--   ,"^i(web.xbm) web"
--   ,"^i(docs.xbm) docs"
--   ,"^i(tunes.xbm) tunes"
--   ,"^i(mail.xbm) mail"]
--       where clickable l     = [ "^ca(1,xdotool key super+" ++ show n ++ ")" ++ ws ++ "^ca()" |
--                               (i,ws) <- zip [1..] l,
--                               let n = i ]

-- myWorkspaces1           = clickable . (map dzenEscape) $ ["1","2","3","4","5", "6", "7", "8", "9", "0"]
clickableWorkspaces :: [String]
clickableWorkspaces = clickable ["1","2","3","4","5", "6", "7", "8", "9", "0"]
  where clickable l     = [ "^ca(1,xdotool key super+" ++ show n ++ ")" ++ ws ++ "^ca()" |
                            (i,ws) <- zip [1..] l,
                            let n = i ]
