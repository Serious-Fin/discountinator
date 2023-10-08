import express from "express";
import cors from "cors";
//import "dotenv/config";
import priceRoute from "./api/price.js";
import "./cronJobs/priceChecker.js";
import processPath from "process";

import dotenv from "dotenv";
import path from "path";

const envFilePath = path.resolve(processPath.cwd(), "..", ".env");
dotenv.config({ path: envFilePath });

const app = express();

// set up middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/price", priceRoute);

app.get("/", (req, res) => {
  res.json({ message: "Initial setup looks good" });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
