mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
//mod utils; 
mod zk_kit;

use std::hash::pedersen_hash;
use data_types::{ RevealedData };

fn main(
    jurisdiction: u32,                  // The jurisdiction of the agreement (Country code - i.e. +1: US, +44: UK, etc. In this case, "+" sign is not included. Let's say "US" is 1 and "UK" is 44)
    //jurisdiction: str<2>,             // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    //jurisdiction: BoundedVec<u8, 2>,  // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    duration: Field,                    // The duration of the agreement (i.e. 3 month in seconds)
    nullifier: Field
) -> pub RevealedData {
    // @dev - Constraint for the jurisdiction(s)
    let out_of_jurisdictions_list: [u32; 3] = [1, 44, 61]; // An example of out of jurisdictions list (In this example case, "US" (+1), "UK" (+44), "Australia" (61) are out of jurisdiction)
    for i in 0..out_of_jurisdictions_list.len() {
        assert(jurisdiction != out_of_jurisdictions_list[i], "A ginve jurisdiction is out of jurisdiction");
    }
    
    //let out_of_jurisdiction: str<2> = "us";  // An example of out of jurisdiction (In this case, "US" is out of jurisdiction)
    //assert(jurisdiction != out_of_jurisdiction, "Jurisdiction mismatch");

    //let jurisdiction_vec: Vec<u8> = jurisdiction.as_bytes_vec();
    //println(f"jurisdiction_vec: {jurisdiction_vec}");

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
