pub mod zk_kit_nr {
    // For the Binary Merkle Root
    use binary_merkle_root::binary_merkle_root;
    use std::hash::poseidon::bn254::hash_2 as poseidon2;

    // For the Merkle Tree
    use trees::merkle::MerkleTree;
    use std::hash::poseidon2::Poseidon2::hash;
    use std::hash::pedersen_hash;

    // For the ECDH
    use ecdh::bjj::BJJ; // only Baby JubJub is supported at the moment
    use ec::tecurve::affine::Point;

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
    * @notice - Create a new Merkle tree with a given leaf.
    * @dev - In this case, a given "leaf" will be a new root.
    */
    pub fn create_new_merkle_tree(leaf: Field) -> Field {
        let current_root: Field = 0x00;
        let mut mt: MerkleTree<Field> = MerkleTree::from(current_root, pedersen_hash);

        //let leaf = 0x67635fc829435949ed0ced751d11f3f823087ec463ca6ee53e253fb7e390e74;
        let index: Field = 0x00;    // Index = 0
        let paths: [Field; 0] = [];
        mt.add(leaf, index, paths);

        // @dev - Constrant: Check if the root is equal to the leaf
        assert(mt.root == leaf);

        // @dev - Constrant: Prove a new leaf is in the Merkle Tree
        mt.membership(mt.root, index, paths); // @dev - The membership() has no return value.

        mt.root
    }


    /**
     * @notice - Create a new public key /or shared key
     */
    pub fn create_new_public_key(private_key: Field) -> Point {
        let ecdh = BJJ::new(private_key);
        let public_key = ecdh.derive_public_key();

        public_key
    }

    pub fn create_new_shared_key(private_key: Field, public_key: Point) -> Field {
        let ecdh = BJJ::new(private_key);
        let shared_key = ecdh.derive_shared_key(public_key);

        shared_key
    }
}
