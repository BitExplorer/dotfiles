module Local.Workspaces (myWorkspaces, scratchPads, viewPrevWS) where

import XMonad
import Control.Monad (unless)
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import qualified XMonad.StackSet as StackSet

ws1 = "01"
ws2 = "02"
ws3 = "03"
ws4 = "04"
ws5 = "05"
ws6 = "06"
ws7 = "07"
ws8 = "08"
ws9 = "09"
ws0 = "10"

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

scratchPads :: [NamedScratchpad]
scratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                 , NS "discord" spawnDiscord findDiscord manageDiscord ]
    where
    full = customFloating $ W.RationalRect 0.05 0.05 0.9 0.9
    top = customFloating $ W.RationalRect 0.0 0.0 1.0 0.5
    h = 0.9
    w = 0.9
    t = 0.95 -h
    l = 0.95 -w
    spawnTerm  = "st" ++  " -n scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
    spawnDiscord  = "discord-flatpak"
    findDiscord   = resource =? "discord"
    manageDiscord = customFloating $ W.RationalRect l t w h

viewPrevWS :: X ()
viewPrevWS = do
  ws <- gets windowset
  let hs = filter (\w -> StackSet.tag w /= "NSP") $ StackSet.hidden ws
  unless (null hs) (windows . StackSet.view . StackSet.tag $ head hs)

