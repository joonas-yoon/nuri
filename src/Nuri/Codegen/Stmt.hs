module Nuri.Codegen.Stmt where

import           Control.Monad.RWS                        ( tell )
import           Control.Lens                             ( modifying
                                                          , use
                                                          )

import           Data.Set.Ordered                         ( (|>)
                                                          , findIndex
                                                          )

import           Text.Megaparsec.Pos                      ( sourceLine )

import           Nuri.Stmt
import           Nuri.ASTNode
import           Nuri.Codegen.Expr

import           Haneul.Builder
import qualified Haneul.Instruction            as Inst

compileStmt :: Stmt -> Builder ()
compileStmt stmt@(ExprStmt expr) = do
  compileExpr expr
  tell [(sourceLine (srcPos stmt), Inst.Pop)]
compileStmt stmt@(Return expr) = do
  compileExpr expr
  tell [(sourceLine (srcPos stmt), Inst.Return)]
compileStmt (Assign pos ident expr) = do
  compileExpr expr
  names <- use varNames
  case findIndex ident names of
    Nothing -> do
      modifying varNames (|> ident)
      tell [(sourceLine pos, Inst.Store (length names))]
    Just index -> tell [(sourceLine pos, Inst.Store index)]
compileStmt (If _ _ _ _      ) = undefined
compileStmt (While _ _       ) = undefined
compileStmt (FuncDecl _ _ _ _) = undefined
