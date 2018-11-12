-module(erlchash).

-export([new/1]).
-export([insert/2]).
-export([delete/2]).
-export([lookup/2]).

-define(MAX, 134217727).	% erlang:phash2/1 max

-type ?MODULE() :: gb_trees:gb_tree().

-spec new(list(term())) -> ?MODULE().
new(Nodes) when is_list(Nodes), Nodes =/= [] ->
	lists:foldl(fun insert/2, gb_trees:empty(), Nodes).

-spec insert(term(), ?MODULE()) -> ?MODULE().
insert(Node, CHash) ->
	true = gb_trees:size(CHash) =< ?MAX,
	insert(Node, CHash, 0).

-spec delete(term(), ?MODULE()) -> ?MODULE().
delete(Node, CHash0) ->
	delete(Node, gb_trees:empty(), gb_trees:next(gb_trees:iterator(CHash0))).

-spec lookup(term(), ?MODULE()) -> term().
lookup(Term, CHash) ->
	K = erlang:phash2(Term),
	Iter = gb_trees:iterator_from(K, CHash),
	lookup2(gb_trees:next(Iter), CHash).

%%

insert(Node, CHash0, Perturb) ->
	try gb_trees:insert(erlang:phash2({Perturb, Node}), Node, CHash0) of
		CHash ->
			CHash
	catch
		_:_ ->
			insert(Node, CHash0, Perturb + 1)
	end.

delete(_Node, CHash, none) ->
	false = gb_trees:is_empty(CHash),
	CHash;
delete(Node, CHash, {_Key, Node, Iter2}) ->
	delete(Node, CHash, gb_trees:next(Iter2));
delete(Node, CHash, {Key, Value, Iter2}) ->
	delete(Node, gb_trees:insert(Key, Value, CHash), gb_trees:next(Iter2)).

lookup2(none, CHash) ->
	{_K,V} = gb_trees:smallest(CHash),
	V;
lookup2({_K,V,_Iter2}, _CHash) ->
	V.
