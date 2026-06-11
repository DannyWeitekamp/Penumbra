from cre import PredicateType, Undef


PenumbraPredicate = PredicateType("PenumbraPredicate",
    {"id" : Undef,
     "verity" : bool,
     "ts" : int,
     "te" : int,
    }
)
