divert(-1)
changequote(«, »)

define(«_nl», «
»)

define(«comma», «,»)

define(«_shift2», «shift(shift($@))»)
define(«_shift3», «shift(shift(shift($@)))»)
define(«_shift4», «shift(shift(shift(shift($@))))»)

define(«_deftype2», «ifelse($#, 0, ,
                            $#, 1, ,
                            $#, 2, ,
                            $#, 3, «  | $1»,
                                   «  | $1«»_nl«»_deftype2(_shift3($@))»)»)

define(«_deftype1», «  = $1»_nl«_deftype2(_shift3($@))»)

define(«_deflist2», «ifelse($#, 0, ,
                            $#, 1, ,
                            $#, 2, ,
                            $#, 3, «  , $1»_nl«  ]»,
                                   «  , $1«»_nl«»_deflist2(_shift3($@))»)»)

define(«_deflist1», «  [ $1»_nl«_deflist2(_shift3($@))»)

define(«_defname1», «ifelse($#, 0, ,
                            $#, 1, ,
                            $#, 2, ,
                            $#, 3, «  $1 -> "$2"»,
                                   «  $1 -> "$2"«»_nl«»_defname1(_shift3($@))»)»)

define(«_deftip1», «ifelse($#, 0, ,
                           $#, 1, ,
                           $#, 2, ,
                           $#, 3, «  $1 -> "$3."»,
                                  «  $1 -> "$3."«»_nl«»_deftip1(_shift3($@))»)»)

define(«def»,
«type $1
_deftype1(_shift4($@))

$2Options : Array $1
$2Options =
_deflist1(_shift4($@))

$2Name : $1 -> String
$2Name x = case x of
_defname1(_shift4($@))

$2Tip : $1 -> String
$2Tip x = case x of
_deftip1(_shift4($@))

$2 : Parameter $1
$2 =
  { title = "$3"
  , desc = "$4."
  , options = $2Options
  , name = $2Name
  , tip = $2Tip
  }»)

undefine(«sysval»)
divert(0)dnl
undefine(«divert»)dnl
