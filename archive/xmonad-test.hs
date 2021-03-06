-- Imports
import XMonad
import XMonad.Util.Run (spawnPipe)
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.List
-- layouts
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
--import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle
-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
-- var
import System.Exit

-- Main process
main :: IO()
main = xmonad =<< statusBar myBar myPP toggleStrutsKey (ewmh myConfig)

-- Configs
--myConfig = defaultConfig { modMask = myModMask,
myConfig = def { modMask = myModMask,
                          terminal = myTerminal,
                          workspaces = myWorkspaces,
                          layoutHook = myLayoutHook,
                          manageHook = myManageHook,
                          handleEventHook = myEventHook,
                          borderWidth = myBorderWidth,
                          normalBorderColor = myNormalBorderColor,
                          focusedBorderColor = myFocusedBorderColor,
                          keys = myKeys
                          }

--myModMask = mod4Mask
-- super key = mod4Mask
-- alt key = mod1Mask
myModMask = mod1Mask
myTerminal = "urxvt"

myws1 = "1"
myws2 = "2"
myws3 = "3"
myws4 = "4"
myws5 = "5"
myws6 = "6"
myws7 = "7"
myws8 = "8"
myws9 = "9"

myWorkspaces :: [String]
myWorkspaces = [myws1, myws2, myws3, myws4, myws5, myws6 , myws7, myws8, myws9 ]

-- Layouts
-- No spacing
{-myLayoutHook = avoidStruts $ smartBorders (tall ||| GridRatio (4/3) ||| Full )-}
                   {-where tall = Tall 1 (3/100) (1/2) -}

-- with spacing
--myLayoutHook = (spacing 10 $ avoidStruts (tall ||| GridRatio (4/3) ||| Full )) ||| smartBorders Full
myLayoutHook = spacing 10 (avoidStruts (tall ||| GridRatio (4 / 3) ||| Full)) ||| smartBorders Full
                   where tall = Tall 1 (3/100) (1/2)

-- fullscreen layout (not needed with ewmh)
--myFullscreen = (fullscreenFloat . fullscreenFull) (smartBorders Full)

-- Mangehooks
myManageHook = composeAll [ isFullscreen            --> doFullFloat,
                         className =? "Firefox" --> doShift myws2,
                         className =? "Pcmanfm" --> doShift myws4,
                         -- manage Gimp toolbox windows
                         className =? "Gimp"  --> doShift myws4, -- may be "Gimp" or "Gimp-2.4" instead
                         (className =? "Gimp" <&&> fmap ("tool" `isSuffixOf`) role) --> doFloat,
                         className =? "Blender" --> doShift myws4,
                         className =? "Inkscape" --> doShift myws4,
                         className =? "libreoffice" --> doShift myws4,
                         className =? "libreoffice-startcenter" --> doShift myws4,
                         className =? "Transmission-gtk" --> doShift myws4,
                         className =? "MPlayer" --> doFloat,
                         className =? "MPlayer" --> doShift myws4,
                         className =? "mpv" --> doFloat,
                         className =? "mpv" --> doShift myws4,
                         className =? "Steam" --> doShift myws7,
                         -- cli apps
                         appName =? "nvim" --> doShift myws3,
                         appName =? "ranger" --> doShift myws4,
                         appName =? "mutt" --> doShift myws4,
                         appName =? "irssi" --> doShift myws5,
                         appName =? "rainbowstream" --> doShift myws5,
                         appName =? "ncmpcpp" --> doShift myws6,
                         manageDocks
--                         fullscreenManageHook
                       ]
                       where role = stringProperty "WM_WINDOW_ROLE"

-- Event Hooks
myEventHook = docksEventHook <+> fullscreenEventHook

-- Looks
myBorderWidth = 4
myNormalBorderColor = "#ffffff"
myFocusedBorderColor = "#cc342b"

-- Xmonbar
myBar = "xmobar"
myPP = xmobarPP { ppCurrent = xmobarColor "#cc342b" ""
                     , ppHidden = xmobarColor "#373b41" ""
                     , ppHiddenNoWindows = xmobarColor "#c5c8c6" ""
                     , ppUrgent = xmobarColor "#198844" ""
                     , ppLayout = xmobarColor "#c5c8c6" ""
                     , ppTitle =  xmobarColor "#373b41" "" . shorten 80
                     , ppSep = xmobarColor "#c5c8c6" "" "  "
                     }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Keyboard shortcuts
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList $
    -- launching apps
    [
      --((modMask,                 xK_Return), spawn "termite")
      ((modMask,                 xK_Return), spawn "alacritty")
    , ((modMask .|. shiftMask, xK_Return), spawn "urxvt")
--    , ((modMask,                 xK_p     ), spawn "rofi -show run")
 --   , ((modMask,                 xK_o     ), spawn "rofi -show window")
  --  , ((modMask .|. controlMask, xK_c     ), spawn "firefox")

    , ((modMask .|. shiftMask, xK_p), spawn "dmenu_run -nb orange -nf '#444' -sb yellow -sf black -fn Monospace-9:normal")
   -- , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    --, ((0, xK_Print), spawn "scrot")
    , ((modMask, xK_i), spawn "firefox")
    , ((modMask, xK_n), spawn "standard-notes")
    , ((modMask .|. shiftMask, xK_i), spawn ("firefox" ++ " -private-window"))

    , ((0, xF86XK_AudioLowerVolume   ), spawn "amixer -q -D pulse sset Master 2%-")
    , ((0, xF86XK_AudioRaiseVolume   ), spawn "amixer -q -D pulse sset Master 2%+")
    --, ((0, xF86XK_AudioMute          ), spawn "amixer set Master toggle")
    , ((0, xF86XK_AudioMute          ), spawn "amixer -D pulse sset Master toggle")

    -- launching cli apps
    -- Kill windows
    , ((modMask .|. controlMask, xK_w     ), kill)
    , ((modMask .|. shiftMask, xK_BackSpace), kill)
    -- screenshot
    , ((0, xK_Print                       ), spawn "scrot")
    -- multimedia
    -- layouts
    , ((modMask,               xK_space ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- floating layer stuff
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- refresh
    , ((modMask,               xK_n     ), refresh)

    -- focus
    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask,               xK_m     ), windows W.focusMaster)

    -- swapping
    --, ((modMask,               xK_Return), windows W.shiftMaster)
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask              , xK_semicolon), sendMessage (IncMasterN (-1)))

    -- resizing
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)
    -- quit, or restart
    , ((modMask .|. shiftMask, xK_Escape  ), io exitSuccess)
    --, ((modMask              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (workspaces conf)[ xK_ampersand
                                         , xK_eacute
                                         , xK_quotedbl
                                         , xK_apostrophe
                                         , xK_parenleft
                                         , xK_section -- 6 0xa7
                                         , xK_egrave
                                         , xK_exclam  -- 8 0x21
                                         , xK_ccedilla
                                         , xK_agrave
                                         , xK_parenright
                                         ] ,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
