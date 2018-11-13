Erlang [Consistent Hashing](https://en.wikipedia.org/wiki/Consistent_hashing) Library.

# Preflight

    git clone https://gitlab.com/jimdigriz/erlchash.git

## `erlang.mk`

Add to your `Makefile`:

    DEPS += erlchash
    dep_erlchash = git https://gitlab.com/jimdigriz/erlchash.git master

# Usage

Create a new consistent hash object:

    1> C = erlchash:new([one,two,three])).

Lookups:

    2> erlchash:lookup(cheese, C).
    one
    3> erlchash:lookup(cow, C).
    three

Insert a node:

    4> C2 = erlchash:insert(four, C).

Delete a node (potentially slow for a large number of inserted nodes; operation is `O(N)`):

    5> C3 = erlchash:delete(two, C2).

## Constraints

 * maximum number of nodes you can insert is `2^27-1`, you should not even try to approach this number
 * can never be empty (you cannot create using an empty list or delete all nodes)

# Development

To quickly get a prompt to start playing with this:

    make all shell
