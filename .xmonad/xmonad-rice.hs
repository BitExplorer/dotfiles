import XMonad

-- util --
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce

---------
--conf
--import Data.List
---- layouts
--import XMonad.Layout.Spacing
--import XMonad.Layout.Grid
----import XMonad.Layout.Fullscreen
--import XMonad.Layout.NoBorders
--import XMonad.Layout.MultiToggle
-------------


import qualified XMonad.StackSet as W

-- hooks --
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

-- custom prompt
import XMonad.Prompt ( XPPosition (Top), alwaysHighlight, font , position, promptBorderWidth )
import XMonad.Prompt.ConfirmPrompt ( confirmPrompt )
import System.Exit

-- layouts
import XMonad.Layout.ToggleLayouts

import qualified Data.Map as M

-- own module: configuration decomposition --
-- http://learnyouahaskell.com/modules

import MyManageHook
import MyWorkspaces
import MyLayoutHook
import MyLogHookWS
import MyLogHookLT
import MyStatusBar
import MyColor
import KeyBindings
import Graphics.X11.ExtraTypes.XF86

-- https://pbrisbin.com/posts/xmonad_modules/
-- do '$ ghc xmonad -ilib' in your ~/.xmonad
-- to enable '$ xmonad --recompile'
-- https://unix.stackexchange.com/questions/175127/xmobar-doesnt-appear

main = do

    -- spawnPipe fails on xrdp sesssions on archlinux
    spawn csbdBottomBackground
    spawn csbdBottomRight
    sbLayoutText <- spawnPipe csbdBottomLeft
    sbWorkspace <- spawnPipe csbdBottomCenter

    spawn csbdTopBackground
    spawn csbdTopLeft
    spawn csbdTopRight
    spawn csbdTopCenter

--  http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Config.html
--  use def instead of defaultConfig for more edge distribution.

    --xmonad $ defaultConfig
    xmonad $ def
        -- added (isFullscreen --> doFullFloat) for intellij
        -- { manageHook    = myManageHook <+> manageDocks <+> manageHook def
        { manageHook    = myManageHook <+> (isFullscreen --> doFullFloat) <+> manageDocks <+> manageHook def
        , layoutHook    = myLayoutHook
        , logHook       = myLogHookLT sbLayoutText <+> myLogHookWS sbWorkspace
        , workspaces    = myWorkspaces
        , terminal      = myTerminal
        , borderWidth   = 3
        --, startupHook   = spawnOnce autoload
        -- needed for java and intellij
        , startupHook   = spawnOnce autoload <+> setWMName "LG3D"
        , modMask       = mod4Mask
--        , modMask       = mod4Mask     -- Rebind default Mod to the Windows key for the default key bindings
        , normalBorderColor  = myColor "Blue"
        , focusedBorderColor = myColor "Yellow"
        } `additionalKeys` myKeys
     where
        autoload = "~/.xmonad/assets/bin/autoload.sh"

-- Common
--myTerminal = "termite"
myTerminal = "alacritty"
myBrowser = "firefox"

-- Custom Prompt
myXPConfig = def
    { position          = Top
    , alwaysHighlight   = True
    , promptBorderWidth = 0
    --, font              = "xft:monospace:size=12"
    , font              = "xft:SauceCodePro NF:pixelsize=16"
    }
------------------------------------------------------------------------
--myKeys conf@XConfig {modMask = modMask} =
--myKeys conf@XConfig {modMask = modMask} = M.fromList $
--
-- toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
-- myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
-- myKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList $

myKeys =
   [
    ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((mod4Mask .|. shiftMask, xK_p), spawn "dmenu_run -nb orange -nf '#444' -sb yellow -sf black -fn Monospace-9:normal")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask, xK_i), spawn myBrowser)
        , ((mod4Mask, xK_n), spawn "standard-notes")
        , ((mod4Mask .|. shiftMask, xK_i), spawn (myBrowser ++ " -private-window"))
        --, ((mod4Mask, xK_Return), spawn "termite")
        , ((mod4Mask, xK_Return), spawn "alacritty")
        , ((mod4Mask .|. shiftMask, xK_Return), spawn "urxvt")
        --, ((mod4Mask .|. shiftMask, xK_BackSpace), kill)
        , ((mod4Mask .|. shiftMask, xK_BackSpace), kill)

        , ((mod4Mask,               xK_space ), sendMessage NextLayout)
        --, ((mod4Mask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
        -- us the tool: xev
        -- , ((0         , 0x1008FF11), spawn "amixer -q sset Master 2%-")
        -- , ((0         , 0x1008FF13), spawn "amixer -q sset Master 2%+")
        -- , ((0         , 0x1008FF12), spawn "amixer set Master toggle")
        -- https://superuser.com/questions/389737/how-do-you-make-volume-keys-and-mute-key-work-in-xmonad
        -- amixer -D pulse set Master 2-
        --, ((0, xF86XK_AudioLowerVolume   ), spawn "amixer set Master 2-")
        , ((0, xF86XK_AudioLowerVolume   ), spawn "amixer -q -D pulse sset Master 2%-")
        , ((0, xF86XK_AudioRaiseVolume   ), spawn "amixer -q -D pulse sset Master 2%+")
        --, ((0, xF86XK_AudioMute          ), spawn "amixer set Master toggle")
        , ((0, xF86XK_AudioMute          ), spawn "amixer -D pulse sset Master toggle")
        --, ((mod4Mask .|. shiftMask, xK_w), confirmPrompt myXPConfig "exit" (io exitSuccess))
        --, ((mod4Mask .|. shiftMask, xK_q), confirmPrompt myXPConfig "exit" (io exitSuccess))
        , ((mod4Mask .|. shiftMask, xK_Escape), confirmPrompt myXPConfig "exit" (io exitSuccess))
        --, ((mod4Mask, xK_space ), sendMessage ToggleLayout)
    ]
    -- ++
    -- [((m .|. mod4Mask, k), windows $ f i)
    --     | (i, k) <- zip (workspaces conf)[ xK_ampersand
    --                                      , xK_eacute
    --                                      , xK_quotedbl
    --                                      , xK_apostrophe
    --                                      , xK_parenleft
    --                                      , xK_section -- 6 0xa7
    --                                      , xK_egrave
    --                                      , xK_exclam  -- 8 0x21
    --                                      , xK_ccedilla
    --                                      , xK_agrave
    --                                      , xK_parenright
    --                                      ] ,
    --       (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
