from penumbra import PenumbraPredicate
from cre import PredicateType, Tuple, AND, Var

Block = PredicateType("Block",
    {"width": int},
    inherits_from=PenumbraPredicate
)

PickUp = PredicateType("PickUp",
    {"object": str},
    inherits_from=PenumbraPredicate
)

Stack = PredicateType("Stack",
    {"top": str,
     "bottom": str},
    inherits_from=PenumbraPredicate
)

Pyramid = PredicateType("Pyramid",
    {"ptype": str,
     "top": str,
     "bottom": str},
    inherits_from=PenumbraPredicate
)


definitions = [

PickUp(id=(Var("block"), Var("table")), ts=Var("t1"), te=Var("t2")) << 
  AND(
    Block(id=Var("block")),
    Table(id=Var("hand")),
    Hand(id=Var("hand")),
    Clear(id=(Var("block"),), ts=Var("t0"), te=Var("t3")),
    Empty(id=(Var("hand"),), ts=Var("t4"), te=Var("t1")),
    OnTable(id=(Var("block"), Var("table")), ts=Var("t5"), te=Var("t1")),
    Holding(id=(Var("hand"), Var("block")), ts=Var("t2"), te=Var("t6")),

    Var("t2") == Var("t1"), Var("t0") <= Var("t1"), Var("t1") <= Var("t3"),
    Var("t1") < Var("t6"), Var("t4") < Var("t2"), Var("t5") < Var("t2")
 )
]


