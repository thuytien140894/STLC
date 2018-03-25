module CoercionSpec where

  import Test.Hspec
  import Syntax
  import Types
  import Coercion

  spec :: Spec
  spec = do
      describe "coerces" $ do
        context "Bool to Dynamic" $
          it "should be Bool!" $
            coerce Bool Dyn `shouldBe` Inject Bool

        context "Dynamic to Nat" $
          it "should be Nat?" $
            coerce Dyn Nat `shouldBe` Project Nat

        context "Bool to Bool" $
          it "should be Identity" $
            coerce Bool Bool `shouldBe` Iden Bool

        context "Dynamic to Bool->Nat" $
          it "should be Bool!->Nat?" $
            coerce Dyn (Arr Bool Nat) `shouldBe` Func (Inject Bool) (Project Nat)

        context "Bool->Nat to Dynamic" $
          it "should be Bool?->Nat!" $
            coerce (Arr Bool Nat) Dyn `shouldBe` Func (Project Bool) (Inject Nat)

      describe "combines" $ do 
        context "Identity and Bool!" $
          it "should be Bool!" $
            combine (Iden Bool) (Inject Bool) `shouldBe` Inject Bool

        context "Nat! and Bool?" $
          it "should fail" $
            combine (Inject Nat) (Project Bool) `shouldBe` Fail Nat Bool

        context "Nat! and Nat?" $
          it "should be Identity" $
            combine (Inject Nat) (Project Nat) `shouldBe` Iden Nat

        context "Nat?->Bool! and Nat!->Bool?" $
          it "should Iden->Iden" $
            combine (Func (Project Nat) (Inject Bool)) (Func (Inject Nat) (Project Bool)) 
            `shouldBe` Func (Iden Nat) (Iden Bool)
      
      describe "get coercion types" $ do
        context "Iden Bool" $ 
          it "should be (Bool, Bool)" $ 
            getTypes (Iden Bool) `shouldBe` (Bool, Bool)
        
        context "Fail Nat Bool" $
          it "should be (Nat, Bool)" $
            getTypes (Fail Nat Bool) `shouldBe` (Nat, Bool)

        context "Inject Nat" $ 
          it "should be (Nat, Dyn)" $ 
            getTypes (Inject Nat) `shouldBe` (Nat, Dyn)

        context "Project Bool" $ 
          it "should be (Dyn, Bool)" $ 
            getTypes (Project Bool) `shouldBe` (Dyn, Bool)

        context "Func (Inject Bool) (Project Nat)" $ 
          it "should be (Arr Dyn Dyn, Arr Bool Nat)" $ 
            getTypes (Func (Inject Bool) (Project Nat)) `shouldBe` (Arr Dyn Dyn, Arr Bool Nat)

        context "Seq (Iden Bool) (Project Nat)" $ 
          it "should be (Bool, Nat)" $ 
            getTypes (Seq (Iden Bool) (Project Nat)) `shouldBe` (Bool, Nat)

