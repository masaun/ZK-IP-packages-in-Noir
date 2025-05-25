mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main;
    use crate::data_types::{ RevealedData };
    //use crate::utils;

    use std::hash::pedersen_hash;

    #[test]
    fn test_hospital_bill_proof_verifier() {
        let jurisdiction: u32 = 49;         // Country code - Germany (+49)
        //let jurisdiction: str<2> = "uk";  // An example jurisdiction of the agreement (Country code - i.e. US, UK, etc.)
        //let jurisdiction: BoundedVec<u8, 2> = BoundedVec::from([1, 2]);
        let duration: Field = 7884000;      // 3 month in seconds
        println(f"jurisdiction: {jurisdiction}");
        println(f"duration: {duration}");

        // @dev - [TEST]
        //test_output(jurisdiction);

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

    #[test(should_fail_with = "A ginve jurisdiction is out of jurisdiction")]
    fn test_should_fail_with_out_of_jurisdiction() {
        let jurisdiction: u32 = 1;       // Country code - USA (+1)
        let duration: Field = 7884000;   // 3 month in seconds
        println(f"jurisdiction: {jurisdiction}");

        // @dev - Generate the nullifier
        let nullifier = pedersen_hash([duration]);

        // @dev - Generate a ZKP and publicInput as the "revealed_data"
        let revealed_data: RevealedData = main(
            jurisdiction,
            duration,
            nullifier
        );
    }


    //////////////////////////////
    /// @notice - Test outputs ///
    //////////////////////////////

    #[test]
    fn test_output(jurisdiction: str<2>) {
        let jurisdiction_vec: Vec<u8> = jurisdiction.as_bytes_vec();
        println(f"jurisdiction_vec: {jurisdiction_vec}"); // [Log]: Vec { slice: &[117, 107] }
    }
}
