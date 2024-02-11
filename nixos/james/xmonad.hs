import System.IO (hPutStrLn)
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.NoBorders (SmartBorder)
import XMonad ((.|.))
import XMonad ((<+>))
import XMonad (Choose)
import XMonad (controlMask)
import XMonad (defaultConfig)
import XMonad (Full)
import XMonad (handleEventHook)
import XMonad (KeyMask)
import XMonad (KeySym)
import XMonad (layoutHook)
import XMonad (Mirror)
import XMonad (mod1Mask)
import XMonad (shiftMask)
import XMonad (spawn)
import XMonad (startupHook)
import XMonad (Tall)
import XMonad (terminal)
import XMonad (X)
import XMonad (XConfig)
import XMonad (xK_f)
import XMonad (xK_l)
import XMonad (xK_p)
import XMonad (xK_q)
import XMonad (xK_s)
import XMonad (xK_space)
import XMonad (xmonad)
import XMonad.Core (logHook)
import XMonad.Hooks.DynamicLog (def)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP)
import XMonad.Hooks.DynamicLog (ppOutput)
import XMonad.Hooks.DynamicLog (ppTitle)
import XMonad.Hooks.DynamicLog (shorten)
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.Hooks.DynamicLog (xmobarColor)
import XMonad.Hooks.DynamicLog (xmobarPP)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Hooks.ManageDocks (docks)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe)

myAdditionalKeys :: [((KeyMask, KeySym), X ())]
myAdditionalKeys =
  [ ((mod1Mask .|. shiftMask, xK_l), spawn "xset s activate")
  , ((mod1Mask .|. shiftMask, xK_p), spawn "2famenu")
  , ((mod1Mask .|. shiftMask, xK_s), spawn "xset s activate ; systemctl suspend -i")
  , ((mod1Mask .|. shiftMask, xK_f), spawn "xdg-open about:blank")
  ]

myAdditionalKeysP :: [(String, X ())]
myAdditionalKeysP =
  [ ("<XF86ScreenSaver>",       spawn "xset s activate")
  , ("<XF86AudioMute>",         spawn "amixer set Master toggle")
  , ("<XF86AudioLowerVolume>",  spawn "amixer set Master 5%-")
  , ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 5%+")
  , ("<XF86MonBrightnessUp>",   spawn "light -A 10")
  , ("<XF86MonBrightnessDown>", spawn "light -U 10")
  ]

myConfig :: XConfig (ModifiedLayout SmartBorder (Choose Tall (Choose (Mirror Tall) Full)))
myConfig = def {
    terminal = "xterm"
  , startupHook = setWMName "LG3D" -- for Java GUIs
  , layoutHook = smartBorders $ layoutHook def
  }
  `additionalKeys` myAdditionalKeys
  `additionalKeysP` myAdditionalKeysP

main :: IO ()
main = xmonad =<< xmobar myConfig
