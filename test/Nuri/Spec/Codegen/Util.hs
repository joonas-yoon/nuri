module Nuri.Spec.Codegen.Util where

import qualified Data.Set.Ordered as S
import Haneul.Builder
import Haneul.BuilderInternal
import Haneul.Constant
import Haneul.Instruction
import Nuri.Spec.Util
import Test.Hspec

shouldBuild :: Builder () -> (ConstTable, [Instruction]) -> Expectation
shouldBuild actual expected =
  let FuncObject {_funcConstTable = constTable, _funcCode = insts} =
        internalToFuncObject (runBuilder defaultInternal actual)
   in (constTable, snd <$> insts) `shouldBe` expected

defaultI :: BuilderInternal
defaultI = defaultInternal

-- loadGlobal :: Word32 -> Instruction
-- loadGlobal = LoadGlobal . (+ genericLength (toList defaultGlobalNames))

-- storeGlobal :: Word32 -> Instruction
-- storeGlobal = StoreGlobal . (+ genericLength (toList defaultGlobalNames))

ann :: [Instruction] -> [Ann Instruction]
ann = fmap (initPos,)

funcObject :: FuncObject
funcObject =
  FuncObject
    { _funcCode = [],
      _funcConstTable = S.empty,
      _funcGlobalVarNames = [],
      _funcJosa = [],
      _funcMaxLocalCount = 0,
      _funcStackSize = 0
    }
