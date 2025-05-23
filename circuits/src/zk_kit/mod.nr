// For the Binary Merkle Root
use binary_merkle_root::binary_merkle_root;
use std::hash::poseidon::bn254::hash_2 as poseidon2;

// For the Binary Merkle Tree
use trees::merkle::MerkleTree;
use std::hash::poseidon2::Poseidon2::hash;

// For the ECDH
use ecdh::bjj::BJJ; // only Baby JubJub is supported at the moment


mod zk_kit {
    global MAX_DEPTH: u32 = 32; // Max depth of the Merkle tree

    /**
    * @notice - Compute a Binary Merkle Root
    */
    pub fn compute_binary_merkle_root(
        identity_commitment: Field,
        merkle_proof_length: u32, 
        merkle_proof_indices: [u1; MAX_DEPTH], 
        merkle_proof_siblings: [Field; MAX_DEPTH], 
    ) -> pub Field {
        // Calculate Merkle root.
        let merkle_root = binary_merkle_root(poseidon2, identity_commitment, merkle_proof_length, merkle_proof_indices, merkle_proof_siblings);
        merkle_root
    }


    /**
    * @notice - Add a new entry to (existing) Merkle tree + Prove it is in the tree
    */
    pub fn hasher(leaves: [Field; 2]) -> Field {
        hash(leaves, 2)
    }

    pub fn create_new_merkle_tree(mt: MerkleTree<Field>) -> MerkleTree<Field> {
        let mut mt = MerkleTree::new(hasher);
        mt
    }

    pub fn add_entry_to_paths(mt: MerkleTree<Field>, entry: Field, paths: [Field; 0]) -> MerkleTree<Field> {
        // add at index 0
        mt.add(entry, 0, paths);
        mt
    }

    pub fn is_membership(entry: Field, paths: [Field; 0]) -> bool {
        // prove it is in the tree (kinda redundant isn't it?)
        mt.membership(entry, 0, paths)
    }


    /**
    * @notice - Add a new entry to (existing) Merkle tree + Prove it is in the tree
    */
    pub fn create_new_public_key() -> [Point; 2] {
        let ecdh = BJJ::new(your_private_key);
        let public_key = ecdh.derive_public_key();

        let shared_key = ecdh.derive_shared_key(someone_elses_public_key);

        [public_key, shared_key]
    }

}