mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
//mod utils; 
mod zk_kit;

use std::hash::pedersen_hash;
use data_types::{ RevealedData };

fn main(
    jurisdiction: BoundedVec<u8, 2>,  // The jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
    duration: Field,                  // The duration of the agreement (i.e. 3 month in seconds)
    nullifier: Field
) -> pub RevealedData {
    //assert(x == y, "x and y must be equal");

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
