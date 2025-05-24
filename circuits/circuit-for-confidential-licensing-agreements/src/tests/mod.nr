mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;
    use crate::data_types::{ RevealedData };
    //use crate::utils;

    use std::hash::pedersen_hash;

    #[test]
    fn test_hospital_bill_proof_verifier() {
        let x: Field = 3;
        let y: Field = 3;
        println(f"x: {x}");
        println(f"y: {y}");

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([x, y]);
        println(f"nullifier: {nullifier}");

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            x,
            y,
            nullifier
        );

        // @dev - Check the revealed data, which is the publicInput
        let revealed_data_nullifier = revealed_data.nullifier;
        println(f"revealed_data.nullifier: {revealed_data_nullifier}");
    }

}
