/-
Copyright (c) 2020 Scott Morrison. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Scott Morrison
-/
import Mathlib.RepresentationTheory.Action.Basic

/-!
# Constructors for `Action V G` for some concrete categories

We construct `Action (Type u) G` from a `[MulAction G X]` instance and give some applications.
-/

universe u v

open CategoryTheory Limits

namespace Action

/-- Bundles a type `H` with a multiplicative action of `G` as an `Action`. -/
def ofMulAction (G H : Type u) [Monoid G] [MulAction G H] : Action (Type u) (MonCat.of G) where
  V := H
  ρ := @MulAction.toEndHom _ _ _ (by assumption)
set_option linter.uppercaseLean3 false in
#align Action.of_mul_action Action.ofMulAction

@[simp]
theorem ofMulAction_apply {G H : Type u} [Monoid G] [MulAction G H] (g : G) (x : H) :
    (ofMulAction G H).ρ g x = (g • x : H) :=
  rfl
set_option linter.uppercaseLean3 false in
#align Action.of_mul_action_apply Action.ofMulAction_apply

/-- Given a family `F` of types with `G`-actions, this is the limit cone demonstrating that the
product of `F` as types is a product in the category of `G`-sets. -/
def ofMulActionLimitCone {ι : Type v} (G : Type max v u) [Monoid G] (F : ι → Type max v u)
    [∀ i : ι, MulAction G (F i)] :
    LimitCone (Discrete.functor fun i : ι => Action.ofMulAction G (F i)) where
  cone :=
    { pt := Action.ofMulAction G (∀ i : ι, F i)
      π := Discrete.natTrans (fun i => ⟨fun x => x i.as, fun g => rfl⟩) }
  isLimit :=
    { lift := fun s =>
        { hom := fun x i => (s.π.app ⟨i⟩).hom x
          comm := fun g => by
            ext x
            funext j
            exact congr_fun ((s.π.app ⟨j⟩).comm g) x }
      fac := fun s j => rfl
      uniq := fun s f h => by
        ext x
        funext j
        dsimp at *
        rw [← h ⟨j⟩]
        rfl }
set_option linter.uppercaseLean3 false in
#align Action.of_mul_action_limit_cone Action.ofMulActionLimitCone

/-- The `G`-set `G`, acting on itself by left multiplication. -/
@[simps!]
def leftRegular (G : Type u) [Monoid G] : Action (Type u) (MonCat.of G) :=
  Action.ofMulAction G G
set_option linter.uppercaseLean3 false in
#align Action.left_regular Action.leftRegular

/-- The `G`-set `Gⁿ`, acting on itself by left multiplication. -/
@[simps!]
def diagonal (G : Type u) [Monoid G] (n : ℕ) : Action (Type u) (MonCat.of G) :=
  Action.ofMulAction G (Fin n → G)
set_option linter.uppercaseLean3 false in
#align Action.diagonal Action.diagonal

/-- We have `fin 1 → G ≅ G` as `G`-sets, with `G` acting by left multiplication. -/
def diagonalOneIsoLeftRegular (G : Type u) [Monoid G] : diagonal G 1 ≅ leftRegular G :=
  Action.mkIso (Equiv.funUnique _ _).toIso fun _ => rfl
set_option linter.uppercaseLean3 false in
#align Action.diagonal_one_iso_left_regular Action.diagonalOneIsoLeftRegular

end Action
