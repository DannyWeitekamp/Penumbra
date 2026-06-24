from penumbra import PenumbraPredicate as PPred
from cre import PredicateType, Var, AND, OR, Undef

# Static entity types
Block = PredicateType("Block", {}, inherits_from=PPred)
Table = PredicateType("Table", {}, inherits_from=PPred)
Hand  = PredicateType("Hand",  {}, inherits_from=PPred)

# Fluents (state relations that change over time)
Clear   = PredicateType("Clear",   {"block": PPred},                  inherits_from=PPred)
Empty   = PredicateType("Empty",   {"hand":  PPred},                   inherits_from=PPred)
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



# No AND(), No (:=), tuple, 

pickup = (
 +Block(id="block1"),
 +Block(id="block2"),
 +Clear(id="clear1", block=block1),
 +Holding(id="holding1", object=block1),
) >> (
 -clear1, 
 +On(id="on1", below=block1, above=block2),
  holding1.object == None
)










