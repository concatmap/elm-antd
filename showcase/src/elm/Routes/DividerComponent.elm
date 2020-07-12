module Routes.DividerComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
import Html.Styled.Attributes exposing (css)
import Routes.DividerComponent.HorizontalExample as HorizontalExample
import Routes.DividerComponent.TextWithoutHeadingExample as TextWithoutHeadingExample
import Routes.DividerComponent.VerticalExample as VerticalExample
import Routes.DividerComponent.WithTitleExample as WithTitleExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( codeText
        , documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute)


horizontalExampleStr : String
horizontalExampleStr =
    """module Routes.DividerComponent.HorizontalExample exposing (example)

import Ant.Divider as Divider exposing (divider)
import Ant.Typography.Text as Text
import Html exposing (Html, text)
import Html exposing (Html, div, span)
import Html.Styled as H exposing (text, toUnstyled, fromUnstyled)


example : Html msg
example =
    let
      basicDivider =
        Divider.divider
          |> Divider.toHtml

      dashedDivdier =
        Divider.divider
          |> Divider.withLine Divider.Dashed
          |> Divider.toHtml

      loremIpsum =
        Text.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo."
          |> Text.toHtml
          
    in
    div []
      [ loremIpsum
      , basicDivider
      , loremIpsum
      , dashedDivdier
      , loremIpsum
      ]"""


textWithoutHeadingExampleStr : String
textWithoutHeadingExampleStr =
    """module Routes.DividerComponent.TextWithoutHeadingExample exposing (example)

import Ant.Divider as Divider
import Ant.Typography.Text as Text
import Html exposing (Html, text)
import Html exposing (Html, div, span)
import Html.Styled as H exposing (text, toUnstyled, fromUnstyled)


example : Html msg
example =
    let
      dividerCenter =
        Divider.divider
          |> Divider.withLabel "Center"
          |> Divider.withOrientation Divider.Center
          |> Divider.toHtml

      dividerLeft =
        Divider.divider
          |> Divider.withLabel "Left"
          |> Divider.withOrientation Divider.Left
          |> Divider.toHtml

      dividerRight =
        Divider.divider
          |> Divider.withLabel "Right"
          |> Divider.withOrientation Divider.Right
          |> Divider.toHtml

      loremIpsum =
        Text.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo."
          |> Text.toHtml
          
    in
    div []
      [ loremIpsum
      , dividerCenter
      , loremIpsum
      , dividerLeft
      , loremIpsum
      , dividerRight
      , loremIpsum
      ]"""


withTitleExampleStr : String
withTitleExampleStr =
    """module Routes.DividerComponent.WithTitleExample exposing (example)

import Ant.Divider as Divider
import Ant.Typography.Text as Text
import Html exposing (Html, text)
import Html exposing (Html, div, span)
import Html.Styled as H exposing (text, toUnstyled, fromUnstyled)


example : Html msg
example =
    let
      dividerCenter =
        Divider.divider
          |> Divider.withLabel "Center"
          |> Divider.withOrientation Divider.Center
          |> Divider.withTextStyle Divider.Heading
          |> Divider.toHtml

      dividerLeft =
        Divider.divider
          |> Divider.withLabel "Left"
          |> Divider.withOrientation Divider.Left
          |> Divider.withTextStyle Divider.Heading
          |> Divider.toHtml

      dividerRight =
        Divider.divider
          |> Divider.withLabel "Right"
          |> Divider.withOrientation Divider.Right
          |> Divider.withTextStyle Divider.Heading
          |> Divider.toHtml

      loremIpsum =
        Text.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo."
          |> Text.toHtml
          
    in
    div []
      [ loremIpsum
      , dividerCenter
      , loremIpsum
      , dividerLeft
      , loremIpsum
      , dividerRight
      , loremIpsum
      ]"""


verticalExampleStr : String
verticalExampleStr =
    """"""


type alias Model =
    { horizontalExample : Container.Model
    , textWithoutHeadingExample : Container.Model
    , withTitleExample : Container.Model
    , verticalExample : Container.Model
    }


type DemoBox
    = HorizontalExample
    | TextWithoutHeadingExample
    | WithTitleExample
    | VerticalExample


type Msg
    = DemoBoxMsg DemoBox Container.Msg
    | SourceCopiedToClipboard DemoBox


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DemoBoxMsg demobox demoboxMsg ->
            case demobox of
                HorizontalExample ->
                    let
                        ( horizontalExampleModel, horizontalExampleCdm ) =
                            Container.update demoboxMsg model.horizontalExample
                    in
                    ( { model | horizontalExample = horizontalExampleModel }, horizontalExampleCdm )

                TextWithoutHeadingExample ->
                    let
                        ( textWithoutHeadingExampleModel, textWithoutHeadingExampleCmd ) =
                            Container.update demoboxMsg model.textWithoutHeadingExample
                    in
                    ( { model | textWithoutHeadingExample = textWithoutHeadingExampleModel }, textWithoutHeadingExampleCmd )

                WithTitleExample ->
                    let
                        ( withTitleExampleModel, withTitleExampleCmd ) =
                            Container.update demoboxMsg model.withTitleExample
                    in
                    ( { model | withTitleExample = withTitleExampleModel }, withTitleExampleCmd )

                VerticalExample ->
                    let
                        ( verticalExampleModel, verticalExampleCmd ) =
                            Container.update demoboxMsg model.verticalExample
                    in
                    ( { model | verticalExample = verticalExampleModel }, verticalExampleCmd )

        SourceCopiedToClipboard demobox ->
            ( model, Cmd.none )


route : DocumentationRoute Model Msg
route =
    { title = "Divider"
    , category = Layout
    , view = view
    , update = update
    , initialModel =
        { horizontalExample = { sourceCodeVisible = False, sourceCode = horizontalExampleStr }
        , textWithoutHeadingExample = { sourceCodeVisible = False, sourceCode = textWithoutHeadingExampleStr }
        , withTitleExample = { sourceCodeVisible = False, sourceCode = withTitleExampleStr }
        , verticalExample = { sourceCodeVisible = False, sourceCode = verticalExampleStr }
        }
    }


horizontalExample : Model -> Styled.Html Msg
horizontalExample model =
    let
        styledHorizontalExampleContents =
            fromUnstyled HorizontalExample.example

        metaInfo =
            { title = "Horizontal"
            , content = "Divider is \"horizontal\" by default. You can add text within Divider."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = horizontalExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledHorizontalExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.horizontalExample
        |> Styled.map (DemoBoxMsg HorizontalExample)


textWithoutHeadingExample : Model -> Styled.Html Msg
textWithoutHeadingExample model =
    let
        styleTextWithoutHeadingExampleContents =
            fromUnstyled TextWithoutHeadingExample.example

        metaInfo =
            { title = "Text without heading style"
            , content = "You can use non-heading style of divider text by setting Plain textStyle"
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = textWithoutHeadingExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styleTextWithoutHeadingExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.textWithoutHeadingExample
        |> Styled.map (DemoBoxMsg TextWithoutHeadingExample)


withTitleExample : Model -> Styled.Html Msg
withTitleExample model =
    let
        styleWithTitleExampleContents =
            fromUnstyled WithTitleExample.example

        metaInfo =
            { title = "Divider with title"
            , content = "Divider with inner title, use \"withOrientation\" to align it."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = withTitleExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styleWithTitleExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.withTitleExample
        |> Styled.map (DemoBoxMsg WithTitleExample)


verticalExample : Model -> Styled.Html Msg
verticalExample model =
    let
        styleVerticalExampleContents =
            fromUnstyled VerticalExample.example

        metaInfo =
            { title = "Vertical"
            , content = "Use \"withType Vertical\" make it vertical."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = verticalExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styleVerticalExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.verticalExample
        |> Styled.map (DemoBoxMsg VerticalExample)


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading "Divider"
        , documentationText <| text "A divider line separates different content."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "Divide sections of article."
            , text "Divide inline text and links such as the operation column of table."
            , text "Dashed button: used for adding action commonly."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ horizontalExample model ]
            , div [ css [ maxWidth (pct 45) ] ] [ withTitleExample model ]
            ]
        , div [ css [ displayFlex ] ]
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ textWithoutHeadingExample model ]
            , div [ css [ maxWidth (pct 45) ] ] [ verticalExample model ]
            ]
        ]
