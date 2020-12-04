module Routes.Home exposing (homePage)

{-| This module represents the Home / Landing page content when a user visits the root path of the URL
-}

import Html.Styled exposing (Html, div, p, span, text)
import UI.Footer exposing (pushDown)
import UI.Typography exposing (SubHeadingOptions(..), codeText, documentationHeading, documentationSubheading, documentationText, documentationUnorderedList, internalLink, link)


homePage : Html msg
homePage =
    div
        []
        [ documentationHeading "Elm Ant Design"
        , documentationText <| text "Welcome to the home of ambitious Elm applications!"
        , documentationText <| text "Elm Ant Design aims to eventually attain 100% feature parity with the React implementation of Ant Design. Currently, there are only a few components that are partially implemented. See the list below for an up-to-date list of which components are available to be used within supermacro/elm-antd."
        , documentationSubheading WithoutAnchorLink "Getting Started"
        , documentationText <| codeText "elm install supermacro/elm-antd"
        , documentationSubheading WithoutAnchorLink "API Docs"
        , link "https://package.elm-lang.org/packages/supermacro/elm-antd/latest/" "package.elm-lang.org"
        , documentationSubheading WithoutAnchorLink "Currently Implemented Components"
        , documentationUnorderedList
            [ internalLink "/components/alert" "Alert"
            , internalLink "/components/button" "Button"
            , internalLink "/components/checkbox" "Checkbox"
            , internalLink "/components/divider" "Divider"
            , internalLink "/components/form" "Form"
            , link "https://github.com/supermacro/elm-antd/issues/26" "Icon"
            , internalLink "/components/input" "Input"
            , link "https://github.com/supermacro/elm-antd/issues/23" "Layout"
            , link "https://github.com/supermacro/elm-antd/issues/25" "Menu"
            , internalLink "/components/space" "Space"
            , internalLink "/components/tooltip" "Tooltip"
            , internalLink "/components/typography" "Typography"
            ]
        , documentationSubheading WithoutAnchorLink "Theming"
        , documentationText <|
            div []
                [ p []
                    [ text "Elm Antd has recently released a theming api! "
                    , text "Visit the "
                    , internalLink "/components/button" "Button"
                    , text " or the "
                    , internalLink "/components/alert" "Alert"
                    , text " pages to play around with the theming color picker that is available at the footer of every page. "
                    , text "Visit the "
                    , link "https://package.elm-lang.org/packages/supermacro/elm-antd/latest/Ant-Theme" "Ant.Theme"
                    , text " docs to learn about the theming api."
                    ]
                ]
        , documentationSubheading WithoutAnchorLink "Early Development Notice"
        , documentationText <| text "Currently Elm Antd is in very early development with only a few components implemented, and bare-bones documentation."
        , documentationText <| text "Do you want to help out and make Elm Ant Design the most comprehensive and feature-full UI library in the universe?"
        , documentationText <|
            span []
                [ text "Great! Check out the issues page and the contributing guide at "
                , link "https://github.com/supermacro/elm-antd#contributing" "github"
                ]
        , pushDown
        ]
