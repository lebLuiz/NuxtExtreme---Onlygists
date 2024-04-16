CREATE TABLE profiles (
    id uuid PRIMARY KEY REFERENCES auth.users (id),
    email VARCHAR NOT NULL,
    username VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    site VARCHAR,
    phone VARCHAR,
    bio VARCHAR,
    avatar_url VARCHAR NOT NULL,
    address jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp NOT NULL,
    payment_connected_account VARCHAR
);