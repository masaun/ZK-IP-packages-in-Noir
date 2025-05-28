mod tests;      // tests/mod.nr
mod data_types;
mod constants;
//mod utils; 
mod zk_kit;

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

    // @dev - Original parameers
    //jurisdiction: u32,                  // The jurisdiction of the agreement (Country code - i.e. +1: US, +44: UK, etc. In this case, "+" sign is not included. Let's say "US" is 1 and "UK" is 44)
    //jurisdiction: str<2>,               // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    //jurisdiction: BoundedVec<u8, 2>,    // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    duration: Field,                      // The duration of the agreement (i.e. 3 month in seconds)
    nullifier: Field
) -> pub RevealedData {
    // @dev - Convert the BoundedVec<u8; ..> to the BoundedVec<Field; ..>
    let _territory: BoundedVec<Field, MAX_TERRITORY_LENGTH> = territory.map(|value| value as Field);
    let _channels_of_distribution: BoundedVec<Field, MAX_CHANNELS_OF_DISTRIBUTION_LENGTH> = channels_of_distribution.map(|value| value as Field);
    let _content_standards: BoundedVec<Field, MAX_CONTENT_STANDARD_LENGTH> = content_standards.map(|value| value as Field);
    let _governing_law: BoundedVec<Field, MAX_GOVERNING_LAW_LENGTH> = governing_law.map(|value| value as Field);
    let _alternative_dispute_resolution: BoundedVec<Field, MAX_GOVERNING_LAW_LENGTH> = alternative_dispute_resolution.map(|value| value as Field);
    let _additional_parameters: BoundedVec<Field, MAX_ADDITIONAL_PARAMETERS_LENGTH> = additional_parameters.map(|value| value as Field);


    // @dev - Constraint for the jurisdiction(s)
    // let out_of_jurisdictions_list: [u32; 3] = [1, 44, 61]; // An example of out of jurisdictions list (In this example case, "US" (+1), "UK" (+44), "Australia" (61) are out of jurisdiction)
    // for i in 0..out_of_jurisdictions_list.len() {
    //     assert(jurisdiction != out_of_jurisdictions_list[i], "A given jurisdiction is out of jurisdiction");
    // }

    // @dev - Constraint for the duration
    // assert(duration as u32 > 2628000, "Duration must be greater than 1 mounth (in seconds = 2628000 sec)");

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
