mod tests;      // tests/mod.nr
mod data_types;
mod constants;
//mod utils; 
mod zk_kit;

use zk_kit::{
    zk_kit_nr_binary_merkle_root::{compute_binary_merkle_root, MAX_DEPTH},
    zk_kit_nr_merkle_tree::{create_new_merkle_tree},
    zk_kit_nr_ecdh::{create_new_public_key, create_new_shared_key}
};
//use trees::merkle::MerkleTree;  // Directly imported from "zk-kit.noir" powered by PSE
use std::hash::pedersen_hash;
use data_types::{ RevealedData };
use constants::{
    MAX_TERRITORY_LENGTH, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH, 
    MAX_CONTENT_STANDARD_LENGTH, MAX_GOVERNING_LAW_LENGTH, MAX_ADDITIONAL_PARAMETERS_LENGTH
};

fn main(
    // @dev - Off-chain terms (which wiil be sensitive informations)
    territory: BoundedVec<u8, MAX_TERRITORY_LENGTH>,     
    channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH>,
    attribution: bool,
    content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH>,
    sublicensable: bool,         
    ai_learning_models: bool,                                           
    restriction_on_cross_platform_use: bool,
    governing_law: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH>,
    alternative_dispute_resolution: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH>,
    additional_parameters: BoundedVec<u8, MAX_ADDITIONAL_PARAMETERS_LENGTH>,
    secret: Field,
    // @dev - 
    // @dev - Merkle proof parameters
    merkle_proof_length: u32,
    merkle_proof_indices: [u1; MAX_DEPTH],
    merkle_proof_siblings: [Field; MAX_DEPTH],
    // @dev - Original parameers
    //jurisdiction: u32,                  // The jurisdiction of the agreement (Country code - i.e. +1: US, +44: UK, etc. In this case, "+" sign is not included. Let's say "US" is 1 and "UK" is 44)
    //jurisdiction: str<2>,               // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    //jurisdiction: BoundedVec<u8, 2>,    // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    //duration: Field,                      // The duration of the agreement (i.e. 3 month in seconds)
    nullifier: Field
) -> pub RevealedData {
    // @dev - Convert the BoundedVec<u8; ..> to the BoundedVec<Field; ..>
    let _territory: BoundedVec<Field, MAX_TERRITORY_LENGTH> = territory.map(|value| value as Field);
    let _channels_of_distribution: BoundedVec<Field, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = channels_of_distribution.map(|value| value as Field);
    let _content_standards: BoundedVec<Field, MAX_CONTENT_STANDARD_LENGTH> = content_standards.map(|value| value as Field);
    let _governing_law: BoundedVec<Field, MAX_GOVERNING_LAW_LENGTH> = governing_law.map(|value| value as Field);
    let _alternative_dispute_resolution: BoundedVec<Field, MAX_GOVERNING_LAW_LENGTH> = alternative_dispute_resolution.map(|value| value as Field);
    let _additional_parameters: BoundedVec<Field, MAX_ADDITIONAL_PARAMETERS_LENGTH> = additional_parameters.map(|value| value as Field);

    // @dev - Retrieve the array from the BoundedVec
    let territory_array: [Field; MAX_TERRITORY_LENGTH] = _territory.storage();
    let channels_of_distribution_array: [Field; MAX_CHANNELS_OF_DISTRIBUTION_LENGTH] = _channels_of_distribution.storage();
    let content_standards_array: [Field; MAX_CONTENT_STANDARD_LENGTH] = _content_standards.storage();
    let governing_law_array: [Field; MAX_GOVERNING_LAW_LENGTH] = _governing_law.storage();
    let alternative_dispute_resolution_array: [Field; MAX_GOVERNING_LAW_LENGTH] = _alternative_dispute_resolution.storage();
    let additional_parameters_array: [Field; MAX_ADDITIONAL_PARAMETERS_LENGTH] = _additional_parameters.storage();

    // @dev - Hashing /w Pedersen hash
    let territory_hash: Field = pedersen_hash(territory_array);
    let channels_of_distribution_hash: Field = pedersen_hash(channels_of_distribution_array);
    let attribution_hash: Field = pedersen_hash([attribution as Field]);
    let content_standards_hash: Field = pedersen_hash(content_standards_array);
    let sublicensable_hash: Field = pedersen_hash([sublicensable as Field]);
    let ai_learning_models_hash: Field = pedersen_hash([ai_learning_models as Field]);
    let restriction_on_cross_platform_use_hash: Field = pedersen_hash([restriction_on_cross_platform_use as Field]);
    let governing_law_hash: Field = pedersen_hash(governing_law_array);
    let alternative_dispute_resolution_hash: Field = pedersen_hash(alternative_dispute_resolution_array);
    let additional_parameters_hash: Field = pedersen_hash(additional_parameters_array);
    
    // @dev - Hashing all the hashes together as a combined hash, which is called "off_chain_terms_hash".
    let off_chain_terms_hash: Field = pedersen_hash([
        territory_hash, 
        channels_of_distribution_hash, 
        attribution_hash, 
        content_standards_hash, 
        sublicensable_hash, 
        ai_learning_models_hash, 
        restriction_on_cross_platform_use_hash, 
        governing_law_hash, 
        alternative_dispute_resolution_hash, 
        additional_parameters_hash
    ]);

    // @dev - Generate an off-chain terms commitment hash
    let off_chain_terms_commitment: Field = pedersen_hash([off_chain_terms_hash, secret]);

    // @dev - Create a new Merkle tree with the off-chain terms commitment as the root
    //let new_merkle_root = create_new_merkle_tree(off_chain_terms_commitment);

    // @dev - Compute the binary merkle root
    let binary_merkle_root: Field = compute_binary_merkle_root(
        off_chain_terms_commitment, 
        merkle_proof_length,  // @dev - If the new merkle tree is created, this will be 0. If the existing merkle tree is used, this will be "> 0".
        merkle_proof_indices, // @dev - 0 or 1
        merkle_proof_siblings // @dev - The siblings (leaf's hash) of the Merkle proof. (NOTE: Counted from the "lowest" level of tree to the highest level of tree)
    );

    // @dev - Compute the nullifier
    let expected_nullifier: Field = pedersen_hash([off_chain_terms_commitment]);
    println(f"expected_nullifier: {expected_nullifier}");
    println(f"nullifier: {nullifier}");
    assert(expected_nullifier == nullifier, "Nullifier mismatch");

    // @dev - Return
    let revealed_data = RevealedData {
        //new_merkle_root: new_merkle_root,
        binary_merkle_root: binary_merkle_root,
        nullifier: nullifier
    };
    revealed_data
    //nullifier
}


/** 
 * @notice - Create a new Merkle tree with a given leaf.
 * @dev - In this case, a given "leaf" will be a new root.
 */
// fn create_new_merkle_tree(leaf: Field) -> Field {
//     let current_root: Field = 0x00;
//     let mut mt: MerkleTree<Field> = MerkleTree::from(current_root, pedersen_hash);

//     //let leaf = 0x67635fc829435949ed0ced751d11f3f823087ec463ca6ee53e253fb7e390e74;
//     let index: Field = 0x00;    // Index = 0
//     let paths: [Field; 0] = [];
//     mt.add(leaf, index, paths);

//     // @dev - Constrant: Check if the root is equal to the leaf
//     assert(mt.root == leaf);

//     // @dev - Constrant: Prove a new leaf is in the Merkle Tree
//     mt.membership(mt.root, index, paths); // @dev - The membership() has no return value.

//     mt.root
// }