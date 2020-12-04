module Ant.Menu exposing (initMenuItem, selected, initMenu, initSubMenu, initItemGroup, pushItem, pushSubMenu, pushItemGroup, pushItemToSubMenu, pushItemGroupToSubMenu, pushSubMenuToSubMenu, pushItemToItemGroup, toHtml, Menu, SubMenu, ItemGroup, MenuMode(..))

{-| Primitives for creating Menus.

This module comes with three big menu primitives:

  - Menu: The main container of your menu
  - SubMenu: A menu within your menu. SubMenu's are collapsable.
  - ItemGroup: A grouping of items with a label.

The overarching idea in this module is that you start with the inner items of your menu, constructing it piece by piece, until you have
all of the elements of the Menu. Once that is done, then you can create your Menu and turn it into `Html msg`.

A good example can be found in this project's [showcase](https://github.com/supermacro/elm-antd/blob/master/showcase/src/elm/Router.elm#L277).

@docs initMenuItem, selected, initMenu, initSubMenu, initItemGroup, pushItem, pushSubMenu, pushItemGroup, pushItemToSubMenu, pushItemGroupToSubMenu, pushSubMenuToSubMenu, pushItemToItemGroup, toHtml, Menu, SubMenu, ItemGroup, MenuMode

-}

import Ant.Internals.Typography exposing (fontList, textColorRgba)
import Ant.Theme exposing (Theme, defaultTheme)
import Ant.Typography.Text as Text
import Color.Convert exposing (colorToHexWithAlpha)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (style)
import Html.Styled as Styled exposing (fromUnstyled, toUnstyled)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Events exposing (onClick)


type alias MenuItemState =
    { selected : Bool
    , disabled : Bool
    , title : Maybe String
    }


defaultMenuItemState : MenuItemState
defaultMenuItemState =
    { selected = False
    , disabled = False
    , title = Nothing
    }


type MenuItem msg
    = MenuItem msg MenuItemState (Html msg)


{-| Given a `msg` and some contents, create a menu item
-}
initMenuItem : msg -> Html msg -> MenuItem msg
initMenuItem msg =
    MenuItem msg defaultMenuItemState


{-| Mark the menu item as selected
-}
selected : MenuItem msg -> MenuItem msg
selected (MenuItem msg currentState contents) =
    let
        newState =
            { currentState | selected = True }
    in
    MenuItem msg newState contents


{-| This type defines how the menu will be positioned
-}
type MenuMode
    = Vertical
    | Horizontal
    | Inline


type alias MenuConfig =
    { mode : MenuMode
    , verticalOrInlineCollapsed : Bool
    , theme : Theme
    }


defaultMenuConfig : MenuConfig
defaultMenuConfig =
    { mode = Vertical
    , verticalOrInlineCollapsed = False
    , theme = defaultTheme
    }


type MenuContent msg
    = Item (MenuItem msg)
    | Sub (SubMenu msg)
    | Group (ItemGroup msg)


{-| Represents a Menu, its configuration and the Menu's content
-}
type Menu msg
    = Menu MenuConfig (List (MenuContent msg))



-------------------------------------------
-------------------------------------------
------ Menu Logic


{-| Initialize a menu with no content. This is useful when constructing your menu using folds.
-}
initMenu : Menu msg
initMenu =
    Menu defaultMenuConfig []


{-| push a menu item to the end of the menu
-}
pushItem : MenuItem msg -> Menu msg -> Menu msg
pushItem newMenuItem (Menu config currentMenuList) =
    Menu config (currentMenuList ++ [ Item newMenuItem ])


{-| push a SubMenu to the end of the menu
-}
pushSubMenu : SubMenu msg -> Menu msg -> Menu msg
pushSubMenu subMenu (Menu config currentMenuList) =
    Menu config (currentMenuList ++ [ Sub subMenu ])


{-| push a item group to the end of the menu
-}
pushItemGroup : ItemGroup msg -> Menu msg -> Menu msg
pushItemGroup itemGroup (Menu config currentMenuList) =
    Menu config (currentMenuList ++ [ Group itemGroup ])



-------------------------------------------
-------------------------------------------
------ SubMenu Logic


type alias SubMenuState =
    { opened : Bool
    , disabled : Bool
    , title : Maybe String
    }


defaultSubMenuState : SubMenuState
defaultSubMenuState =
    { opened = False
    , disabled = False
    , title = Nothing
    }


type SubMenuContent msg
    = SubMenuItem (MenuItem msg)
    | SubMenuGroup (ItemGroup msg)
    | NestedSubMenu (SubMenu msg)


{-| Represents a sub-menu, and the submenu's associated configuration / state, as well as the menu's contents
-}
type SubMenu msg
    = SubMenu SubMenuState (List (SubMenuContent msg))


{-| Create an empty nested menu
-}
initSubMenu : SubMenu msg
initSubMenu =
    SubMenu defaultSubMenuState []


{-| Push a MenuItem to the end of the SubMenu
-}
pushItemToSubMenu : MenuItem msg -> SubMenu msg -> SubMenu msg
pushItemToSubMenu newMenuItem (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ SubMenuItem newMenuItem ])


{-| Push a SubMenu to the end of the SubMenu
-}
pushSubMenuToSubMenu : SubMenu msg -> SubMenu msg -> SubMenu msg
pushSubMenuToSubMenu childSubMenu (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ NestedSubMenu childSubMenu ])


{-| Push a Item Group to the end of the SubMenu
-}
pushItemGroupToSubMenu : ItemGroup msg -> SubMenu msg -> SubMenu msg
pushItemGroupToSubMenu itemGroup (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ SubMenuGroup itemGroup ])



-------------------------------------------
-------------------------------------------
------ ItemGroup Logic


type alias ItemGroupTitle =
    String


{-| Represents a grouping of MenuItems
-}
type ItemGroup msg
    = ItemGroup ItemGroupTitle (List (MenuItem msg))


{-| Initialize a item group with a set of associated MenuItem's
-}
initItemGroup : ItemGroupTitle -> List (MenuItem msg) -> ItemGroup msg
initItemGroup =
    ItemGroup


{-| Add a MenuItem to the end of the ItemGroup
-}
pushItemToItemGroup : MenuItem msg -> ItemGroup msg -> ItemGroup msg
pushItemToItemGroup newItem (ItemGroup title currentItemGroupList) =
    ItemGroup title (currentItemGroupList ++ [ newItem ])



-------------------------------------------
-------------------------------------------
------ View Logic


menuItemColor : Style
menuItemColor =
    let
        { r, g, b, a } =
            textColorRgba
    in
    color (rgba r g b a)


viewMenuItem : Theme -> MenuItem msg -> Styled.Html msg
viewMenuItem theme (MenuItem msg state itemContents) =
    let
        primaryColor =
            theme.colors.primary
                |> colorToHexWithAlpha
                |> hex

        selectedItemStyles =
            if state.selected then
                batch
                    [ color primaryColor
                    , backgroundColor (hex "#e6f7ff")
                    , borderRight3 (px 3) solid primaryColor
                    ]

            else
                batch
                    [ menuItemColor
                    , hover
                        [ color primaryColor ]
                    ]
    in
    Styled.li
        [ onClick msg
        , css
            [ selectedItemStyles
            , fontFamilies fontList
            , fontSize (px 14)
            , paddingLeft (px 40)
            , paddingRight (px 16)
            , marginTop (px 4)
            , marginBottom (px 8)
            , lineHeight (px 40)
            , transition [ Css.Transitions.color 250 ]
            , cursor pointer
            ]
        ]
        [ fromUnstyled itemContents ]


type alias SharedStyles =
    List ( String, String )


sharedUnorderedListStyles : SharedStyles
sharedUnorderedListStyles =
    [ ( "padding-left", "0" )
    , ( "list-style-type", "none" )
    ]


applySharedStyles : (String -> String -> attribute) -> SharedStyles -> List attribute
applySharedStyles fn =
    List.map (\( property, value ) -> fn property value)


viewItemGroup : Theme -> ItemGroup msg -> Styled.Html msg
viewItemGroup theme (ItemGroup title menuItems) =
    let
        itemGroupLabel =
            fromUnstyled
                (Text.text title
                    |> Text.withType Text.Secondary
                    |> Text.toHtml
                )
    in
    Styled.div []
        [ Styled.div
            [ css
                [ padding4 (px 8) (px 16) (px 8) (px 32) ]
            ]
            [ itemGroupLabel ]
        , Styled.ul (applySharedStyles Attr.style sharedUnorderedListStyles) <|
            List.map (viewMenuItem theme) menuItems
        ]


viewSubMenuContent : Theme -> SubMenuContent msg -> Styled.Html msg
viewSubMenuContent theme subMenuContent =
    case subMenuContent of
        SubMenuItem menuItem ->
            viewMenuItem theme menuItem

        SubMenuGroup itemGroup ->
            viewItemGroup theme itemGroup

        NestedSubMenu subMenu ->
            viewSubMenu theme subMenu


viewSubMenu : Theme -> SubMenu msg -> Styled.Html msg
viewSubMenu theme (SubMenu _ subMenuContentList) =
    Styled.li []
        [ Styled.ul (applySharedStyles Attr.style sharedUnorderedListStyles) <|
            List.map (viewSubMenuContent theme) subMenuContentList
        ]


viewMenuContent : Theme -> MenuContent msg -> Styled.Html msg
viewMenuContent theme menuContent =
    case menuContent of
        Item menuItem ->
            viewMenuItem theme menuItem

        Sub subMenu ->
            viewSubMenu theme subMenu

        Group itemGroup ->
            viewItemGroup theme itemGroup


{-| Turn your Menu into a `Html msg`
-}
toHtml : Menu msg -> Html msg
toHtml (Menu config menuContents) =
    ul
        (style "border-right" "1px solid #f0f0f0"
            :: applySharedStyles style sharedUnorderedListStyles
        )
        (List.map (toUnstyled << viewMenuContent config.theme) menuContents)
