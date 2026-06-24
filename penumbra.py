from cre import PredicateType, Undef


PenumbraPredicate = PredicateType("PenumbraPredicate",
    {"id" : {"type": str, "sync_logic_name_in_ext": True},
     "verity" : bool,
     "ts" : int,
     "te" : int,
    }
)
