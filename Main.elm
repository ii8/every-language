module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (onClick, onInput, onMouseEnter, onMouseLeave)
import Url
import Url.Builder as Q
import Dict exposing (Dict)

import Lang exposing (Parameter, Language)
import Bench


type Trilean
  = DoWant
  | DontWant
  | DontCare


-- MAIN

main : Program {} Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }


-- MODEL

type alias Query =
  { spec : List Lang.Specification
  , status : List Lang.Status
  , impl : Maybe Lang.Implementation
  , domain: Maybe Lang.Domain
  , platform : List Lang.Platform
  , typing : List Lang.Typing
  , safety : List Lang.Safety
  , mm : List Lang.MemoryManagement
  , everything : List Lang.Everything
  , paradigms : List Lang.Paradigm
  , pe : List Lang.Parallelism
  , features : Dict String Trilean
  , concurrency : Dict String Trilean
  , runtime : Dict String Trilean
  , ortho : List Lang.Orthogonality
  , helloworld : Int
  }

emptyQuery =
  { spec = []
  , status = []
  , impl = Nothing
  , domain = Nothing
  , platform = []
  , typing = []
  , safety = []
  , mm = []
  , everything = []
  , paradigms = []
  , pe = []
  , features = Dict.empty
  , concurrency = Dict.empty
  , runtime = Dict.empty
  , ortho = []
  , helloworld = 1000
  }

encodeQuery : Query -> List Q.QueryParameter
encodeQuery q =
  [ Q.int "hi" 2 ]

type alias Model =
  { key : Nav.Key
  , url : Url.Url
  , tip : String
  , query : Query
  , language : Maybe Language
  }

init : {} -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
  ( { key = key
    , url = url
    , tip = "every programming language"
    , query = emptyQuery
    , language = Nothing
    }
  , Cmd.none
  )

defaultTooltip = "( ͡❛ ͜ʖ ͡❛)"


-- UPDATE

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | Tooltip String
  | ShowLanguage Language
  | ToggleSpec Lang.Specification
  | ToggleStatus Lang.Status
  | ToggleImpl Lang.Implementation
  | SelectDomain Lang.Domain
  | TogglePlatform Lang.Platform
  | ToggleTyping Lang.Typing
  | ToggleSafety Lang.Safety
  | ToggleMem Lang.MemoryManagement
  | ToggleEverything Lang.Everything
  | ToggleParadigm Lang.Paradigm
  | TogglePE Lang.Parallelism
  | ToggleFeature Lang.Feature
  | ToggleConcurrency Lang.Concurrency
  | ToggleRuntime Lang.Runtime
  | ToggleOrtho Lang.Orthogonality
  | DragHelloWorld Int

select : a -> Maybe a -> Maybe a
select o mo = if mo == Just o then Nothing else Just o 

toggle : a -> List a -> List a
toggle x xs =
  case List.member x xs of
    True -> List.filter (\y -> y /= x) xs
    False -> x :: xs

toggle3 : String -> Dict String Trilean -> Dict String Trilean
toggle3 opt m =
  Dict.insert opt (case Maybe.withDefault DontCare (Dict.get opt m) of
    DoWant -> DontWant
    DontWant -> DontCare
    DontCare -> DoWant) m

query : Model -> (Query -> Query) -> ( Model, Cmd Msg )
query m f =
  ( { m | query = f m.query }
  , Cmd.none
  )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }, Cmd.none )
    Tooltip tip ->
      ( { model | tip = tip }, Cmd.none )
    ShowLanguage l ->
      ( { model | language = Just l }, Cmd.none )
    ToggleSpec o        -> query model (\q -> { q | spec        = toggle o q.spec })
    ToggleStatus o      -> query model (\q -> { q | status      = toggle o q.status })
    ToggleImpl o        -> query model (\q -> { q | impl        = select o q.impl })
    SelectDomain o      -> query model (\q -> { q | domain      = select o q.domain })
    TogglePlatform o    -> query model (\q -> { q | platform    = toggle o q.platform })
    ToggleTyping o      -> query model (\q -> { q | typing      = toggle o q.typing })
    ToggleSafety o      -> query model (\q -> { q | safety      = toggle o q.safety })
    ToggleMem o         -> query model (\q -> { q | mm          = toggle o q.mm })
    ToggleEverything o  -> query model (\q -> { q | everything  = toggle o q.everything })
    ToggleParadigm o    -> query model (\q -> { q | paradigms   = toggle o q.paradigms })
    TogglePE o          -> query model (\q -> { q | pe          = toggle o q.pe })
    ToggleFeature o     -> query model (\q -> { q | features    = toggle3 (Lang.featName o) q.features })
    ToggleConcurrency o -> query model (\q -> { q | concurrency = toggle3 (Lang.concurrencyName o) q.concurrency })
    ToggleRuntime o     -> query model (\q -> { q | runtime     = toggle3 (Lang.runtimeName o) q.runtime })
    ToggleOrtho o       -> query model (\q -> { q | ortho       = toggle o q.ortho })
    DragHelloWorld i    -> query model (\q -> { q | helloworld  = i })


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


-- VIEW

view : Model -> Browser.Document Msg
view m =
  { title = "Every Language"
  , body =
    [ div
      [ class "flex flex-col min-h-screen"
      ]
      [ header []
        [ h1 [ class "p-12 md:p-20 text-center" ]
          [ a [ href "", class "text-3xl font-mono text-yellow-100/75" ]
              [ text "every programming language" ]
          ]
        ]
      , div
        [ class "flex overflow-x-scroll py-3 gap-3 md:py-5"
        , class "bg-gradient-to-r from-blue-300/90 to-yellow-200/90 shadow-inset-y"
        ]
        [ div [ class "grow pl-1" ] [ ]
        , selectMaybe m.query.domain      Lang.domain      SelectDomain
        , selectList  m.query.typing      Lang.typing      ToggleTyping
        , selectList  m.query.safety      Lang.safety      ToggleSafety
        , selectList  m.query.mm          Lang.mm          ToggleMem
        , selectList  m.query.paradigms   Lang.paradigm    ToggleParadigm
        , selectDict  m.query.features    Lang.feat        ToggleFeature
        , selectDict  m.query.runtime     Lang.runtime     ToggleRuntime
        , range       m.query.helloworld "Hello World" "Size of a statically linked hello world executable" 0 1000 DragHelloWorld
        , selectMaybe m.query.impl        Lang.impl        ToggleImpl
        , selectList  m.query.pe          Lang.pe          TogglePE
        , selectDict  m.query.concurrency Lang.concurrency ToggleConcurrency
        , selectList  m.query.status      Lang.status      ToggleStatus
        , selectList  m.query.platform    Lang.platform    TogglePlatform
        , selectList  m.query.spec        Lang.spec        ToggleSpec
        , selectList  m.query.ortho       Lang.ortho       ToggleOrtho
        , selectList  m.query.everything  Lang.everything  ToggleEverything
        , div [ class "grow pr-1" ] [ ]
        ]
      , div [ class "flex justify-center" ]
        [ div
          [ class "bg-zinc-950 w-3/4 rounded-b-full text-center"
          ]
          [ span [ class "text-yellow-100/75 font-mono" ] [ text m.tip ]
          ]
        ]
      , div
        [ class "grow my-16 mx-12 md:mx-24 xl:mx-32 2xl:mx-48"
        , class "flex flex-col lg:flex-row justify-center gap-10"
        ]
        [ div [ class "basis-1/2 flex flex-col" ]
          [ div
            [ class "flex flex-wrap justify-center"
            , class "rounded-xl p-4 sm:p-8 md:p-14 min-w-fit min-h-[248px]"
            , class "bg-gradient-to-r from-blue-300/90 to-yellow-200/90 shadow-inset"
            , onMouseLeave (Tooltip defaultTooltip)
            ]
            (List.map (\l -> viewLogo (filter m.query l) l) Lang.langs)
          ]
        , div
          [ class "basis-1/2 flex justify-center gap-10"
          , class "rounded-xl p-4"
          , class "bg-gradient-to-r from-yellow-200/90 to-blue-300/90 shadow-inset"
          ]
          (case m.language of
            Just l -> [ viewInfo l ]
            Nothing -> [ ])
        ]
      , footer [ class "bg-zinc-950 p-4 shadow-inset-t" ]
        [ div [ class "grid grid-cols-3" ]
          [ div [] []
          , a [ href "https://github.com/ii8/every-language", class "m-auto w-12" ]
            [ img [ src "github-mark-white.svg" ] [ text "Github" ] ]
          , div [ class "m-auto text-neutral-700/50" ]
            [ text "Some language icons from "
            , a [ href "https://exercism.org/" ] [ text "Exercism" ]
            , text " under "
            , a [ href "https://creativecommons.org/licenses/by/3.0/" ] [ text "CC BY 3.0" ]
            ]
          ]
        ]
      ]
    ]
  }


-- VIEW Query

trileanStyle : Trilean -> Attribute msg
trileanStyle t = class <| case t of
  DoWant -> "bg-blue-600 hover:bg-blue-500"
  DontWant -> "bg-red-600 hover:bg-red-500"
  DontCare -> "bg-slate-600/50 hover:bg-slate-600"

booleanStyle : Bool -> Attribute msg
booleanStyle b = case b of
  True -> trileanStyle DoWant
  False -> trileanStyle DontCare

optionMaybeStyle : Maybe a -> a -> Attribute msg
optionMaybeStyle m opt = booleanStyle (m == Just opt)

optionListStyle : List a -> a -> Attribute msg
optionListStyle m opt = booleanStyle (List.member opt m)

optionDictStyle : Dict String Trilean -> String -> Attribute msg
optionDictStyle m opt = trileanStyle (Maybe.withDefault DontCare (Dict.get opt m))

option : Attribute Msg -> (a -> String) -> (a -> String) -> (a -> Msg) -> a -> Html Msg
option style name tip msg opt =
  button
    [ onClick (msg opt)
    , onMouseEnter (Tooltip (tip opt))
    , style
    , class "py-1 px-3 hover:shadow-button"
    ]
    [ text (name opt) ]

optionMaybe : Maybe a -> (a -> String) -> (a -> String) -> (a -> Msg) -> a -> Html Msg
optionMaybe m name tip msg opt = option (optionMaybeStyle m opt) name tip msg opt

optionList : List a -> (a -> String) -> (a -> String) -> (a -> Msg) -> a -> Html Msg
optionList m name tip msg opt = option (optionListStyle m opt) name tip msg opt

optionDict : Dict String Trilean -> (a -> String) -> (a -> String) -> (a -> Msg) -> a -> Html Msg
optionDict m name tip msg opt = option (optionDictStyle m (name opt)) name tip msg opt

paramStyle : String -> List (Attribute Msg)
paramStyle tip =
  [ class "flex-none py-3 px-4 shadow-inset3 gap-2 bg-slate-900 rounded-lg"
  , class "flex flex-col w-48 h-80 overflow-y-scroll"
  , onMouseEnter (Tooltip tip)
  , onMouseLeave (Tooltip defaultTooltip)
  ]

paramTitle : String -> String -> Html Msg
paramTitle t tip =
  span
    [ class "text-slate-200 text-center font-mono"
    , onMouseEnter (Tooltip tip)
    ]
    [ text t ]

param : String -> String -> List (Html Msg) -> Html Msg
param t tip a = div (paramStyle tip) (paramTitle t tip :: a)

selectMaybe : Maybe a -> Parameter a -> (a -> Msg) -> Html Msg
selectMaybe m p msg =
  param p.title p.desc (List.map (optionMaybe m p.name p.tip msg) p.options)

selectList : List a -> Parameter a -> (a -> Msg) -> Html Msg
selectList m p msg =
  param p.title p.desc (List.map (optionList m p.name p.tip msg) p.options)

selectDict : Dict String Trilean -> Parameter a -> (a -> Msg) -> Html Msg
selectDict m p msg =
  param p.title p.desc (List.map (optionDict m p.name p.tip msg) p.options)

rangeToBytes : Int -> Int
rangeToBytes i =
  let f = toFloat i in
  round (1024 * (2^(f * (17/1000))))

strRound : Float -> String
strRound = String.fromInt << truncate

ppBytes : Int -> String
ppBytes b =
  let m = 1024 * 1024
      f = toFloat b in
  if b > 10 * m then
    strRound (f / m) ++ "M"
  else if b > m then
    strRound (f / m) ++ "." ++ strRound (10 * (f / m - toFloat (b // m))) ++ "M"
  else
    strRound (f / 1024) ++ "K"

range : Int -> String -> String -> Int -> Int -> (Int -> Msg) -> Html Msg
range m title desc min max msg =
  param
    title desc
    [ div [ class "flex my-auto px-3" ]
      [ input
        [ type_ "range"
        , class "basis-2/3 hover:cursor-grab active:cursor-grabbing"
        , class "w-8"
        , attribute "orient" "vertical"
        , Attr.min (String.fromInt min)
        , Attr.max (String.fromInt max)
        , onInput (\v -> msg <| Maybe.withDefault 0 <| String.toInt v)
        , value (String.fromInt m)
        ]
        []
      , div [ class "basis-1/3 relative flex flex-col" ]
        [ span
          [ class "absolute -left-6 text-slate-200"
          , style "bottom" (String.fromFloat (toFloat m / 11.2) ++ "%")
          ]
          [ text (ppBytes (rangeToBytes m)) ]
        ]
      ]
    ]


-- VIEW Logos

viewLogo : Bool -> Language -> Html Msg
viewLogo show l =
  div [ class "flex-shrink-0 flex flex-col justify-center"
      , class "transition-[margin] duration-300"
      , class (if show then "m-2 md:m-5" else "m-0")
      ]
  [ img
      [ src ("icon/" ++ l.language ++ ".svg")
      , alt l.name
      , onClick (ShowLanguage l)
      , onMouseEnter (Tooltip l.name)
      , class "mix-blend-multiply drop-shadow-lg hover:brightness-125"
      , class "cursor-pointer"
      , class "transition-[width] duration-300"
      , class (if show then "w-16 md:w-24" else "w-0")
      ] []
  ]

-- At least one of the DoWant items in the query must be present in the language
--
filterAny : List a -> a -> Bool
filterAny q l =
  case List.isEmpty q of
    True -> True
    False -> List.member l q

filterAnyN : List a -> List a -> Bool
filterAnyN q l =
  List.isEmpty q || not (List.isEmpty (List.filter (\i -> List.member i q) l))

-- All the DoWant items in the query must be present in the language
-- and all the DontWant items must not be present
--
filterAll : Dict String Trilean -> List a -> (a -> String) -> Bool
filterAll q l f =
  let ls = List.map f l in
  List.all (\x -> x == True) (Dict.values (Dict.map (\k v -> case v of
    DoWant -> List.member k ls
    DontWant -> not (List.member k ls)
    DontCare -> True) q))

filterAllN : List a -> List a -> Bool
filterAllN q l = List.all (\plat -> List.member plat l) q

filter : Query -> Language -> Bool
filter q l
  = filterAny q.spec l.spec
  && filterAny q.status l.status
  && (q.impl == Nothing || q.impl == Just l.impl)
  && filterDomain q l
  && filterAllN q.platform l.platform
  && filterAny q.typing l.typing
  && filterSafety q l
  && filterAny q.mm l.mm
  && filterAny q.everything l.everything
  && filterAnyN q.paradigms l.paradigms
  && filterAnyN q.pe l.parallelism
  && filterAll q.features l.features Lang.featName
  && filterAll q.concurrency l.concurrency Lang.concurrencyName
  && filterAll q.runtime l.runtime Lang.runtimeName
  && filterAny q.ortho l.orthogonality
  && filterHelloWorld q l

filterDomain : Query -> Language -> Bool
filterDomain q l = case q.domain of
  Just d -> List.member d l.domain
  Nothing -> True

safetyRank : Lang.Safety -> Int
safetyRank x = case x of
  Lang.None -> 0
  Lang.MemorySafe -> 1
  Lang.TypeSafe -> 2
  Lang.Verified -> 3

filterSafety : Query -> Language -> Bool
filterSafety q l = case q.safety of
  [] -> True
  [ Lang.None ] -> l.safety == Lang.None
  _ -> safetyRank l.safety >= Maybe.withDefault 0 (List.minimum (List.map safetyRank q.safety))

filterHelloWorld : Query -> Language -> Bool
filterHelloWorld q l = rangeToBytes q.helloworld >= Bench.helloworld l.language


-- VIEW Language info

viewInfo : Language -> Html msg
viewInfo l =
  div
    [ class "flex flex-col w-full"
    ]
    [ h2 [ class "text-4xl p-8 md:p-12 font-mono text-center text-gray-900 font-bold" ]
        (case l.homepage of
          Nothing -> [ text l.name ]
          Just link -> [ a [ href link ] [ text l.name ] ])
    , pre
      [ class "bg-gray-900 p-4 m-8 text-slate-200"
      , class "shadow-inset rounded-lg overflow-hidden"
      ]
      [ code [] [ text l.example ] ]
    ]

