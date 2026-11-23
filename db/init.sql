cat << 'EOF' > db/init.sql
CREATE DATABASE ml_predictions;
CREATE USER ml_app WITH PASSWORD 'CHANGE_ME';
GRANT ALL PRIVILEGES ON DATABASE ml_predictions TO ml_app;

\c ml_predictions

CREATE TABLE predictions (
    id SERIAL PRIMARY KEY,
    input_data TEXT NOT NULL,
    prediction FLOAT NOT NULL,
    model_version VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

GRANT SELECT, INSERT ON TABLE predictions TO ml_app;
GRANT USAGE, SELECT ON SEQUENCE predictions_id_seq TO ml_app;
EOF
