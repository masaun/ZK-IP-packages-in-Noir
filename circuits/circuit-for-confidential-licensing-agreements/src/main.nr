mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
//mod utils; 
mod zk_kit;

use std::hash::pedersen_hash;
use data_types::{ RevealedData };

fn main(
    // @dev - Off-chain terms (which wiil be sensitive informations)
    territory: u32,
    channels_of_distribution: u32,      // Restrict usage of the IP to certain media formats and use in certain channels of distribution. By default, the IP can be used across all possible channels of distribution. Examples: 'television', 'physical consumer products', 'video games', etc.
    content_standards: u32,             // The content standards of the derivative work (i.e. 1: PG, 2: R, 3: X, etc. In this case, the values are just examples)
    ai_learning_models: bool,           // Whether or not some parts of the derivative work used for the AI learning models.
    cross_platform_use: bool,           // Whether or not some parts of the derivative work used cross-platform (i.e. the derivative work can be used on different platforms, such as web, mobile, etc.)
    commercial_use: bool,               // Whether the agreement allows commercial use of the derivative work
    expiration: Field,                  // The expiration date of the agreement (i.e. 2024-01-01 in seconds)

    // @dev - Original parameers
    jurisdiction: u32,                  // The jurisdiction of the agreement (Country code - i.e. +1: US, +44: UK, etc. In this case, "+" sign is not included. Let's say "US" is 1 and "UK" is 44)
    //jurisdiction: str<2>,             // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    //jurisdiction: BoundedVec<u8, 2>,  // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    duration: Field,                    // The duration of the agreement (i.e. 3 month in seconds)
    nullifier: Field
) -> pub RevealedData {
    // @dev - Constraint for the jurisdiction(s)
    let out_of_jurisdictions_list: [u32; 3] = [1, 44, 61]; // An example of out of jurisdictions list (In this example case, "US" (+1), "UK" (+44), "Australia" (61) are out of jurisdiction)
    for i in 0..out_of_jurisdictions_list.len() {
        assert(jurisdiction != out_of_jurisdictions_list[i], "A given jurisdiction is out of jurisdiction");
    }

    // @dev - Constraint for the duration
    assert(duration as u32 > 2628000, "Duration must be greater than 1 mounth (in seconds = 2628000 sec)");

    let expected_nullifier: Field = pedersen_hash([duration]);
    println(f"expected_nullifier: {expected_nullifier}");
    println(f"nullifier: {nullifier}");
    assert(expected_nullifier == nullifier, "Nullifier mismatch");

    // @dev - Return
    let revealed_data = RevealedData {
        nullifier: nullifier
    };
    revealed_data
    //nullifier
}
