#####################################################################################################################
# @notice - This script is new version of Noir's script. Please see more details from Noir's official documentation #
#####################################################################################################################

echo "Clean previous build (./target directory)..."
rm -rf target

echo "Load the environment variables from the .env file..."
source ../.env
#. ./.env

# Extract version from Nargo.toml
VERSION=$(grep '^version = ' Nargo.toml | cut -d '"' -f 2)
echo "Circuit version: $VERSION"

echo "Compiling circuit..."
nargo compile
if [ $? -ne 0 ]; then
  exit 1
fi

echo "Create the target/proof and target/vk directory..."
mkdir -p "target/vk"
mkdir -p "target/proof"

echo "Generate witness..."
nargo execute

echo "Proving and generating a zkProof..."
bb prove -b ./target/with_foundry.json -w ./target/with_foundry.gz -o ./target/proof
#bb prove -b ./target/with_foundry.json -w ./target/with_foundry.gz -o ./target
#bb prove -b ./target/with_foundry.json -w ./target/with_foundry.gz -o ./target/with_foundry_proof.bin

echo "Copy a zkProof-generated and paste it as a with_foundry_proof.bin"
cp ./target/proof/proof ./target/proof/with_foundry_proof.bin

echo "Generating vkey..."
# Generate the verification key. You need to pass the `--oracle_hash keccak` flag when generating vkey and proving
# to instruct bb to use keccak as the hash function, which is more optimal in Solidity
bb write_vk -b ./target/with_foundry.json -o ./target/vk --oracle_hash keccak
#bb write_vk -b ./target/with_foundry.json -o ./target --oracle_hash keccak
#bb write_vk -b ./target/with_foundry.json -o ./target/with_foundry_vk.bin

echo "Copy a vkey-generated and paste it as a with_foundry_vk.bin"
cp ./target/vk/vk ./target/vk/with_foundry_vk.bin

echo "Link vkey to the zkProof"
bb verify -k ./target/vk/with_foundry_vk.bin -p ./target/proof/with_foundry_proof.bin

echo "Check a zkProof"
head -c 32 ./target/proof/with_foundry_proof.bin | od -An -v -t x1 | tr -d $' \n'

echo "Generate a Solidity Verifier contract from the vkey..."
bb write_solidity_verifier -k ./target/vk/with_foundry_vk.bin -o ./target/Verifier.sol
#bb write_solidity_verifier -k ./target/vk -o ./target/Verifier.sol
#bb contract

echo "Copy a Solidity Verifier contract-generated (Verifier.sol) into the ./contracts/circuit/ultra-verifier directory"
cp ./target/Verifier.sol ../contracts/circuit/ultra-verifier

echo "Rename the Verifier.sol with the plonk_vk.sol in the ./contracts/circuit/ultra-verifier directory"
mv ../contracts/circuit/ultra-verifier/Verifier.sol ../contracts/circuit/ultra-verifier/plonk_vk.sol

echo "Done"