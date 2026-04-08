import Irys from "@irys/sdk";
import * as dotenv from "dotenv";
dotenv.config();

async function deployFrontendToArweave() {
  // 1. Initialize the Irys node connected to Polygon for cheaper upload fees
  const irys = new Irys({
    url: "https://node1.irys.xyz",
    token: "matic",
    key: process.env.PRIVATE_KEY, // Funding wallet
  });

  const folderToUpload = "./out"; // The Next.js static build folder

  console.log("Estimating upload cost...");
  // 2. Fund the node if necessary (handling the upfront permanent storage cost)
  const size = await irys.getLoadedBalance(); 
  
  try {
    console.log("Uploading React build to the Permaweb...");
    
    // 3. Upload the entire directory
    // We specify 'index.html' as the fallback index file for routing
    const receipt = await irys.uploadFolder(folderToUpload, {
      indexFile: "index.html",
    });

    console.log(`✅ Deployment successful!`);
    console.log(`🌍 Live URL: https://arweave.net/${receipt.id}`);
  } catch (e) {
    console.error("Error uploading frontend: ", e);
  }
}

deployFrontendToArweave();