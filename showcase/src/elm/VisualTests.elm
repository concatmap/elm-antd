module VisualTests exposing (main)

{-| This is the entrypoint for the application in "Visual Test" mode

This app is controlled via the URL:

  - <http://localhost:3000?component=SimpleButton>

Given a `component` query param, render the associated component

-}

import Ant.Button as Btn exposing (ButtonType(..), button)
import Ant.Css exposing (createThemedStyles)
import Ant.Divider as Divider
import Ant.Icons as Icons exposing (Icon, searchOutlined)
import Ant.Input as Input exposing (InputSize)
import Ant.Theme exposing (defaultTheme)
import Ant.Typography as Heading exposing (Level(..), title)
import Browser
import Browser.Navigation as Nav
import Css exposing (height, vh)
import Css.Global exposing (global, selector)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Styled exposing (toUnstyled)
import Url exposing (Url)
import Url.Parser as P exposing ((<?>), Parser, parse)
import Url.Parser.Query as Query


type alias Model =
    { component : Component
    , label : String
    }


type Msg
    = UrlChanged Url
    | LinkClicked Browser.UrlRequest
    | InputMsg Input.Model


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias ButtonConfig =
    { type_ : ButtonType
    , disabled : Bool
    , icon : Maybe (Icon Never)
    }


type alias TypographyConfig =
    { level : Heading.Level }


type alias DividerConfig =
    { line : Divider.Line
    , orientation : Divider.Orientation
    , type_ : Divider.Type
    , textStyle : Divider.TextStyle
    , label : Maybe String
    }


type alias InputConfig =
    { size : InputSize
    }


type Component
    = Button ButtonConfig
    | Typography TypographyConfig
    | Divider DividerConfig
    | Input InputConfig


type RawComponent
    = RawComponent (Maybe String)


{-| Represents the set of components that are known and properly configured to be tested
-}
registeredComponents : List ( String, Component )
registeredComponents =
    -- Buttons
    [ ( "SimpleButton", Button { type_ = Default, disabled = False, icon = Nothing } )
    , ( "PrimaryButton", Button { type_ = Primary, disabled = False, icon = Nothing } )
    , ( "DashedButton", Button { type_ = Dashed, disabled = False, icon = Nothing } )
    , ( "TextButton", Button { type_ = Text, disabled = False, icon = Nothing } )
    , ( "LinkButton", Button { type_ = Link, disabled = False, icon = Nothing } )
    , ( "DisabledPrimaryButton", Button { type_ = Primary, disabled = True, icon = Nothing } )
    , ( "PrimaryButtonWithIcon", Button { type_ = Primary, disabled = False, icon = Just searchOutlined } )

    -- Inputs
    , ( "SimpleInput", Input { size = Input.Default } )

    -- Headings
    , ( "SimpleHeading", Typography { level = H1 } )

    -- Dividers
    , ( "SimpleDivider", Divider { line = Divider.Solid, orientation = Divider.Center, type_ = Divider.Horizontal, textStyle = Divider.Plain, label = Nothing } )
    , ( "DashedDivider", Divider { line = Divider.Dashed, orientation = Divider.Center, type_ = Divider.Horizontal, textStyle = Divider.Plain, label = Nothing } )
    , ( "VerticalDivider", Divider { line = Divider.Solid, orientation = Divider.Center, type_ = Divider.Vertical, textStyle = Divider.Plain, label = Nothing } )
    ]


getRegisteredComponentFromLabel : String -> Maybe ( String, Component )
getRegisteredComponentFromLabel searchString =
    List.filter (\( label, _ ) -> label == searchString) registeredComponents
        |> List.head


intoComponent : RawComponent -> Component
intoComponent (RawComponent maybeStr) =
    let
        defaultComponent =
            Button { type_ = Default, disabled = False, icon = Nothing }
    in
    case maybeStr of
        Just componentQueryParamValue ->
            getRegisteredComponentFromLabel componentQueryParamValue
                |> Maybe.map (\( _, component ) -> component)
                |> Maybe.withDefault defaultComponent

        Nothing ->
            defaultComponent


componentParser : Parser (RawComponent -> a) a
componentParser =
    P.map RawComponent (P.top <?> Query.string "component")


getComponentFromUrl : Url -> Model
getComponentFromUrl url =
    let
        maybeRawComponent =
            parse componentParser url

        rawComponent =
            Maybe.withDefault (RawComponent <| Just "SimpleButton") maybeRawComponent

        componentLabel =
            case rawComponent of
                RawComponent (Just componentQueryParamValue) ->
                    getRegisteredComponentFromLabel componentQueryParamValue
                        |> Maybe.map (\( label, _ ) -> label)
                        |> Maybe.withDefault "<<default>>"

                RawComponent Nothing ->
                    "<<default>>"
    in
    { component = intoComponent rawComponent
    , label = componentLabel
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url _ =
    ( getComponentFromUrl url, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


centerContents : Html msg -> Html msg
centerContents children =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        , style "height" "100%"
        ]
        [ children ]


buildComponent : Component -> Html Msg
buildComponent component =
    case component of
        Button buttonConfig ->
            let
                baseButton =
                    button "elm"
                        |> Btn.withType buttonConfig.type_
                        |> Btn.disabled buttonConfig.disabled
            in
            case buttonConfig.icon of
                Nothing ->
                    Btn.toHtml baseButton

                Just icon ->
                    baseButton
                        |> Btn.withIcon icon
                        |> Btn.toHtml
                        |> Html.map never

        Typography typographyConfig ->
            title "elm"
                |> Heading.level typographyConfig.level
                |> Heading.toHtml

        Divider dividerConfig ->
            let
                divider =
                    Divider.divider
                        |> Divider.withLine dividerConfig.line
                        |> Divider.withType dividerConfig.type_
                        |> Divider.withOrientation dividerConfig.orientation
                        |> Divider.withTextStyle dividerConfig.textStyle
                        |> Divider.toHtml

                loremIpsum =
                    text "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            in
            div []
                [ loremIpsum
                , divider
                , loremIpsum
                ]

        Input inputConfig ->
            let
                input =
                    Input.input InputMsg
                        |> Input.withSize inputConfig.size
                        |> Input.withPlaceholder "Placeholder"
                        |> Input.toHtml Input.init
            in
            div [ style "max-width" "200px" ] [ input ]


view : Model -> { title : String, body : List (Html Msg) }
view { component, label } =
    let
        antdGlobalStyles =
            createThemedStyles defaultTheme

        content =
            buildComponent component

        appStyles =
            global
                [ selector "html, body"
                    [ height (vh 100) ]
                ]
    in
    { title = "Visual Tests - " ++ label
    , body =
        [ antdGlobalStyles
        , toUnstyled appStyles
        , centerContents content
        ]
    }
