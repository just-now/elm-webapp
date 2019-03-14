module Main exposing (main)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Time



type alias Model = { timer : Int , interval : Int, stopped : Bool}

init : Model
init = { timer = 0, interval = 100, stopped = False }

type Msg
  = TimeUpdate Time.Posix
  | ClickReset
  | ClickToggle
  | ChangeSelection String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate t -> (if not model.stopped && model.timer < 100
                         then
                             { model | timer = model.timer + 1 }
                         else
                             model, Cmd.none)
        ClickReset -> ({ model | timer = 0 }, Cmd.none)
        ClickToggle -> ({ model | stopped = not model.stopped } , Cmd.none)
        ChangeSelection i -> ({ model | interval = Maybe.withDefault 200 <| String.toInt i }, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ text "Progress"
    , progress [ value (String.fromInt model.timer), Html.Attributes.max "100"] []
    , input [ type_ "range", Html.Attributes.min "100", Html.Attributes.max "1000", step "100", onInput ChangeSelection] []
    , button [ onClick ClickReset ] [ text "Reset" ]
    , button [ onClick ClickToggle ] [ text "Toggle" ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (toFloat model.interval) TimeUpdate


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
