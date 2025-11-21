
all: main.js style.css

main.js: Main.elm Lang.elm Bench.elm
	elm make --optimize Main.elm --output main.js

style.css: Main.elm tailwind.config.js
	tailwindcss -o style.css

Lang.elm: Lang.elm.in def.m4 Makefile lang/*
	sed -s '1s/^/  , { /;1!s/^  /        /;1!s/^\([^ ]\)/    , \1/;$$s/$$/\n    }/' lang/* > langlist
	sed -i '1s/^  , /  [ /;$$s/$$/\n  ]/' langlist
	m4 Lang.elm.in > Lang.elm
	echo 'langs =' >> Lang.elm
	cat langlist >> Lang.elm

Bench.elm: Makefile
	touch helloworld.bench
	echo 'module Bench exposing(..)' > Bench.elm
	echo >> Bench.elm
	echo 'helloworld : String -> Int' >> Bench.elm
	echo 'helloworld s = case s of' >> Bench.elm
	sed 's/^/  /' helloworld.bench >> Bench.elm
	echo '  _ -> 0' >> Bench.elm
	echo >> Bench.elm

minify: main.js style.css
	minify -o main.js main.js
	minify -o style.css style.css

clean:
	rm -f main.js style.css Lang.elm langlist Bench.elm helloworld.bench

benchmark: helloworld.bench
	$(MAKE) -B Bench.elm

helloworld.bench: $(addsuffix result,$(wildcard benchmark/helloworld/*/))
	cat $^ > helloworld.bench

benchmark/helloworld/%/result:
	docker build -t helloworld $(dir $@)
	docker run --rm helloworld cat result > $(dir $@)result

.PHONY: all minify clean benchmark
