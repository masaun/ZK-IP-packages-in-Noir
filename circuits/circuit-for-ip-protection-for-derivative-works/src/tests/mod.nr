mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;
    use crate::data_types::{ RevealedData };
    use crate::{ MAX_TERRITORY_LENGTH, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH, MAX_CONTENT_STANDARD_LENGTH };
    //use crate::utils;

    use std::hash::pedersen_hash;

    #[test]
    fn test_should_success() {
        // @notice - In this test, we assume that an AI-reporter, which is operated by Story Attestation Providers (i.e. Yakoa, Pex, etc), would report the following "On-chain terms" and "Off-chain terms".
        // @dev - On-chain terms
        let reported_commercial_use: bool = true;     // Whether the agreement allows commercial use of the derivative work
        let reported_timestamp_at: Field = 1767225600;  // The expiration date of the agreement (i.e. 2026-01-01 in seconds)
        println(f"reported_commercial_use: {reported_commercial_use}");
        println(f"reported_timestamp_at: {reported_timestamp_at}");

        // @dev - Off-chain terms
        let reported_territory: BoundedVec<u8, MAX_TERRITORY_LENGTH> = BoundedVec::from_array([1, 2, 3]);                                // Limit usage of the IP to certain regions and/or countries. By default, the IP can be used globally.
        let reported_channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = BoundedVec::from_array([1, 2, 3]);  // Restrict usage of the IP to certain media formats and use in certain channels of distribution. By default, the IP can be used across all possible channels of distribution. Examples: 'television', 'physical consumer products', 'video games', etc.
        let reported_content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH> = BoundedVec::from_array([1, 2, 3]);                 // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
        let reported_ai_learning_models: bool = false;                                                           // Whether or not some parts of the derivative work used for the AI learning models.
        let reported_cross_platform_use: bool = true;     
        println(f"reported_territory: {reported_territory}");
        println(f"reported_channels_of_distribution: {reported_channels_of_distribution}");
        println(f"reported_content_standards: {reported_content_standards}");
        println(f"reported_ai_learning_models: {reported_ai_learning_models}");
        println(f"reported_cross_platform_use: {reported_cross_platform_use}");
        
        // @dev - [TEST]
        //test_output(jurisdiction);

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([reported_timestamp_at]);
        println(f"nullifier: {nullifier}");

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            reported_commercial_use,
            reported_timestamp_at,
            reported_territory,
            reported_channels_of_distribution,
            reported_content_standards,
            reported_ai_learning_models,
            reported_cross_platform_use,
            nullifier
        );

        // @dev - Check the revealed data, which is the publicInput
        let revealed_data_nullifier = revealed_data.nullifier;
        println(f"revealed_data.nullifier: {revealed_data_nullifier}");
    }

    #[test(should_fail_with = "A given jurisdiction is out of jurisdiction")]
    fn test_should_fail_with_out_of_jurisdiction() {
        let jurisdiction: u32 = 1;       // Country code - USA (+1)
        let duration: Field = 7884000;   // 3 month in seconds
        println(f"jurisdiction: {jurisdiction}");

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([duration]);

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        // let revealed_data: RevealedData = main(
        //     jurisdiction,
        //     duration,
        //     nullifier
        // );
    }


    //////////////////////////////
    /// @notice - Test outputs ///
    //////////////////////////////

    #[test]
    fn test_output(jurisdiction: str<2>) {
        let jurisdiction_vec: Vec<u8> = jurisdiction.as_bytes_vec();
        println(f"jurisdiction_vec: {jurisdiction_vec}"); // [Log]: Vec { slice: &[117, 107] }
    }
}
