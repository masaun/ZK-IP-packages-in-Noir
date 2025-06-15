# 【IN PROGRESS】ZK IP packages in Noir

## Overview

- This is the package of Zero-Knowledge (ZK) circuit in Noir for the Intellectual property (IP).

- This package of the ZK circuits in Noir for the Intellectual property (IP) would be consist of two circuits.

<br>

### 1. Confidential Licensing Agreements
- Example scenario: Two parties enter into a licensing agreement with sensitive terms.

- Implementation:
  - The license terms are encoded off-chain.
  - A ZKP is used to prove that the agreement complies with certain conditions (e.g., jurisdiction, duration) without revealing the specific terms.
  - The proof is linked to the IP Asset's metadata on Story Protocol.

- Benefit: Enables enforcement of licensing conditions while preserving confidentiality.

<br>

### 2. Selective Disclosure in Derivative Works

- Example scenario: A creator wants to allow derivatives of their work under specific conditions.

- Implementation:
  - The original IP Asset includes metadata specifying permissible derivative conditions.
  - A ZKP verifies that a derivative work meets these conditions without revealing the derivative's content.
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

- Test of the ZK circuit for the `Derivative Works` (`circuit-for-ip-protection-for-derivative-works`):
```bash
cd circuits/circuit-for-ip-protection-for-derivative-works
sh circuit_test
```

<br>

## Smart Contract

- IN PROGRESS