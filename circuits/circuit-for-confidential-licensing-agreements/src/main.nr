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
