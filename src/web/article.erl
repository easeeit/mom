-module(article).
-compile(export_all).

list(Arguments) ->
  echo:me("article:list"),
  echo:me(Arguments).