module Syntax where

    import Types

    import Text.Parsec
    
    -- declaring a new data type
    -- the new values of the type are called constructors
    -- values with arguments are called constructor functions, which are themselves fully evaluated
    data Term 
      = Undefined -- "empty" term
      | Zero
      | Tru
      | Fls
      | Var Int String
      | If Term Term Term
      | Succ Term
      | Pred Term
      | IsZero Term
      | Lambda Type Term [String] -- abstraction
      | App Term Term -- application
      deriving (Eq, Show) -- make the data type an instance of these built-in classes

    -- retrieve the binding context of an abstraction
    getContext :: Term -> [String]
    getContext t = case t of
      Lambda _ _ ctx -> ctx
      _              -> []

-- the basic types in Haskell are Bool, Char, Int, String, Int, Integer, Float