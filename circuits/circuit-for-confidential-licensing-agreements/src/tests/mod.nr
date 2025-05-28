mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;
    use crate::data_types::{ RevealedData };
    //use crate::utils;
    use crate::constants::{
        MAX_TERRITORY_LENGTH, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH, 
        MAX_CONTENT_STANDARD_LENGTH, MAX_GOVERNING_LAW_LENGTH, MAX_ADDITIONAL_PARAMETERS_LENGTH
    };

    use std::hash::pedersen_hash;

    #[test]
    fn test_should_success() {        // @dev - Off-chain terms
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
        
        // let jurisdiction: u32 = 49;         // Country code - Germany (+49)
        // //let jurisdiction: str<2> = "uk";  // An example jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
        // //let jurisdiction: BoundedVec<u8, 2> = BoundedVec::from([1, 2]);
        let duration: Field = 7884000;      // 3 month in seconds
        // println(f"jurisdiction: {jurisdiction}");
        // println(f"duration: {duration}");

        // @dev - [TEST]
        //test_output(jurisdiction);

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([duration]);
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
            duration,
            nullifier
        );

        // @dev - Check the revealed data, which is the publicInput
        let revealed_data_nullifier = revealed_data.nullifier;
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
