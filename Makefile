
all: main.js style.css

main.js: Main.gren Lang.gren Bench.gren
	gren make --optimize Main.gren --output main.js

style.css: Main.gren tailwind.config.js
	tailwindcss -o style.css

Lang.gren: Lang.gren.in def.m4 Makefile lang/*
	sed -s '1s/^/  , { /;1!s/^  /        /;1!s/^\([^ ]\)/    , \1/;$$s/$$/\n    }/' lang/* > langlist
	sed -i '1s/^  , /  [ /;$$s/$$/\n  ]/' langlist
	m4 Lang.gren.in > Lang.gren
	echo 'langs =' >> Lang.gren
	cat langlist >> Lang.gren

Bench.gren: Makefile
	touch helloworld.bench
	echo 'module Bench exposing(..)' > Bench.gren
	echo >> Bench.gren
	echo 'helloworld : String -> Int' >> Bench.gren
	echo 'helloworld s = case s of' >> Bench.gren
	sed 's/^/  /' helloworld.bench >> Bench.gren
	echo '  _ -> 0' >> Bench.gren
	echo >> Bench.gren

clean:
	rm -f main.js style.css Lang.gren langlist Bench.gren helloworld.bench

benchmark: helloworld.bench
	$(MAKE) -B Bench.gren

helloworld.bench: $(addsuffix /result,$(wildcard benchmark/helloworld/*))
	cat $^ > helloworld.bench

benchmark/helloworld/%/result:
	docker build -t helloworld $(dir $@)
	docker run --rm helloworld cat result > $(dir $@)result

.PHONY: all clean benchmark
