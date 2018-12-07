From coqutil Require Import sanity.
Require Import Coq.Arith.PeanoNat.
Require Import Coq.Arith.Compare_dec.
Require Import Coq.ZArith.BinInt.
Require Import Coq.NArith.NArith.

Class Decidable (P : Prop) := dec : {P} + {~P}.
Arguments dec _%type_scope {_}.

Notation DecidableRel R := (forall x y, Decidable (R x y)).
Notation DecidableEq T := (DecidableRel (@eq T)).

Global Instance dec_eq_nat : DecidableEq nat := Nat.eq_dec.
Global Instance dec_le_nat : DecidableRel le := Compare_dec.le_dec.
Global Instance dec_lt_nat : DecidableRel lt := Compare_dec.lt_dec.
Global Instance dec_ge_nat : DecidableRel ge := Compare_dec.ge_dec.
Global Instance dec_gt_nat : DecidableRel gt := Compare_dec.gt_dec.

Global Instance dec_eq_Z : DecidableEq Z := Z.eq_dec.
Global Instance dec_lt_Z : DecidableRel BinInt.Z.lt := ZArith_dec.Z_lt_dec.
Global Instance dec_le_Z : DecidableRel BinInt.Z.le := ZArith_dec.Z_le_dec.
Global Instance dec_gt_Z : DecidableRel BinInt.Z.gt := ZArith_dec.Z_gt_dec.
Global Instance dec_ge_Z : DecidableRel BinInt.Z.ge := ZArith_dec.Z_ge_dec.

Global Instance dec_Empty_set: DecidableEq Empty_set.
Proof. intro x. destruct x. Defined.
Global Instance dec_eq_unit: DecidableEq unit.
Proof. intros x y. destruct x, y; exact (left eq_refl). Defined.

Global Instance decidable_eq_option {A} `{DecidableEq A}: DecidableEq (option A).
Proof.
  refine (fun a b =>
            match a, b with
            | Some x, Some y =>
              match dec (x=y) with left _ => left _ | right _ => right _ end
            | None, None => left _
            | _,_ => right _ end
         ); abstract intuition congruence.
Defined.

Global Instance dec_eq_pair{T1 T2: Type}(eq1: DecidableEq T1)(eq2: DecidableEq T2):
  DecidableEq (T1 * T2).
Proof.
refine (fun '(x1, x2) '(y1, y2) => match eq1 x1 y1, eq2 x2 y2 with
                                   | left E1, left E2 => left _
                                   | right N1, _ => right _
                                   | _, right N2 => right _
                                   end); abstract intuition congruence.
Defined.

Global Instance dec_and {A B} `{Decidable A, Decidable B} : Decidable (A /\ B).
Proof. cbv [Decidable] in *; destruct H; destruct H0; tauto. Defined.

Global Instance dec_or {A B} `{Decidable A, Decidable B} : Decidable (A \/ B).
Proof. cbv [Decidable] in *; destruct H; destruct H0; tauto. Defined.

Global Instance dec_not {A} `{Decidable A} : Decidable (~ A).
Proof. cbv [Decidable] in *. destruct H; tauto. Defined.
