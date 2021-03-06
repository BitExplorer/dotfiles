module Local.Layouts (myLayouts) where

import XMonad
import XMonad.Layout.Renamed
import XMonad.Hooks.ManageDocks
import XMonad.Layout.PerWorkspace
import XMonad.Layout.LimitWindows
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.ComboP
import XMonad.Layout.Spacing
import XMonad.Layout.Minimize
import XMonad.Layout.FixedColumn
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.TwoPane
import XMonad.Layout.Magnifier
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Config.Desktop
import qualified XMonad.Layout.BoringWindows as B
import qualified XMonad.Layout.Spiral as Sp
import XMonad.Layout.IM
import XMonad.Layout.Circle (Circle (..))
import XMonad.Layout.Reflect (reflectHoriz)
import System.Info (os)

import Local.Workspaces (myWorkspaces)

-- mySpacing = if os == "freebsd" then spacingRaw False (Border 14 1 1 1) True (Border 1 1 1 1) True else spacingRaw False (Border 2 1 1 1) True (Border 1 1 1 1) True
-- mySpacing = spacingRaw False (Border 14 1 1 1) True (Border 1 1 1 1) True
mySpacing = spacingRaw False (Border 1 1 1 1) True (Border 1 1 1 1) True

-- layouts need to be changed to add the avoidStruts modifier which will cause the layouts to make space for statusbars like dzen2.
-- myLayouts = renamed [CutWordsLeft 1] . autoStrutsOn [U] . minimize . B.boringWindows $ workspaceLayouts
-- myLayouts = renamed [CutWordsLeft 1] . avoidStruts . minimize . B.boringWindows $ workspaceLayouts
myLayouts = renamed [CutWordsLeft 1] . minimize . B.boringWindows $ workspaceLayouts

  -- layout per workspace
workspaceLayouts =
        onWorkspace "1" my3FT $
        onWorkspace "2" myAllLayoutGroup $
        onWorkspace "3" myFtLayoutGroupM $
        onWorkspace "4" my3FT $
        onWorkspace "5" myFtLayoutGroupM $
        onWorkspace "6" myMiscLayoutGroup $
        onWorkspace "7" my3FT $
        onWorkspace "8" my3FT $
        onWorkspace "9" my3FT $
        onWorkspace "0" myFtLayoutGroup myAllLayoutGroup
        -- onWorkspace "0" myMiscLayoutGroup


myFtLayoutGroup  = myTileLayout ||| fullLayout ||| commonLayout
myFtLayoutGroupM = myTileLayout ||| fullLayout ||| myMagn
my3FT = myTileLayout ||| fullLayout ||| threeCol
myMiscLayoutGroup = mediaLayout ||| terminalLayout ||| terminalLayout ||| commonLayout ||| readingLayout ||| panelLayout
myAllLayoutGroup = myTileLayout ||| fullLayout ||| threeCol ||| myMagn ||| terminalLayout

fullLayout = renamed [Replace "Full"]
      $ mySpacing
      $ limitWindows 10
      $ noBorders Full
myTileLayout = renamed [Replace "Main"]
      $ avoidStruts
      $ smartBorders
      $ mySpacing
      $ Tall 1 (3/100) (1/2)
threeColumn = renamed [Replace "3Col"]
      $ mySpacing
      $ avoidStruts
      $ ThreeColMid 1 (3/100) (1/2)
threeCol = renamed [Replace "Three"]
      $ avoidStruts
      $ mySpacing
      $ ThreeColMid 1 (1/10) (1/2)
myMagn = renamed [Replace "Mag"]
      $ mySpacing
      $ noBorders
      $ limitWindows 3
      $ magnifiercz' 1.4
      $ FixedColumn 1 20 80 10
commonLayout = renamed [Replace "Com"]
      $ mySpacing
      $ avoidStruts
      $ Tall 1 (5/100) (1/3)
terminalLayout = renamed [Replace "Terminals"]
      $ mySpacing
      $ avoidStruts
      $ simpleTall 50 ||| simpleThree 33 ||| Mirror (simpleTall 53)
-- codingLayout = renamed [Replace "Coding"]
--       $ twoPaneTabbed ||| twoPaneTall ||| simpleTall 50
mediaLayout = renamed [Replace "Media"]
      $ mySpacing
      $ simpleTwo 40 ||| Grid ||| simpleThree 33
readingLayout = renamed [Replace "Reading"]
      $ mySpacing
      $ simpleTwo 50 ||| simpleThree 50
phiLayout = renamed [Replace "Phi"]
      $ mySpacing (2 / (1 + toRational (sqrt 5 :: Double)))
      -- $ mySpacing
      -- $ (2/(1+(toRational(sqrt(5)::Double)))) -- Golden Ratio
spiralLayout  = renamed [Replace "Spiral"]
      $ mySpacing
      $ avoidStruts
      $ Sp.spiralWithDir Sp.East Sp.CW (6/7)
panelLayout = renamed [Replace "Control"]
      $ mySpacing
      $ Grid ||| Mirror (simpleTall 50) ||| simpleThree 33
-- myGimpLayout = renamed [Replace "Gimp"]
--       $ withIM 0.11 (Role "gimp-toolbox")
--       $ reflectHoriz
--       $ withIM 0.15 (Role "gimp-dock") Full
-- gimpLayout = renamed [Replace "Gimp"]
--       $ withIM 0.15 (Role "gimp-toolbox")
--       $ reflectHoriz
--       $ withIM 0.2 (Role "gimp-dock") Full

-- circleLayout = renamed [Replace "cir" ]
--       $ Mirror Tall 1 (3/100) (1/2) ||| tiled ||| Circle
   where
      tiled = Tall nmaster delta ratio
      nmaster = 1
      delta = 3/100
      ratio = 1/2

-- twoPaneTabbed =
--   configurableNavigation noNavigateBorders $
--   combineTwoP (Spacing $ TwoPane 0.03 0.50)
--       Full
--       (tabbed shrinkText def)
--       (ClassName "Firefox" `Or` ClassName "qpdfview")

twoPaneTall =
  windowNavigation $
  combineTwoP (TwoPane 0.03 0.50) Full (Mirror $ simpleThree 60) (ClassName "Firefox" `Or` ClassName "Brave")

--simpleTall :: Rational -> ResizableTall a
simpleTall n = ResizableTall 1 (3/100) (n/100) []

simpleThree :: Rational -> ThreeCol a
simpleThree n = ThreeCol 1 (3/100) (n/100)

simpleTwo :: Rational -> TwoPane a
simpleTwo n = TwoPane (3/100) (n/100)

desktopLayouts =
    onWorkspace "1"  mailLayout $
    onWorkspace "2"  webLayout $
    onWorkspaces (map show [3..6]) defLayout $
    onWorkspace "7" threeCols $
    onWorkspace "8" gimpLayout $
    onWorkspace "9" fullLayout $
    smartBorders (layoutHook def)
    where
        defLayout = desktopLayoutModifiers $
            smartBorders $ Tall 1 (3/100) 0.5 ||| Full
        mailLayout = desktopLayoutModifiers $
            smartBorders $ Tall 1 (3/100) 0.65 ||| Full
        webLayout  = desktopLayoutModifiers $
            smartBorders $ Full ||| Tall 1 (3/100) 0.65
        threeCols = desktopLayoutModifiers $ smartBorders $
                ThreeCol 1 (3/100) (1/3) ||| Full ||| Tall 1 (2/100) 0.7
        fullLayout = desktopLayoutModifiers $
            noBorders $ Full ||| Mirror (Tall 1 (3/100) 0.8)
        gimpLayout  = avoidStruts $ withIM 0.11 (Role "gimp-toolbox") $
            reflectHoriz $ withIM 0.15 (Role "gimp-dock") Full
