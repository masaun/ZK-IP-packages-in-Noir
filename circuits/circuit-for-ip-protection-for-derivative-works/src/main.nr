mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
//mod utils; 
mod zk_kit;

use std::hash::pedersen_hash;
use data_types::{ RevealedData };

global MAX_TERRITORY_LENGTH: u32 = 64;
global MAX_CHANNELS_OF_DISTRIBUTION_LENGTH: u32 = 64;
global MAX_CONTENT_STANDARD_LENGTH: u32 = 64;
global MAX_GOVERNING_LAW_LENGTH: u32 = 64;
global MAX_ADDITIONAL_PARAMETERS_LENGTH: u32 = 64;


fn main(
    // @dev - AI reported results for "On-chain terms"
    reported_commercial_use: bool,
    reported_timestamp_at: Field,
    
    // @dev - AI reported results for "Off-chain terms"
    reported_territory: BoundedVec<u8, MAX_TERRITORY_LENGTH>,     
    reported_channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH>,
    reported_attribution: bool,
    reported_content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH>,
    reported_sublicensable: bool,         
    reported_ai_learning_models: bool,                                           
    reported_restriction_on_cross_platform_use: bool,
    reported_governing_law: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH>,
    reported_alternative_dispute_resolution: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH>,
    reported_additional_parameters: BoundedVec<u8, MAX_ADDITIONAL_PARAMETERS_LENGTH>,
    nullifier: Field
) -> pub RevealedData {
    // @notice - We do not want to public the following "On-chain terms" and "Off-chain terms" for AI-reporter, which is operated by Story Attestation Providers (i.e. Yakoa, Pex, etc).
    // @notice - Hence, the actual "On-chain terms" and "Off-chain terms", which is defined in the original aggrement, should be stored here (with hard coding) - rather than stored via input parameters.
    // @dev - On-chain terms
    let commercial_use: bool = true;     // Whether the agreement allows commercial use of the derivative work
    let expiration: Field = 1767225600;  // The expiration date of the agreement (i.e. 2026-01-01 in seconds)

    // @dev - Off-chain terms
    let territory: BoundedVec<u8, MAX_TERRITORY_LENGTH> = BoundedVec::from_array([1, 2, 3]);                                // Limit usage of the IP to certain regions and/or countries. By default, the IP can be used globally.
    let channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = BoundedVec::from_array([1, 2, 3]);  // Restrict usage of the IP to certain media formats and use in certain channels of distribution. By default, the IP can be used across all possible channels of distribution. Examples: 'television', 'physical consumer products', 'video games', etc.
    let attribution: bool = true;                                                                                           // If the original author should be credited for usage of the IP. By default, you do not need to provide credit to the original author.
    let content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH> = BoundedVec::from_array([1, 2, 3]);                 // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
    let sublicensable: bool = false;                                                                                        // Derivative works can grant the same rights they received under this license to a 3rd party, without approval from the original licensor. By default, derivatives may not do so.
    let ai_learning_models: bool = false;                                                                                   // Whether or not some parts of the derivative work used for the AI learning models.
    let restriction_on_cross_platform_use: bool = true;                                                                     // Limit licensing and creation of derivative works solely on the app on which the IP is made available. By default, the IP can be used anywhere.
    let governing_law: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);                        // The laws of a certain jurisdiction by which this license abides. By default, this is California, USA.
    let alternative_dispute_resolution: BoundedVec<u8, MAX_GOVERNING_LAW_LENGTH> = BoundedVec::from_array([1, 2, 3]);       // Please see section 3.1 (s) here.
    let additional_parameters: BoundedVec<u8, MAX_ADDITIONAL_PARAMETERS_LENGTH> = BoundedVec::from_array([1, 2, 3]);        // There may be other terms the licensor would like to add and they can do so in this tag.

    // @dev - Constraint for the On-chain terms
    assert(commercial_use == reported_commercial_use, "The condition of the commercial use has been violated");
    assert(expiration as u32 >= reported_timestamp_at as u32, "The expiration date has been violated");

    // @dev - Constraint for the Off-chain terms
    assert(territory == reported_territory, "The territory has been violated");
    assert(channels_of_distribution == reported_channels_of_distribution, "The channels of distribution have been violated");
    assert(content_standards == reported_content_standards, "The content standards have been violated");
    assert(ai_learning_models == reported_ai_learning_models, "The AI learning models condition has been violated");
    assert(restriction_on_cross_platform_use == reported_restriction_on_cross_platform_use, "The cross-platform use condition has been violated");

    // @dev - Constraint for the nullifier
    let expected_nullifier: Field = pedersen_hash([reported_timestamp_at]);
    println(f"expected_nullifier: {expected_nullifier}");
    println(f"nullifier: {nullifier}");
    assert(expected_nullifier == nullifier, "Nullifier mismatch");

    // @dev - [TODO]: Add the commitment to the attestation tree.

    // @dev - Return
    let revealed_data = RevealedData {
        is_valid_derivative_work: true, // @dev - Whether the derivative work is valid according to the agreement. Only the fact whether or not a given data of derivative work is valid will be revealed. (Does not reveal all collected-data)
        nullifier: nullifier
    };
    revealed_data
    //nullifier
}
