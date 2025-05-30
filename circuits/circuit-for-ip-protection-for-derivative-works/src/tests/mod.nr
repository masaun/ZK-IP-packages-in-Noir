mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;
    use crate::data_types::{ RevealedData };
    use crate::{ 
        MAX_TERRITORY_LENGTH, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH, MAX_CONTENT_STANDARD_LENGTH, 
        MAX_GOVERNING_LAW_LENGTH, MAX_ADDITIONAL_PARAMETERS_LENGTH
    };
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
        let attribution: bool = true;                                                                                                    // // If the original author should be credited for usage of the IP. By default, you do not need to provide credit to the original author.
        let reported_content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH> = BoundedVec::from_array([1, 2, 3]);                 // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
        let reported_sublicensable: bool = false;                                                                                        // Derivative works can grant the same rights they received under this license to a 3rd party, without approval from the original licensor. By default, derivatives may not do so.
        let reported_ai_learning_models: bool = false;                                                                                   // Whether or not some parts of the derivative work used for the AI learning models.
        let reported_restriction_on_cross_platform_use: bool = true;                                                                     // Limit licensing and creation of derivative works solely on the app on which the IP is made available. By default, the IP can be used anywhere.
        let reported_governing_law: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);                        // The laws of a certain jurisdiction by which this license abides. By default, this is California, USA.
        let reported_alternative_dispute_resolution: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);       // Please see section 3.1 (s) here.
        let reported_additional_parameters: BoundedVec<u8, MAX_ADDITIONAL_PARAMETERS_LENGTH> = BoundedVec::from_array([1, 2, 3]);        // There may be other terms the licensor would like to add and they can do so in this tag.
        println(f"reported_territory: {reported_territory}");
        println(f"reported_channels_of_distribution: {reported_channels_of_distribution}");
        println(f"attribution: {attribution}");
        println(f"reported_content_standards: {reported_content_standards}");
        println(f"reported_sublicensable: {reported_sublicensable}");
        println(f"reported_ai_learning_models: {reported_ai_learning_models}");
        println(f"reported_restriction_on_cross_platform_use: {reported_restriction_on_cross_platform_use}");
        println(f"reported_governing_law: {reported_governing_law}");
        println(f"reported_alternative_dispute_resolution: {reported_alternative_dispute_resolution}");
        println(f"reported_additional_parameters: {reported_additional_parameters}");
        
        // @dev - [TEST]
        //test_output(reported_territory);

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([reported_timestamp_at]);
        println(f"nullifier: {nullifier}");

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            reported_commercial_use,
            reported_timestamp_at,
            reported_territory,
            reported_channels_of_distribution,
            attribution,
            reported_content_standards,
            reported_sublicensable,
            reported_ai_learning_models,
            reported_restriction_on_cross_platform_use,
            reported_governing_law,
            reported_alternative_dispute_resolution,
            reported_additional_parameters,
            nullifier
        );

        // @dev - Check the revealed data, which is the publicInput
        let revealed_data_nullifier = revealed_data.nullifier;
        println(f"revealed_data.nullifier: {revealed_data_nullifier}");
    }

    #[test(should_fail_with = "The condition of the commercial use has been violated")]
    fn test_should_fail_with_commercial_use_violation() {
        // @notice - In this test, we assume that an AI-reporter, which is operated by Story Attestation Providers (i.e. Yakoa, Pex, etc), would report the following "On-chain terms" and "Off-chain terms".
        // @dev - On-chain terms
        let reported_commercial_use: bool = false;     // Whether the agreement allows commercial use of the derivative work
        let reported_timestamp_at: Field = 1767225600;  // The expiration date of the agreement (i.e. 2026-01-01 in seconds)
        println(f"reported_commercial_use: {reported_commercial_use}");
        println(f"reported_timestamp_at: {reported_timestamp_at}");

        // @dev - Off-chain terms
        let reported_territory: BoundedVec<u8, MAX_TERRITORY_LENGTH> = BoundedVec::from_array([1, 2, 3]);                                // Limit usage of the IP to certain regions and/or countries. By default, the IP can be used globally.
        let reported_channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = BoundedVec::from_array([1, 2, 3]);  // Restrict usage of the IP to certain media formats and use in certain channels of distribution. By default, the IP can be used across all possible channels of distribution. Examples: 'television', 'physical consumer products', 'video games', etc.
        let attribution: bool = true;                                                                                                    // // If the original author should be credited for usage of the IP. By default, you do not need to provide credit to the original author.
        let reported_content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH> = BoundedVec::from_array([1, 2, 3]);                 // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
        let reported_sublicensable: bool = false;                                                                                        // Derivative works can grant the same rights they received under this license to a 3rd party, without approval from the original licensor. By default, derivatives may not do so.
        let reported_ai_learning_models: bool = false;                                                                                   // Whether or not some parts of the derivative work used for the AI learning models.
        let reported_restriction_on_cross_platform_use: bool = true;                                                                     // Limit licensing and creation of derivative works solely on the app on which the IP is made available. By default, the IP can be used anywhere.
        let reported_governing_law: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);                        // The laws of a certain jurisdiction by which this license abides. By default, this is California, USA.
        let reported_alternative_dispute_resolution: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);       // Please see section 3.1 (s) here.
        let reported_additional_parameters: BoundedVec<u8, MAX_ADDITIONAL_PARAMETERS_LENGTH> = BoundedVec::from_array([1, 2, 3]);        // There may be other terms the licensor would like to add and they can do so in this tag.
        println(f"reported_territory: {reported_territory}");
        println(f"reported_channels_of_distribution: {reported_channels_of_distribution}");
        println(f"attribution: {attribution}");
        println(f"reported_content_standards: {reported_content_standards}");
        println(f"reported_sublicensable: {reported_sublicensable}");
        println(f"reported_ai_learning_models: {reported_ai_learning_models}");
        println(f"reported_restriction_on_cross_platform_use: {reported_restriction_on_cross_platform_use}");
        println(f"reported_governing_law: {reported_governing_law}");
        println(f"reported_alternative_dispute_resolution: {reported_alternative_dispute_resolution}");
        println(f"reported_additional_parameters: {reported_additional_parameters}");

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([reported_timestamp_at]);
        println(f"nullifier: {nullifier}");

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            reported_commercial_use,
            reported_timestamp_at,
            reported_territory,
            reported_channels_of_distribution,
            attribution,
            reported_content_standards,
            reported_sublicensable,
            reported_ai_learning_models,
            reported_restriction_on_cross_platform_use,
            reported_governing_law,
            reported_alternative_dispute_resolution,
            reported_additional_parameters,
            nullifier
        );
    }


    //////////////////////////////
    /// @notice - Test outputs ///
    //////////////////////////////

    // #[test]
    // fn test_output(_reported_territory: <u8, MAX_TERRITORY_LENGTH>) {
    //     let _territory = _reported_territory.as_str_unchecked();
    //     println(f"_territory: {_territory}"); // [Log]:
    // }

    // fn test_output(jurisdiction: str<2>) {
    //     let jurisdiction_vec: Vec<u8> = jurisdiction.as_bytes_vec();
    //     println(f"jurisdiction_vec: {jurisdiction_vec}"); // [Log]: Vec { slice: &[117, 107] }
    // }
}
