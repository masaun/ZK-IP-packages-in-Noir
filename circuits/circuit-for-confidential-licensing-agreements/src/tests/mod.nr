mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;
    use crate::data_types::{ RevealedData };
    //use crate::utils;
    use crate::constants::{
        MAX_TERRITORY_LENGTH, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH, 
        MAX_CONTENT_STANDARD_LENGTH, MAX_GOVERNING_LAW_LENGTH, MAX_ADDITIONAL_PARAMETERS_LENGTH
    };

    use crate::zk_kit::{
        zk_kit_nr_binary_merkle_root::{compute_binary_merkle_root, MAX_DEPTH},
        zk_kit_nr_merkle_tree::{create_new_merkle_tree},
        zk_kit_nr_ecdh::{create_new_public_key, create_new_shared_key}
    };

    use std::hash::pedersen_hash;

    // @dev - Add off-chain terms commitment to a new Merkle tree
    #[test]
    fn test_add_off_chain_terms_commitment_to_new_merkle_tree_should_success() {
        let territory: BoundedVec<u8, MAX_TERRITORY_LENGTH> = BoundedVec::from_array([1, 2, 3]);                                // Limit usage of the IP to certain regions and/or countries. By default, the IP can be used globally.
        let channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = BoundedVec::from_array([1, 2, 3]);  // Restrict usage of the IP to certain media formats and use in certain channels of distribution. By default, the IP can be used across all possible channels of distribution. Examples: 'television', 'physical consumer products', 'video games', etc.
        let attribution: bool = true;                                                                                                    // // If the original author should be credited for usage of the IP. By default, you do not need to provide credit to the original author.
        let content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH> = BoundedVec::from_array([1, 2, 3]);                 // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
        let sublicensable: bool = false;                                                                                        // Derivative works can grant the same rights they received under this license to a 3rd party, without approval from the original licensor. By default, derivatives may not do so.
        let ai_learning_models: bool = false;                                                                                   // Whether or not some parts of the derivative work used for the AI learning models.
        let restriction_on_cross_platform_use: bool = true;                                                                     // Limit licensing and creation of derivative works solely on the app on which the IP is made available. By default, the IP can be used anywhere.
        let governing_law: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);                        // The laws of a certain jurisdiction by which this license abides. By default, this is California, USA.
        let alternative_dispute_resolution: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);       // Please see section 3.1 (s) here.
        let additional_parameters: BoundedVec<u8, MAX_ADDITIONAL_PARAMETERS_LENGTH> = BoundedVec::from_array([1, 2, 3]);        // There may be other terms the licensor would like to add and they can do so in this tag.
        let secret: Field = 123456789; // A secret value that is used to generate the nullifier
        println(f"territory: {territory}");
        println(f"channels_of_distribution: {channels_of_distribution}");
        println(f"attribution: {attribution}");
        println(f"content_standards: {content_standards}");
        println(f"sublicensable: {sublicensable}");
        println(f"ai_learning_models: {ai_learning_models}");
        println(f"restriction_on_cross_platform_use: {restriction_on_cross_platform_use}");
        println(f"governing_law: {governing_law}");
        println(f"alternative_dispute_resolution: {alternative_dispute_resolution}");
        println(f"additional_parameters: {additional_parameters}");
        println(f"secret: {secret}");
        
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
        
        // @dev - Merkle proof parameters -> This is an case that create a new Merkle tree with a new root.
        let merkle_proof_length: u32 = 1;                       // @dev - Depth
        let merkle_proof_indices: [u1; MAX_DEPTH] = [0; MAX_DEPTH];        // @dev - Left leaf (0)
        let merkle_proof_siblings: [Field; MAX_DEPTH] = [0; MAX_DEPTH]; // @dev - There is no siblings because new Merkle Tree is created in this case, so we can use "index = 0" (= 0x00).

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

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([off_chain_terms_commitment]);
        println(f"nullifier: {nullifier}");

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            territory,
            channels_of_distribution,
            attribution,
            content_standards,
            sublicensable,
            ai_learning_models,
            restriction_on_cross_platform_use,
            governing_law,
            alternative_dispute_resolution,
            additional_parameters,
            secret,
            merkle_proof_length,
            merkle_proof_indices,
            merkle_proof_siblings,
            nullifier
        );

        // @dev - Check the revealed data, which is the publicInput
        let revealed_data_new_merkle_root = revealed_data.new_merkle_root;
        let revealed_data_nullifier = revealed_data.nullifier;
        println(f"revealed_data.new_merkle_root: {revealed_data_new_merkle_root}");
        println(f"revealed_data.nullifier: {revealed_data_nullifier}");
    }

    // @dev - Add off-chain terms commitment to an existing Merkle tree
    #[test]
    fn test_add_off_chain_terms_commitment_to_existing_merkle_tree_should_success() {        // @dev - Off-chain terms
        let territory: BoundedVec<u8, MAX_TERRITORY_LENGTH> = BoundedVec::from_array([1, 2, 3]);                                // Limit usage of the IP to certain regions and/or countries. By default, the IP can be used globally.
        let channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = BoundedVec::from_array([1, 2, 3]);  // Restrict usage of the IP to certain media formats and use in certain channels of distribution. By default, the IP can be used across all possible channels of distribution. Examples: 'television', 'physical consumer products', 'video games', etc.
        let attribution: bool = true;                                                                                                    // // If the original author should be credited for usage of the IP. By default, you do not need to provide credit to the original author.
        let content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH> = BoundedVec::from_array([1, 2, 3]);                 // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
        let sublicensable: bool = false;                                                                                        // Derivative works can grant the same rights they received under this license to a 3rd party, without approval from the original licensor. By default, derivatives may not do so.
        let ai_learning_models: bool = false;                                                                                   // Whether or not some parts of the derivative work used for the AI learning models.
        let restriction_on_cross_platform_use: bool = true;                                                                     // Limit licensing and creation of derivative works solely on the app on which the IP is made available. By default, the IP can be used anywhere.
        let governing_law: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);                        // The laws of a certain jurisdiction by which this license abides. By default, this is California, USA.
        let alternative_dispute_resolution: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);       // Please see section 3.1 (s) here.
        let additional_parameters: BoundedVec<u8, MAX_ADDITIONAL_PARAMETERS_LENGTH> = BoundedVec::from_array([1, 2, 3]);        // There may be other terms the licensor would like to add and they can do so in this tag.
        let secret: Field = 123456789; // A secret value that is used to generate the nullifier
        println(f"territory: {territory}");
        println(f"channels_of_distribution: {channels_of_distribution}");
        println(f"attribution: {attribution}");
        println(f"content_standards: {content_standards}");
        println(f"sublicensable: {sublicensable}");
        println(f"ai_learning_models: {ai_learning_models}");
        println(f"restriction_on_cross_platform_use: {restriction_on_cross_platform_use}");
        println(f"governing_law: {governing_law}");
        println(f"alternative_dispute_resolution: {alternative_dispute_resolution}");
        println(f"additional_parameters: {additional_parameters}");
        println(f"secret: {secret}");
        
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
        
        // @dev - Merkle proof parameters -> This is an case that add a off_chain_terms_commitment to an existing Merkle tree with a existing root.
        let merkle_proof_length: u32 = 2;                             // @dev - Depth
        let merkle_proof_indices: [u1; MAX_DEPTH] = [1; MAX_DEPTH];   // @dev - Right leaf (1): [1, 0, 0, ..., 0] (This is consist of 1 and 31 of 0s)
        let merkle_proof_siblings: [Field; MAX_DEPTH] = [0x1968049bebaccc1e138a92011f5afdf62dcf4d314a699fb710c342014878f019; MAX_DEPTH]; // @dev - There is siblings (): [0x196..f019, 0, 0, ..., 0] (This is consist of "0x196..f019" and 31 of 0s)

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

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([off_chain_terms_commitment]);
        println(f"nullifier: {nullifier}");

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            territory,
            channels_of_distribution,
            attribution,
            content_standards,
            sublicensable,
            ai_learning_models,
            restriction_on_cross_platform_use,
            governing_law,
            alternative_dispute_resolution,
            additional_parameters,
            secret,
            merkle_proof_length,
            merkle_proof_indices,
            merkle_proof_siblings,
            nullifier
        );

        // @dev - Check the revealed data, which is the publicInput
        let revealed_data_new_merkle_root = revealed_data.new_merkle_root;
        let revealed_data_nullifier = revealed_data.nullifier;
        println(f"revealed_data.new_merkle_root: {revealed_data_new_merkle_root}");
        println(f"revealed_data.nullifier: {revealed_data_nullifier}");
    }

    // #[test(should_fail_with = "A given jurisdiction is out of jurisdiction")]
    // fn test_should_fail_with_out_of_jurisdiction() {
    //     let jurisdiction: u32 = 1;       // Country code - USA (+1)
    //     let duration: Field = 7884000;   // 3 month in seconds
    //     println(f"jurisdiction: {jurisdiction}");

    //     // @dev - Generate the nullifier
    //     let nullifier = pedersen_hash([duration]);

    //     // @dev - Generate a ZKP and publicInput as the "revealed_data"
    //     let revealed_data: RevealedData = main(
    //         jurisdiction,
    //         duration,
    //         nullifier
    //     );
    // }


    //////////////////////////////
    /// @notice - Test outputs ///
    //////////////////////////////

    #[test]
    fn test_output(jurisdiction: str<2>) {
        let jurisdiction_vec: Vec<u8> = jurisdiction.as_bytes_vec();
        println(f"jurisdiction_vec: {jurisdiction_vec}"); // [Log]: Vec { slice: &[117, 107] }
    }
}
