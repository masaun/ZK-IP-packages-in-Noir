mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
//mod utils; 

use std::hash::pedersen_hash;
use data_types::{ RevealedData };

fn main(
    x: Field, 
    y: pub Field,
    //nullifier: Field
) -> pub Field {
//) -> pub RevealedData {
    assert(x == y, "x and y must be equal");

    // let expected_nullifier: Field = pedersen_hash([x, y]);
    // println(f"expected_nullifier: {expected_nullifier}");
    // println(f"nullifier: {nullifier}");
    // assert(expected_nullifier == nullifier, "Nullifier mismatch");

    // @dev - Return
    // let revealed_data = RevealedData {
    //     nullifier: nullifier
    // };
    // revealed_data
    
    //nullifier
    y
}
