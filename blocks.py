from penumbra import PenumbraPredicate as PPred
from cre import PredicateType, Var, AND, OR, Undef

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

# class PPred(PredicateType):
#     ...

# PPred : a, b, c        {a,b,c}
# OtherClass : x, y, z   {x,y,z}
# Clear :                {a,b,c,x,y,z}




# class Clear(PPred, OtherClass):
#     block : PPred


# A representation similar to LISP Penumbra 

# definitions = [

rule1 = (AND(Pickup(id=(Var("block"), Var("table")), ts=Var("t1"), te=Var("t2"))) << 
  AND(
    Block(id=Var("block")),
    Table(id=Var("table")),
    Hand(id=Var("hand")),
    Clear(id=(Var("block"),), ts=Var("t0"), te=Var("t3")),
    Empty(id=(Var("hand"),), ts=Var("t4"), te=Var("t1")),
    OnTable(id=(Var("block"), Var("table")), ts=Var("t5"), te=Var("t1")),
    Holding(id=(Var("hand"), Var("block")), ts=Var("t2"), te=Var("t6")),

    # Var("t2") == Var("t1"), Var("t0") <= Var("t1"), Var("t1") <= Var("t3"),
    # Var("t1") < Var("t6"), Var("t4") < Var("t2"), Var("t5") < Var("t2")
 )
)

print(rule1)

# print("----------------")

rule2 = (AND(pickup := Var(Pickup)) << 
  AND(
    block := Var(Block),
    table := Var(Table),
    hand := Var(Hand),
    clear := Var(Clear(block=block)),
    empty := Var(Empty(hand=hand)),
    ontable := Var(OnTable(block=block, table=table)),
    holding := Var(Holding(hand=hand, object=table)),

#     # pickup.ts+1 == pickup.te, # Pickup takes 1s

#     # # Note: these two are implicit in previous repr 
#     # empty.te == pickup.ts, # Empty ends when pickup starts
#     # ontable.te == pickup.ts, # Ontable ends when pickup starts

#     # # Only pickup while clear
#     # clear.ts <= pickup.ts,   # t0 <= t1
#     # pickup.ts <= clear.te,   # t1 <= t3

#     # # Pickup begins before end of holding
#     # pickup.ts < holding.te,  # t1 < t6

#     # # Empty begins before pickup ends
#     # empty.ts < pickup.te,    # t4 < t2

#     # # OnTable begins before pickup ends
#     # ontable.ts < pickup.te,  # t5 < t2
 )
)

# print(rule2)

print("----------------")

def before(a,b):
    return

pickup = +Pickup()
print(pickup.ts)
print(pickup.ts+1)
print(pickup.ts+1 == pickup.te)

print(type(pickup.ts+1 == pickup.te))

print("vvvvvvvvvvvvv")

block = +Block()
clear = +Clear(block=block),

print("-----")
AND(
  block := +Block(),
  clear := +Clear(block=block),
)
print(block)
print("-----")
print(clear)

print("^^^^^^^^^^^^")


# fact = Block()
# logic = +Block() 

# fact.ts -> Value
# fact.ts -> Variable

# v = Var(Block)
# v.ts -> Var

# v.ts 

def RuleDecorator(f):
    print("Wrap")
    # def func():
    #     print("Call")
    #     return x
    z = f()

    return z

@RuleDecorator
def rule1():
    return (
      AND(
        block   := +Block(),
        table   := +Table(),
        hand    := +Hand(),

      ) >> AND(+Pickup())
    )


def MyFunc(x,y):
    print("call MyFunc")

MyFunc(
    x := print("make x"),
    y := print("make y")
)
# moo()

# Rule("Moo")(

rule3 = ((pickup := +Pickup()) <<
  AND(
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
  )
)

print(rule3)
print(rule3)







