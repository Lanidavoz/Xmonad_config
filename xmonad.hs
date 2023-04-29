import XMonad
import XMonad.Config.Desktop
import XMonad.Util.EZConfig (additionalKeys)
import qualified XMonad.StackSet as W
import XMonad.Layout.Spacing
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doRectFloat)
import XMonad.ManageHook (className, (=?))
import System.IO (hPutStrLn)

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "URxvt" --> doFloat
  -- Add other rules here if needed
  ]

myStartupHook :: X ()
myStartupHook = do
  spawn "feh --bg-scale ~/.Walls/opensuse.png"
  spawn "xrdb -merge ~/.Xresources"
  spawn "xcompmgr -c -C -t-5 -l-5 &"

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
  xmonad $ desktopConfig
    { terminal    = "urxvt"
    , focusedBorderColor = "#90EE90" 
    , modMask     = mod4Mask
    , borderWidth = 2
    , startupHook = myStartupHook
    , layoutHook  = avoidStruts $ spacing 6 $ layoutHook desktopConfig
    , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
    , manageHook = myManageHook <+> manageDocks <+> manageHook desktopConfig
    }
    `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_Return), spawn "urxvt")
    , ((mod4Mask .|. shiftMask, xK_c     ), kill)
    , ((mod4Mask .|. shiftMask, xK_space ), sendMessage NextLayout)
    , ((mod4Mask .|. shiftMask, xK_n     ), refresh)
    , ((mod4Mask, xK_Tab), windows W.focusDown)
    , ((mod4Mask, xK_j  ), windows W.focusDown)
    , ((mod4Mask, xK_k  ), windows W.focusUp)
    , ((mod4Mask, xK_m  ), windows W.focusMaster)
    , ((mod4Mask, xK_Return), windows W.swapMaster)
    , ((mod4Mask .|. shiftMask, xK_j), windows W.swapDown)
    , ((mod4Mask .|. shiftMask, xK_k), windows W.swapUp)
    , ((mod4Mask, xK_h), sendMessage Shrink)
    , ((mod4Mask, xK_l), sendMessage Expand)
    , ((mod4Mask, xK_comma), sendMessage (IncMasterN 1))
    , ((mod4Mask, xK_period), sendMessage (IncMasterN (-1)))
    , ((mod4Mask, xK_q), restart "xmonad" True)
    , ((mod4Mask .|. shiftMask, xK_f    ), spawn "firefox")
    , ((mod4Mask .|. shiftMask, xK_l    ), spawn "~/.bin/i3lock.sh")
    , ((mod4Mask .|. shiftMask, xK_p    ), spawn "mpv")
    -- Added keybindings
    , ((mod4Mask .|. shiftMask, xK_u), withFocused $ windows . W.sink)
    , ((mod4Mask .|. shiftMask, xK_t), withFocused $ \f -> windows (W.float f (W.RationalRect 0.05 0.05 0.9 0.9)))
    ]
