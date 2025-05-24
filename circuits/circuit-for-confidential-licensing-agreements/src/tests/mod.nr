mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;
    use crate::data_types::{ RevealedData };
    //use crate::utils;

    use std::hash::pedersen_hash;

    #[test]
    fn test_hospital_bill_proof_verifier() {
        let jurisdiction: Vec<u8> = Vec::from_slice([1, 2]); // Example jurisdiction (could be a country code)
        let duration: Field = 2629743;  // 1 month in seconds
        println(f"jurisdiction: {jurisdiction}");
        println(f"duration: {duration}");

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([duration]);
        println(f"nullifier: {nullifier}");

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            jurisdiction,
            duration,
            nullifier
        );

        // @dev - Check the revealed data, which is the publicInput
        let revealed_data_nullifier = revealed_data.nullifier;
        println(f"revealed_data.nullifier: {revealed_data_nullifier}");
    }

}
