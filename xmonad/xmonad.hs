
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Desktop
import System.IO

-- initially created with help of: http://www.haskell.org/haskellwiki/Xmonad/Config_archive/John_Goerzen%27s_Configuration
-- use "xmonad --recompile" to check it's syntactically correct if making changes (better than just modQ)
    -- list of key codes http://haskell.org/haskellwiki/Xmonad/Key_codes
    -- may also prove useful for some keys and commands http://hackage.haskell.org/packages/archive/X11/1.4.5/doc/html/Graphics-X11-Types.html
        -- may want to encorporate: http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-GridSelect.html
myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "pidgin"    --> doFloat
    , className =? "skype"     --> doFloat
    , className =? "vlc"       --> doFloat
    , className =? "tilda"     --> doFloat
    , className =? "Vncviewer" --> doFloat
    , className =? "firefox" --> doFloat
    , className =? "VirutalBox" --> doFloat
    ]

main = do
    xmproc <- spawnPipe "/usr/bin/tint2 /home/hewes/.config/tint2/tint2rc"
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh desktopConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook desktopConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP $ xmobarPP
        { ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor "green" "" . shorten 50
        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , terminal           = "urxvt"
        } `additionalKeys`[
          ((mod4Mask, xK_p), spawn "dmenu_run")
          {-((mod4Mask, xK_p), spawn "~/.config/dmenu/dmenu-bind.sh")-}
        {-, ((mod4Mask, xK_p), spawn "gvim ~/.config/dmenu/dmenu-bind.sh") -- edit dmenu-}
        , ((mod4Mask, xK_a), spawn "audacity")
        , ((mod4Mask, xK_b), spawn "firefox")
        , ((mod4Mask, xK_c), spawn "pidgin & skype")
        , ((mod4Mask, xK_f), spawn "pcmanfm")
        , ((mod4Mask, xK_g), spawn "gimp")
        , ((mod4Mask, xK_m), spawn "vlc")
        , ((mod4Mask, xK_n), sendMessage ToggleStruts) -- toggle panel visability.
        , ((mod4Mask .|. controlMask .|. mod1Mask, xK_n), spawn "gvim ~/.config/tint2/tint2rc") -- edit panel config
        , ((mod4Mask .|. mod1Mask, xK_n), spawn "pkill tint2 && tint2") -- restart panel.
        , ((mod4Mask .|. shiftMask, xK_p), spawn "gksudo gparted")
        {-, ((mod4Mask, xK_p), spawn "gksudo synaptic")-}
        , ((mod4Mask, xK_q), spawn "xmonad --restart")
        , ((mod4Mask .|. controlMask .|. mod1Mask, xK_x), spawn "gedit ~/.xmonad/xmonad.hs") -- edit xmonad config
        , ((0, xK_Print), spawn "scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/images/screenshots/ &amp; gpicview ~/images/screenshots/$f'")
        ]
