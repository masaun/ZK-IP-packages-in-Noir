# ZK IP packages in Noir

## Overview

- This is the package of `Zero-Knowledge` (`ZK`) circuits in Noir for the privacy-preserving `Intellectual Property (IP)`.

- This package is consist of the following two type of ZK circuits:
  - `Confidential Licensing Agreements`
  - `Selective Disclosure` in `Derivative Works`

<br>

### 1. Confidential Licensing Agreements
- Example use case: Two parties enter into a licensing agreement with sensitive terms.

- Specification:
  - The license terms are encoded off-chain.
  - A ZKP (Zero-Knowledge Proof) is used to prove that the agreement complies with certain conditions (e.g., jurisdiction, duration) **without revealing** the specific terms.
  - The proof is linked to the `IP Asset's metadata` on **Story Protocol**.

- Benefit: Enables enforcement of licensing conditions while preserving confidentiality.

<br>

### 2. Selective Disclosure in Derivative Works

- Example use case: A creator wants to allow derivatives of their work under specific conditions.

- Specification:
  - The original IP Asset includes metadata specifying permissible derivative conditions.
  - A ZKP  (Zero-Knowledge Proof) would verify that a derivative work meets these conditions **without revealing** the full `derivative's content`.
  - Upon successful verification, the derivative is registered as a new IP Asset linked to the original.

- Benefit: Facilitates controlled collaboration and expansion of creative works.



<br>


## ZK circuits

### Test of the ZK circuits
- Test of the ZK circuit for the `Confidential License Agreement` (`circuit-for-confidential-licensing-agreements`):
```bash
cd circuits/circuit-for-confidential-licensing-agreements
sh circuit_test
```

<br>

- Test of the ZK circuit for the `Derivative Works` (`circuit-for-derivative-works`):
```bash
cd circuits/circuit-for-derivative-works
sh circuit_test
```

<br>

## Smart Contract

- IN PROGRESS

<br>

## DEMO 

- DEMO Video:
  - Currently, this DEMO Video is only for the test of the ZK circuits: https://vimeo.com/1093559312/111c453f4c
   

<br>

## References

- Story Protocol:

- Noir:

- ZK-Kit:

