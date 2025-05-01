CREATE TABLE IF NOT EXISTS "Forecasts" (
    "Id" SERIAL PRIMARY KEY,
    "Summary" TEXT,
    "TemperatureC" INTEGER,
    "Date" TIMESTAMP NOT NULL DEFAULT NOW()
);
