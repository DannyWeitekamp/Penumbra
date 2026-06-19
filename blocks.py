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


def not_same_time(a,b):
    return AND(b.te < a.ts, a.te < b.ts)

AND(
    +Block("block1"),
    +Block("block2"), 
    +Clear("clear1"), clear.object == block1,
    +Holding("holding1"), holding1.object == block1,
)
>>
 AND(-clear1, 
    +On("on1"), on1.below == block1, on1.above == block2,
    holding1.object == None
 )


AND(
    +Block("block1"),
    +Block("block2"), 
    +Clear("clear1", block1),
    +Holding("holding1", object=block1),
)
>>
 AND(-clear1, 
    +On("on1", below=block1, above=block2),
    holding1.object == None
 )

Not(Block(id="block1", width=10))

->

Var(Block, "block1"), block1.id == "block1", block1.width == 10

Not(Block, "block1"), block1.id == "block1", block1.width == 10


NOT(AND(block1.id == "block1", block1.width == 10))

OR(block1.id != "block1", block1.width != 10)


# TWO issues w/ Pat's
# 1. timestamps
# 2. negation



# No AND(), No (:=), tuple, 
(
    +Block(id="block1"),
    +Block(id="block2"), 
    +Clear(id="clear1", object=block1),
    +Holding("holding1", object=block1),
)
>>
(-clear1, 
    +On("on1", below=block1, above=block2),
    holding1.object == None
)


# No Quotes
AND(
    block1 := +Block(),
    block2 := +Block(), 
    clear1 := +Clear(block1),
    holding1 := +Holding(object=block1),
)
>>
 AND(-clear1, 
    +On("on1", below=block1, above=block2),
    holding1.object == None
 )




 # ############################
 b1.width == Var(int, "b1-width")
 b1 := Block(width=Var("b1-width"))

 ############################



pickup = ((p := +Pickup(block=block, )) <<
  AND(
    +Block("block1", height=10, width=20),

    +Table("table1"),
    block1.height >= table1.height,
    hand1    := +Hand(),
    clear1   := +Clear(block=block), 
    empty1   := +Empty(hand=hand),
    ontable1 := +OnTable(block=block, table=table),
    holding1 := +Holding(hand=hand, object=block),

    # pickup.ts+1 == pickup.te, # Pickup takes 1s

    # # Note: these two are implicit in previous repr 
    # empty.te == pickup.ts, # Empty ends when pickup starts
    # ontable.te == pickup.ts, # Ontable ends when pickup starts

    # # Only pickup while clear

    clear.ts <= pickup.ts,   # t0 <= t1
    pickup.ts <= clear.te,   # t1 <= t3

    # Pickup begins before end of holding
    pickup.ts < holding.te,  # t1 < t6

    # Empty begins before pickup ends
    empty.ts < pickup.te,    # t4 < t2

    # OnTable begins before pickup ends
    ontable.ts < pickup.te,  # t5 < t2
  )
)

FactSet

print(rule3)
print(rule3)







