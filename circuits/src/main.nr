mod tests;      // tests/mod.nr
mod data_types; // data_types.nr
//mod utils; 

use std::hash::pedersen_hash;
use data_types::{ RevealedData };

fn main(
    x: Field, 
    y: pub Field,
    nullifier: Field
) -> pub Field {
    assert(x == y, "x and y must be equal");

    let expected_nullifier: Field = pedersen_hash([x, y]);
    assert(expected_nullifier == nullifier, "Nullifier mismatch");

    // @dev - Return
    let revealed_data: RevealedData = RevealedData {
        nullifier: nullifier
    };

    revealed_data.nullifier
}
