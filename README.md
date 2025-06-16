# ZK IP packages in Noir

## Tech Stack

- `ZK circuit`: Implemented in [`Noir`](https://noir-lang.org/docs/) powered by [Aztec](https://aztec.network/)
- Smart Contract: Implemented in Solidity (Framework: Foundry) (NOTE: Still in progress to implement the smart contracts)
- Blockchain: [`Story` Protocol](https://docs.pharosnetwork.xyz/developer-guides/pharos-devnet-onboarding-guide#rpc-endpoint) (NOTE: Still in progress to implement the smart contracts and deploy on this chain)

<br>

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
  - A ZKP (Zero-Knowledge Proof) can prove the agreement without revealing the sensitive conditions (e.g., jurisdiction, duration). 
    - In the Story Protocol, it is stored as an [**`off-chain` terms** to be included in `uri` field](https://docs.story.foundation/concepts/programmable-ip-license/pil-terms#off-chain-terms-to-be-included-in-uri-field) of the [`PILTerms` struct (which define an `on-chain` terms)](https://docs.story.foundation/concepts/programmable-ip-license/pil-terms#on-chain-terms).
    - The ZK circuit for the `Confidential Licensing Agreements` of this ZK IP package will generate a ZKP of the **`off-chain` terms** and it would be used to prove it without revealing the sensitive conditions.

- Benefit: Enables enforcement of licensing conditions while preserving confidentiality.

<br>

### 2. Selective Disclosure in Derivative Works

- Example use case: A creator wants to allow derivatives of their work under specific conditions.

- Specification:
  - The original IP Asset includes metadata specifying permissible derivative conditions.
  - A ZKP  (Zero-Knowledge Proof) would verify that a derivative work meets these conditions **without revealing** the **full** `derivative's content`.
  - Once the verification for a derivative work is successful, the derivative work is registered as a new IP Asset linked to the original.

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

- Noir:
  - Doc: https://noir-lang.org/docs/getting_started/quick_start

<br>

- ZK-Kit:
  - `merkle-trees`：https://github.com/privacy-scaling-explorations/zk-kit.noir/tree/main/packages/merkle-trees
  - `binary-merkle-root`：https://github.com/privacy-scaling-explorations/zk-kit.noir/tree/main/packages/binary-merkle-root

<br>

- Story Protocol:
  - IPA Metadata Standard: https://docs.story.foundation/concepts/ip-asset/ipa-metadata-standard
  - On-chain term (`PILTerms` struct): https://docs.story.foundation/concepts/programmable-ip-license/pil-terms#on-chain-terms
  - **Off-chain terms** to be included in `uri` field: https://docs.story.foundation/concepts/programmable-ip-license/pil-terms#off-chain-terms-to-be-included-in-uri-field
  - Story Protocol - Boilerplate: https://github.com/storyprotocol/story-protocol-boilerplate/tree/main
  


