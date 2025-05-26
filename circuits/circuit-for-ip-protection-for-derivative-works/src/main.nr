mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
//mod utils; 
mod zk_kit;

use std::hash::pedersen_hash;
use data_types::{ RevealedData };

global MAX_TERRITORY_LENGTH: u32 = 64;
global MAX_CHANNELS_OF_DISTRIBUTION_LENGTH: u32 = 64;
global MAX_CONTENT_STANDARD_LENGTH: u32 = 64;


fn main(
    // @dev - AI reported results for "On-chain terms"
    reported_commercial_use: bool,
    reported_timestamp_at: u32,
    
    // @dev - AI reported results for "Off-chain terms"
    reported_territory: BoundedVec<u8, MAX_TERRITORY_LENGTH>,                              
    reported_channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH>,
    reported_content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH>,               
    reported_ai_learning_models: bool,                                           
    reported_cross_platform_use: bool,

    nullifier: Field
) -> pub RevealedData {
    // @notice - We do not want to public the following "On-chain terms" and "Off-chain terms" for AI-reporter, which is operated by Story Attestation Providers (i.e. Yakoa, Pex, etc).
    // @notice - Hence, the actual "On-chain terms" and "Off-chain terms", which is defined in the original aggrement, should be stored here - rather than stored via input parameters.
    // @dev - On-chain terms
    commercial_use: bool = true;  // Whether the agreement allows commercial use of the derivative work
    expiration: u32 = 1700000;    // The expiration date of the agreement (i.e. 2024-01-01 in seconds)

    // @dev - Off-chain terms
    territory: BoundedVec<u8, MAX_TERRITORY_LENGTH> = [1, 2, 3];                                // Limit usage of the IP to certain regions and/or countries. By default, the IP can be used globally.
    channels_of_distribution: BoundedVec<u8, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = [1, 2, 3];  // Restrict usage of the IP to certain media formats and use in certain channels of distribution. By default, the IP can be used across all possible channels of distribution. Examples: 'television', 'physical consumer products', 'video games', etc.
    content_standards: BoundedVec<u8, MAX_CONTENT_STANDARD_LENGTH> = [1, 2, 3];                 // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
    ai_learning_models: bool = false;                                                           // Whether or not some parts of the derivative work used for the AI learning models.
    cross_platform_use: bool = true;                                                            // Whether or not some parts of the derivative work used cross-platform (i.e. the derivative work can be used on different platforms, such as web, mobile, etc.)


    // @dev - Constraint for the On-chain terms
    assert(commercial_use == reported_commercial_use, "The condition of the commercial use has been violated");
    assert(expiration >= reported_timestamp_at, "The expiration date has been violated");

    // @dev - Constraint for the Off-chain terms
    assert(territory == reported_territory, "The territory has been violated");
    assert(channels_of_distribution == reported_channels_of_distribution, "The channels of distribution have been violated");
    assert(content_standards == reported_content_standards, "The content standards have been violated");
    assert(ai_learning_models == reported_ai_learning_models, "The AI learning models condition has been violated");
    assert(cross_platform_use == reported_cross_platform_use, "The cross-platform use condition has been violated");

    // @dev - Constraint for the nullifier
    let expected_nullifier: Field = pedersen_hash([duration]);
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
