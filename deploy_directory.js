const fs = require('fs');
const path = require('path');
const FormData = require('form-data');
const axios = require('axios');

const srcDir = path.resolve('.');

async function pushToPublicIPFS() {
    const data = new FormData();
    let fileCount = 0;
    
    function recursiveFiles(dir, baseDir) {
        const elements = fs.readdirSync(dir);
        for (const el of elements) {
            const fullPath = path.join(dir, el);
            const relativePath = path.relative(baseDir, fullPath);
            
            // Explicitly ignore git histories and node modules for speed and privacy
            if (relativePath.startsWith('.git') || el === 'node_modules' || el === 'deploy_directory.js') {
                continue;
            }
            
            if (fs.statSync(fullPath).isDirectory()) {
                recursiveFiles(fullPath, baseDir);
            } else {
                fileCount++;
                // We name the filepath parameter so the remote gateway expands it as an interactive directory
                data.append('file', fs.createReadStream(fullPath), {
                    filepath: `The-Arna-Vault/${relativePath}`
                });
            }
        }
    }

    console.log("Indexing pristine vault tree (excluding .git backend logs)...");
    recursiveFiles(srcDir, srcDir);

    if (fileCount === 0) {
        console.error("Error: No deployable files discovered.");
        return;
    }

    console.log(`Piping ${fileCount} files natively to an open IPFS staging cluster...`);
    try {
        // Utilizing the direct public multi-part upload endpoint
        const response = await axios.post('https://api.web3.storage/upload', data, {
            maxBodyLength: Infinity,
            maxContentLength: Infinity,
            headers: {
                ...data.getHeaders()
            }
        });
        
        console.log("\nBroadcast Complete!");
        console.log("Root Folder CID:", response.data.cid);
        console.log(`Inspect your open directory directly at: https://ipfs.io/ipfs/${response.data.cid}/The-Arna-Vault/`);
    } catch (err) {
        // Fallback to a secondary public gateway if the upstream router rejects without a token
        console.log("\nUpstream auth required. Switching to alternate public staging network...");
        try {
            const altResponse = await axios.post('https://ipfs-ipfs.4everland.xyz/api/v0/add?pin=true&recursive=true&wrap-with-directory=false', data, {
                maxBodyLength: Infinity,
                headers: {
                    ...data.getHeaders()
                }
            });
            // Public gateways return newline-delimited JSON for multiple files; we fetch the root block
            const lines = altResponse.data.trim().split('\n');
            const finalNode = JSON.parse(lines[lines.length - 1]);
            console.log("\nBroadcast Complete via Public Gateway Layer!");
            console.log("Directory Hash:", finalNode.Hash);
            console.log(`Inspect your folder structure at: https://ipfs.io/ipfs/${finalNode.Hash}/`);
        } catch (altErr) {
            console.error("Transmission Failure Across Alternative Gateways:", altErr.message);
        }
    }
}

pushToPublicIPFS();
