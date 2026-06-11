from penumbra import PenumbraPredicate as PPred
from cre import PredicateType, Var, AND, OR, Undef
import cre

def FactSet(facts):
    fs = cre.FactSet()
    for f in facts: fs.declare(f)
    return fs

# Static entity types
Block = PredicateType("Block", {}, inherits_from=PPred)
Table = PredicateType("Table", {}, inherits_from=PPred)
Hand  = PredicateType("Hand",  {}, inherits_from=PPred)

# Fluents (state relations that change over time)
Clear   = PredicateType("Clear",   {"block": PPred},                  inherits_from=PPred)
Empty   = PredicateType("Empty",   {"hand": PPred},                   inherits_from=PPred)
OnTable = PredicateType("OnTable", {"block": PPred, "table": PPred},  inherits_from=PPred)
Holding = PredicateType("Holding", {"hand" : PPred, "object": PPred},                   inherits_from=PPred)
On      = PredicateType("On",      {"above": PPred, "below": PPred},  inherits_from=PPred)

# Actions
Pickup        = PredicateType("Pickup",        {"block": PPred, "table": PPred},                      inherits_from=PPred)
Putdown       = PredicateType("Putdown",       {"block": PPred, "table": PPred},                      inherits_from=PPred)
Stack         = PredicateType("Stack",         {"block1": PPred, "block2": PPred},                    inherits_from=PPred)
Unstack       = PredicateType("Unstack",       {"block1": PPred, "block2": PPred},                    inherits_from=PPred)
PickupAndStack = PredicateType("PickupAndStack", {"block1": PPred, "table": PPred, "block2": PPred},    inherits_from=PPred)
BuildTower    = PredicateType("BuildTower",    {"top": PPred, "middle": PPred, "table": PPred, "bottom": PPred}, inherits_from=PPred)


rule3 = ((pickup := +Pickup()) <<
  (conds := AND(
    block   := +Block(),
    table   := +Table(),
    hand    := +Hand(),
    clear   := +Clear(block=block),
    empty   := +Empty(hand=hand),
    ontable := +OnTable(block=block, table=table),
    holding := +Holding(hand=hand, object=block),

    # pickup.ts+1 == pickup.te, # Pickup takes 1s

    # # Note: these two are implicit in previous repr 
    # empty.te == pickup.ts, # Empty ends when pickup starts
    # ontable.te == pickup.ts, # Ontable ends when pickup starts

    # # Only pickup while clear
    # clear.ts <= pickup.ts,   # t0 <= t1
    # pickup.ts <= clear.te,   # t1 <= t3

    # # Pickup begins before end of holding
    # pickup.ts < holding.te,  # t1 < t6

    # # Empty begins before pickup ends
    # empty.ts < pickup.te,    # t4 < t2

    # # OnTable begins before pickup ends
    # ontable.ts < pickup.te,  # t5 < t2
  ))
)

print(rule3)


# ---------------------------------------------------------------------------
# Observations from blocks.lisp (setq observations* ...)
# ---------------------------------------------------------------------------

observations = FactSet([
    A := Block(id='A', verity=True, ts=1, te=10),
    B := Block(id='B', verity=True, ts=1, te=10),
    C := Block(id='C', verity=True, ts=1, te=10),
    D := Table(id='D', verity=True, ts=1, te=10),
    H := Hand( id='H', verity=True, ts=1, te=10),
    OnTable(id=('C','D'), block=C, table=D, verity=True, ts=1, te=10),
    # --- before pickup(B,D) ---
    Empty(  id=('H',),    hand=H,            verity=True, ts=1, te=2),
    Clear(  id=('B',),    block=B,           verity=True, ts=1, te=8),
    OnTable(id=('B','D'), block=B, table=D,  verity=True, ts=1, te=2),
    # --- after pickup(B,D), before stack(B,C) ---
    Holding(id=('H','B'), hand=H, object=B,  verity=True, ts=3, te=4),
    Clear(  id=('C',),    block=C,           verity=True, ts=1, te=4),
    # --- after stack(B,C) ---
    On(     id=('B','C'), above=B, below=C,  verity=True, ts=5, te=10),
    Empty(  id=('H',),    hand=H,            verity=True, ts=5, te=6),
    Clear(  id=('A',),    block=A,           verity=True, ts=1, te=10),
    OnTable(id=('A','D'), block=A, table=D,  verity=True, ts=1, te=6),
    # --- after pickup(A,D), before stack(A,B) ---
    Holding(id=('H','A'), hand=H, object=A,  verity=True, ts=7, te=8),
    # --- after stack(A,B) ---
    On(     id=('A','B'), above=A, below=B,  verity=True, ts=9, te=10),
    Empty(  id=('H',),    hand=H,            verity=True, ts=9, te=10),
])

print(observations)

itr = conds.get_partial_matches(observations)

for match in itr:
    print(match)







