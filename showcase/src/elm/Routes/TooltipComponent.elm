module Routes.TooltipComponent exposing (Model, Msg, route)

import Css exposing (displayFlex)
import Html.Styled as Styled exposing (div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css)
import Routes.TooltipComponent.BasicExample as BasicExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


title : String
title =
    "Tooltip"


type alias StatelessDemo =
    Container.Model () Never


type alias Model =
    { basicExample : StatelessDemo
    , version : String 
    }


type DemoBox
    = Basic


type Msg
    = DemoBoxMsg DemoBox (Container.Msg Never)
    | ExampleSourceCodeLoaded (List SourceCode)


route : DocumentationRoute Model Msg
route =
    { title = title
    , category = DataDisplay
    , view = view
    , update = update
    , initialModel =
        \v -> { basicExample = Container.initModel "BasicExample.elm"
            , version = v
        }
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demoBox demoboxMsg ->
            case demoBox of
                Basic ->
                    let
                        ( basicModel, basicCmd ) =
                            Container.update (DemoBoxMsg Basic) demoboxMsg model.basicExample
                    in
                    ( { model | basicExample = basicModel }, basicCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode model.version examplesSourceCode model.basicExample
              }
            , Cmd.none
            )


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "The simplest usage."
            , ellieDemo = "https://ellie-app.com/9mjyZ2xHwN9a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg Basic)
        model.basicExample
        (\_ -> BasicExample.example)
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading title
        , documentationText <| text "A simple text popup tip."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "The tip is shown on mouse enter, and is hidden on mouse leave. The Tooltip doesn't support complex text or operations."
            , text "To provide an explanation of a button/text/operation. It's often used instead of the html title attribute."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div []
            [ div [] [ basicExample model ], div [] [] ]
        ]
